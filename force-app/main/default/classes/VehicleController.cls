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
    List<Id> vehiclesID = new List<Id>();
    for (Vehicle__c vehicle : inVehicles) {
      vehiclesID.add(vehicle.Id);
    }
    //Retrieve all related telemetry data
    List<Telemetry__c> data = [
      SELECT Vehicle__c
      FROM Telemetry__c
      WHERE Vehicle__c IN :vehiclesID
    ];

    List<Telemetry__c> dataToDelete = new List<Telemetry__c>();
    List<Case> newCases = new List<Case>();

    for (Vehicle__c vehicle : inVehicles) {
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
    //Pick all telemetry data for each vehicle
    for (Telemetry__c telemetry : data) {
      dataToDelete.add(telemetry);
    }
    delete dataToDelete;
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
        for (Vehicle__c vehicle : inVehicles) {
          if (vehicle.Salon__c == salon.Id) {
            vehicle.addError(
              'There are not enough parking spots for vehicles in this salon ' +
              salon.Name
            );
          }
        }
      }
    }
  }
}
