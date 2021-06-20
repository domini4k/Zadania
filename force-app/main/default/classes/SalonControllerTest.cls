/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for testing SalonController class
 **/
@isTest
private with sharing class SalonControllerTest {
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing SalonController class
   **/
  @isTest
  static void setStatusToClosed() {
    String serialNumberTest = '4GHBV58MNBV852369';
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> warehouses = TestDataFactory.Salons(
      160,
      accs,
      100,
      true,
      'Open',
      true
    );
    List<Salon__c> salons = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Vehicle__c> vehs = new List<Vehicle__c>();
    for (Integer i = 0; i < 160; i++) {
      Vehicle__c veh = new Vehicle__c(
        Salon__c = salons[i].Id,
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = serialNumberTest
      );
      vehs.add(veh);
    }
    insert vehs;
    List<Car_Posting__c> carOffers = TestDataFactory.carOffers(
      160,
      vehs,
      salons,
      false,
      true
    );
    List<Car_Posting__c> carOffersTest = TestDataFactory.carOffers(
      160,
      vehs,
      salons,
      true,
      true
    );

    for (Salon__c salon : salons) {
      salon.Status__c = 'Closed';
    }

    //Start test
    Test.startTest();
    List<Database.SaveResult> results = Database.update(salons, false);
    Test.stopTest();

    //Retrieve results
    List<Vehicle__c> vehsAfterTest = [
      SELECT Salon__c, Salon__r.Account__c
      FROM Vehicle__c
      WHERE Serial_number__c = '4GHBV58MNBV852369'
    ];
    List<Salon__c> warehousesTest = [
      SELECT Id, Account__c
      FROM Salon__c
      WHERE Warehouse__c = TRUE
    ];

    Map<Vehicle__c, Salon__c> warehousesMappedTest = new Map<Vehicle__c, Salon__c>();
    for (Vehicle__c veh : vehsAfterTest) {
      for (Salon__c warehouse : warehousesTest) {
        if (warehouse.Account__c == veh.Salon__r.Account__c) {
          warehousesMappedTest.put(veh, warehouse);
        }
      }
    }

    List<Car_Posting__c> carOffersAfter = [
      SELECT Id
      FROM Car_Posting__c
      WHERE Vehicle__r.Serial_number__c = '4GHBV58MNBV852369'
    ];

    //Compare them to expected values
    for (Integer i = 0; i < results.size(); i++) {
      System.assert(results[i].isSuccess());
      System.assert(results[i].getErrors().size() == 0);
      System.assert(
        vehsAfterTest[i].Salon__c ==
        warehousesMappedTest.get(vehsAfterTest[i]).Id
      );
    }
    System.assert(carOffersAfter.size() == 0);
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing SalonController class
   **/
  @isTest
  static void updateSalonNotClosing() {
    String serialNumberTest = '4GHBV58MNBV852369';
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> warehouses = TestDataFactory.Salons(
      160,
      accs,
      100,
      true,
      'Open',
      true
    );
    List<Salon__c> salons = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Vehicle__c> vehs = new List<Vehicle__c>();
    for (Integer i = 0; i < 160; i++) {
      Vehicle__c veh = new Vehicle__c(
        Salon__c = salons[i].Id,
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = serialNumberTest
      );
      vehs.add(veh);
    }
    insert vehs;

    List<Car_Posting__c> carOffers = TestDataFactory.carOffers(
      160,
      vehs,
      salons,
      false,
      true
    );
    List<Car_Posting__c> carOffersTest = TestDataFactory.carOffers(
      160,
      vehs,
      salons,
      true,
      true
    );

    for (Salon__c salon : salons) {
      salon.Status__c = 'Open';
    }

    //Start test
    Test.startTest();
    List<Database.SaveResult> results = Database.update(salons, false);
    Test.stopTest();

    //Retrieve results
    List<Vehicle__c> vehsAfterTest = [
      SELECT Salon__c, Salon__r.Account__c
      FROM Vehicle__c
      WHERE Serial_number__c = '4GHBV58MNBV852369'
    ];
    List<Salon__c> warehousesTest = [
      SELECT Id, Account__c
      FROM Salon__c
      WHERE Warehouse__c = TRUE
    ];

    Map<Vehicle__c, Salon__c> warehousesMappedTest = new Map<Vehicle__c, Salon__c>();
    for (Vehicle__c veh : vehsAfterTest) {
      for (Salon__c warehouse : warehousesTest) {
        if (warehouse.Account__c == veh.Salon__r.Account__c) {
          warehousesMappedTest.put(veh, warehouse);
        }
      }
    }

    List<Car_Posting__c> carOffersAfter = [
      SELECT Id
      FROM Car_Posting__c
      WHERE Vehicle__r.Serial_number__c = '4GHBV58MNBV852369'
    ];

    //Compare them to expected values
    for (Integer i = 0; i < 160; i++) {
      System.assert(results[i].isSuccess());
      System.assert(results[i].getErrors().size() == 0);
    }
    System.assert(carOffersAfter.size() == 320);
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing SalonController class
   **/
  @isTest
  static void testAddDuplicateWarehouse() {
    String mssg = Constant.salonControllerErrorMessageWarehouse;
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> warehouses = TestDataFactory.Salons(
      160,
      accs,
      100,
      true,
      'Open',
      true
    );
    List<Salon__c> salons = TestDataFactory.Salons(
      160,
      accs,
      100,
      true,
      'Open',
      false
    );

    Test.startTest();
    Database.SaveResult[] results = Database.insert(salons, false);
    Test.stopTest();

    for (Integer i = 0; i < results.size(); i++) {
      System.assert(!results[i].isSuccess());
      System.assert(results[i].getErrors().size() > 0);
      System.assertEquals(mssg, results[i].getErrors()[0].getMessage());
    }
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing SalonController class
   **/
  @isTest
  static void testAddDuplicateWarehouseScript() {
    String mssg = Constant.salonControllerErrorMessageWarehouse;
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> warehouses = TestDataFactory.Salons(
      80,
      accs,
      100,
      true,
      'Open',
      false
    );
    List<Salon__c> salons = TestDataFactory.Salons(
      80,
      accs,
      100,
      true,
      'Open',
      false
    );

    warehouses.addAll(salons);

    Test.startTest();
    Database.SaveResult[] results = Database.insert(warehouses, false);
    Test.stopTest();

    for (Integer i = 0; i < results.size(); i++) {
      System.assert(!results[i].isSuccess());
      System.assert(results[i].getErrors().size() > 0);
      System.assertEquals(mssg, results[i].getErrors()[0].getMessage());
    }
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing SalonController class
   **/
  @isTest
  static void setWrongNumberParkingSlots() {
    String mssg = Constant.salonControllerErrorMessageParking;
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> salons = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );

    List<Vehicle__c> vehs = TestDataFactory.Vehicles(
      160,
      salons,
      '4GHBV58MNBV852'
    );

    for (Salon__c salon : salons) {
      salon.Parking_slots__c = 0;
    }

    Test.startTest();
    Database.SaveResult[] results = Database.update(salons, false);
    Test.stopTest();

    for (Integer i = 0; i < results.size(); i++) {
      System.assert(!results[i].isSuccess());
      System.assert(results[i].getErrors().size() > 0);
      System.assertEquals(mssg, results[i].getErrors()[0].getMessage());
    }
  }
}
