/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for managing Salons
 **/
public with sharing class SalonController {
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is used not to insert another warehouse
   **/
  public static void avoidDuplicateWarehouses(List<Salon__c> inSalons) {
    if (inSalons == null) {
      return;
    }
    Set<Id> salonsAccsID = new Set<Id>();
    List<Salon__c> newWarehouses = new List<Salon__c>();
    for (Salon__c salon : inSalons) {
      if (salon.Warehouse__c) {
        salonsAccsID.add(salon.Account__c);
        newWarehouses.add(salon);
      }
    }
    // Retrieve all related Warehouses from database
    List<Salon__c> warehouses = [
      SELECT Id, Account__c
      FROM Salon__c
      WHERE Warehouse__c = TRUE AND Account__c IN :salonsAccsID
    ];

    //Map number of warehouses to Accounts
    Map<Id, Integer> numberOfWarehouses = new Map<Id, Integer>();
    //Put in the map warehouses from DB
    for (Salon__c warehouse : warehouses) {
      numberOfWarehouses.put(warehouse.Account__c, 1);
    }

    for (Salon__c warehouse : newWarehouses) {
      if (numberOfWarehouses.containsKey(warehouse.Account__c)) {
        Integer newValue = numberOfWarehouses.get(warehouse.Account__c) + 1;
        numberOfWarehouses.put(warehouse.Account__c, newValue);
      } else {
        numberOfWarehouses.put(warehouse.Account__c, 1);
      }
    }

    for (Salon__c warehouse : newWarehouses) {
      if (numberOfWarehouses.get(warehouse.Account__c) > 1) {
        warehouse.addError(Constant.SALON_CONTROLLER_ERROR_MESSAGE_WAREHOUSE);
      }
    }
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is used for moving cars into warehouses
   **/
  public static void transferToWarehouse(
    List<Salon__c> inSalons,
    Map<Id, Salon__c> inSalonsOldMap
  ) {
    if (inSalons == null) {
      return;
    }

    //Check how many salons changed their status to closed and use them
    List<Salon__c> salonsClosing = new List<Salon__c>();
    for (Salon__c salon : inSalons) {
      if (
        inSalonsOldMap.get(salon.Id).Status__c != salon.Status__c &&
        salon.Status__c == Constant.SALON_STATUS_CLOSED
      ) {
        salonsClosing.add(salon);
      }
    }
    if (salonsClosing.size() == 0) {
      return;
    }
    SalonControllerQue job = new SalonControllerQue();
    job.salons = salonsClosing;
    ID jobID = System.enqueueJob(job);

    // Retrieve all related Warehouses
    Set<Id> salonsAccsID = new Set<Id>();
    for (Salon__c salon : salonsClosing) {
      salonsAccsID.add(salon.Account__c);
    }

    List<Salon__c> warehouses = [
      SELECT Id, Account__c
      FROM Salon__c
      WHERE Warehouse__c = TRUE AND Account__c IN :salonsAccsID
    ];

    //Retrieve all related vehicles from database
    List<Vehicle__c> vehicles = [
      SELECT Salon__c
      FROM Vehicle__c
      WHERE Salon__c IN :salonsClosing
    ];
    //Map warehouses to Account.
    Map<Id, Id> warehousesMappedtoAccount = new Map<Id, Id>();
    for (Salon__c warehouse : warehouses) {
      warehousesMappedtoAccount.put(warehouse.Account__c, warehouse.Id);
    }
    //Map accounts to closing salons
    Map<Id, Id> closingSalonsMappedtoAccount = new Map<Id, Id>();
    for (Salon__c closingSalon : salonsClosing) {
      closingSalonsMappedtoAccount.put(
        closingSalon.Id,
        closingSalon.Account__c
      );
    }
    //Transfer vehicles to warehouses related to their original account
    for (Vehicle__c vehicle : vehicles) {
      Id value = closingSalonsMappedtoAccount.get(vehicle.Salon__c);
      vehicle.Salon__c = warehousesMappedtoAccount.get(value);
    }
    update vehicles;

    //Retrieve all related car offers from database
    List<Car_Posting__c> carOffers = [
      SELECT Salon__c
      FROM Car_Posting__c
      WHERE Salon__c IN :salonsClosing
    ];

    List<Car_Posting__c> carOffersToDelete = new List<Car_Posting__c>();
    //Delete related offers
    for (Car_Posting__c carOffer : carOffers) {
      carOffersToDelete.add(carOffer);
    }
    delete carOffersToDelete;
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is used to update parking slots field
   **/
  public static void updateParkingSlots(
    List<Salon__c> inSalons,
    Map<Id, Salon__c> inSalonsOldMap
  ) {
    if (inSalons == null) {
      return;
    }
    List<Id> salonsSlotsChanged = new List<Id>();
    for (Salon__c salon : inSalons) {
      if (
        inSalonsOldMap.get(salon.Id).Parking_slots__c > salon.Parking_slots__c
      ) {
        salonsSlotsChanged.add(salon.Id);
      }
    }
    if (salonsSlotsChanged.size() == 0) {
      return;
    }

    List<Vehicle__c> vehicles = [
      SELECT Salon__c
      FROM Vehicle__c
      WHERE Salon__c IN :salonsSlotsChanged
    ];
    // Map parking slots taken by vehicles to Salon IDs
    Map<Id, Integer> parkingSlotsTaken = new Map<Id, Integer>();

    for (Vehicle__c vehicle : vehicles) {
      if (parkingSlotsTaken.containsKey(vehicle.Salon__c)) {
        Integer newValue = parkingSlotsTaken.get(vehicle.Salon__c) + 1;
        parkingSlotsTaken.put(vehicle.Salon__c, newValue);
      } else {
        parkingSlotsTaken.put(vehicle.Salon__c, 1);
      }
    }
    // Add error if there will be less places than before update
    for (Salon__c salon : inSalons) {
      if (salon.Parking_slots__c < parkingSlotsTaken.get(salon.Id)) {
        salon.addError(Constant.SALON_CONTROLLER_ERROR_MESSAGE_PARKING);
      }
    }
  }
}
