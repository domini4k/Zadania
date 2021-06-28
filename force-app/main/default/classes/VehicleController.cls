/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for managing Vehicles
 **/
public with sharing class VehicleController {
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is used to delete telemetry data related to vehicle
   **/
  public static void VehicleDeletion(List<Vehicle__c> inVehicles) {
    if (inVehicles == null) {
      return;
    }
    //Check which vehicles to delete and which send to antoher company
    List<Vehicle__c> vehiclesToTransport = new List<Vehicle__c>();
    List<Vehicle__c> vehiclesToDelete = new List<Vehicle__c>();
    List<Id> vehiclesID = new List<Id>();
    for (Vehicle__c vehicle : inVehicles) {
      if (vehicle.Transfer_to_another_company__c == true) {
        vehiclesToTransport.add(vehicle);
      } else {
        vehiclesID.add(vehicle.Id);
        vehiclesToDelete.add(vehicle);
      }
    }
    //Send vehicles to another company
    if (vehiclesToTransport != null) {
      SendVehicleUsingRESTAPI job = new SendVehicleUsingRESTAPI();
      job.vehicles = vehiclesToTransport;
      ID jobID = System.enqueueJob(job);
    }
    //Retrieve all related telemetry data
    List<Telemetry__c> data = [
      SELECT Vehicle__c
      FROM Telemetry__c
      WHERE Vehicle__c IN :vehiclesID
    ];

    List<Case> newCases = new List<Case>();

    for (Vehicle__c vehicle : vehiclesToDelete) {
      //Create case for each vehicle
      Case newCase = new Case(
        Status = 'New',
        Origin = 'Web',
        Subject = 'Car ' +
          vehicle.Serial_number__c +
          ' was succesfully disposed',
        Description = 'Parameters: ' +
          '\n' +
          'Brand: ' +
          vehicle.Brand__c +
          '\n' +
          'Model: ' +
          vehicle.Car_model__c +
          '\n' +
          'Serial number: ' +
          vehicle.Serial_number__c
      );

      newCases.add(newCase);
    }
    insert newCases;
    delete data;
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is used to check if it possible to add vehicle
   **/
  public static void addVechicle(List<Vehicle__c> inVehicles) {
    if (inVehicles == null) {
      return;
    }
    Set<Id> relatedSalons = new Set<Id>();
    for (Vehicle__c vehicle : inVehicles) {
      relatedSalons.add(vehicle.Salon__c);
    }

    List<Vehicle__c> vehiclesToCheck = [
      SELECT Salon__c
      FROM Vehicle__c
      WHERE Salon__c IN :relatedSalons
    ];

    //Map how many slots are taken in related salon
    Map<Id, Integer> parkingSlotsTaken = new Map<Id, Integer>();
    for (Vehicle__c vehicle : vehiclesToCheck) {
      if (parkingSlotsTaken.containsKey(vehicle.Salon__c)) {
        Integer newValue = parkingSlotsTaken.get(vehicle.Salon__c) + 1;
        parkingSlotsTaken.put(vehicle.Salon__c, newValue);
      } else {
        parkingSlotsTaken.put(vehicle.Salon__c, 1);
      }
    }
    // Map how many slots are about to be taken after insert
    Map<Id, Integer> parkingSlotsInsert = new Map<Id, Integer>();
    for (Vehicle__c vehicle : inVehicles) {
      if (parkingSlotsInsert.containsKey(vehicle.Salon__c)) {
        Integer newValue = parkingSlotsInsert.get(vehicle.Salon__c) + 1;
        parkingSlotsInsert.put(vehicle.Salon__c, newValue);
      } else {
        parkingSlotsInsert.put(vehicle.Salon__c, 1);
      }
    }
    List<Salon__c> salonsToCheck = [
      SELECT Name, Parking_slots__c
      FROM Salon__c
      WHERE Id IN :relatedSalons
    ];

    Map<Id, List<Vehicle__c>> vehiclesMappedToSalon = new Map<Id, List<Vehicle__c>>();
    for (Vehicle__c vehicle : inVehicles) {
      if (vehiclesMappedToSalon.containsKey(vehicle.Salon__c)) {
        List<Vehicle__c> vehsList = vehiclesMappedToSalon.get(vehicle.Salon__c);
        vehsList.add(vehicle);
        vehiclesMappedToSalon.put(vehicle.Salon__c, vehsList);
      } else {
        vehiclesMappedToSalon.put(
          vehicle.Salon__c,
          new List<Vehicle__c>{ vehicle }
        );
      }
    }

    //Check if there are not enough place
    for (Salon__c salon : salonsToCheck) {
      if (parkingSlotsTaken.get(salon.Id) == null) {
        parkingSlotsTaken.put(salon.Id, 0);
      }
      if (parkingSlotsInsert.get(salon.Id) == null) {
        parkingSlotsInsert.put(salon.Id, 0);
      }
      if (
        salon.Parking_slots__c - parkingSlotsTaken.get(salon.Id) -
        parkingSlotsInsert.get(salon.Id) < 0
      ) {
        //find vehicles related to salon where there is not enough place
        List<Vehicle__c> vehsList = vehiclesMappedToSalon.get(salon.Id);
        for (Vehicle__c vehicle : vehsList) {
          vehicle.addError(
            Constant.VEHICLE_CONTROLLER_ERROR_MESSAGE + salon.Name
          );
        }
      }
    }
  }
}
