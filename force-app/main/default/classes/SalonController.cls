public with sharing class SalonController {
  public static void transferToWarehouse(List<Salon__c> salons) {
    // Retrieve all Warehouses
    List<Salon__c> warehouses = [
      SELECT Id, Account__c
      FROM Salon__c
      WHERE Warehouse__c = TRUE
    ];

    List<Account> accs = [SELECT Id FROM Account];

    Map<Id, Integer> numberOfWarehouses = new Map<Id, Integer>();
    for (Account acc : accs) {
      Integer count = 0;
      for (Salon__c warehouse : warehouses) {
        if (warehouse.Account__c == acc.Id) {
          count++;
        }
      }
      for (Salon__c salon : salons) {
        if (salon.Account__c == acc.Id && salon.Warehouse__c == true) {
          count++;
        }
      }
      numberOfWarehouses.put(acc.Id, count);
    }
    for (Salon__c salon : salons) {
      if (
        numberOfWarehouses.get(salon.Account__c) > 1 &&
        salon.Warehouse__c == true
      ) {
        salon.addError(
          'There can be only one warehouse related to specific account'
        );
      }
    }
    //Check if any salon from list has 'Closed' as a status
    //If not exit function, If yes use another list to save on iteration
    List<Salon__c> salonsClosing = new List<Salon__c>();
    for (Salon__c salon : salons) {
      if (salon.Status__c == 'Closed') {
        salonsClosing.add(salon);
      }
    }
    if (salonsClosing.size() == 0) {
      return;
    }

    //Retrieve all vehicles from database
    List<Vehicle__c> vehicles = [SELECT Salon__r.Id FROM Vehicle__c];

    //Map warehouses to salons. Every salon has only one related account.
    //Solution not quite elegant but I could not find other way
    Map<Salon__c, Salon__c> warehousesMapped = new Map<Salon__c, Salon__c>();
    for (Salon__c salon : salons) {
      for (Salon__c warehouse : warehouses) {
        if (warehouse.Account__c == salon.Account__c) {
          warehousesMapped.put(salon, warehouse);
        }
      }
    }
    //Check if any vehicle is listed in closing salon. If yes, change lookup realtionship value
    for (Salon__c salon : salonsClosing) {
      Salon__c warehouseToStore = warehousesMapped.get(salon);
      for (Vehicle__c vehicle : vehicles) {
        if (vehicle.Salon__r.Id == salon.Id) {
          vehicle.Salon__c = warehouseToStore.Id;
        }
      }
    }
    update vehicles;

    //Retrieve all car offers from database
    List<Car_Posting__c> carOffers = [SELECT Salon__r.Id FROM Car_Posting__c];
    List<Car_Posting__c> carOffersToDelete = new List<Car_Posting__c>();

    //Check what offers are related to closing salon and delete them
    for (Salon__c salon : salonsClosing) {
      for (Car_Posting__c carOffer : carOffers) {
        if (carOffer.Salon__r.Id == salon.Id) {
          carOffersToDelete.add(carOffer);
        }
      }
    }
    delete carOffersToDelete;
  }

  public static void updateParkingSlots(List<Salon__c> salons) {
    List<Vehicle__c> vehicles = [SELECT Salon__c FROM Vehicle__c];
    Map<Salon__c, Integer> parkingSlotsTaken = new Map<Salon__c, Integer>();

    for (Salon__c salon : salons) {
      Integer parkingSlots = 0;
      for (Vehicle__c vehicle : vehicles) {
        if (vehicle.Salon__c == salon.Id) {
          parkingSlots++;
        }
      }
      parkingSlotsTaken.put(salon, parkingSlots);
    }

    for (Salon__c salon : salons) {
      if (salon.Parking_slots__c < parkingSlotsTaken.get(salon)) {
        salon.addError('There are more vehicles than desired parking spots');
      }
    }
  }
}
