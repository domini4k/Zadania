@isTest
private with sharing class VehicleControllerTest {
  @isTest
  static void VehicleDelete() {
    //create sample data
    List<Vehicle__c> vehs = new List<Vehicle__c>();
    for (Integer i = 0; i < 160; i++) {
      Vehicle__c veh = new Vehicle__c(
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = '4GHBV58MNBV852852'
      );
      vehs.add(veh);
    }
    insert vehs;

    List<Telemetry__c> tels = new List<Telemetry__c>();
    for (Integer i = 0; i < 160; i++) {
      Telemetry__c tel = new Telemetry__c(Vehicle__c = vehs[i].Id);
      tels.add(tel);
    }
    insert tels;

    Test.startTest();
    Database.DeleteResult[] results = Database.delete(vehs, false);
    Test.stopTest();

    List<Telemetry__c> telsDeleted = [
      SELECT Id
      FROM Telemetry__c
      WHERE Vehicle__r.Serial_number__c = '4GHBV58MNBV852852'
    ];
    List<Case> cases = [
      SELECT Id
      FROM Case
      WHERE Subject = 'Car 4GHBV58MNBV852852 was succesfully disposed'
    ];
    System.debug(cases.size());
    for (Database.DeleteResult dr : results) {
      System.assert(dr.isSuccess());
      System.assert(dr.getErrors().size() == 0);
    }
    System.assert(telsDeleted.size() == 0);
    System.assert(cases.size() == 160);
  }
  @isTest
  static void addVehicle() {
    //create sample data
    List<Account> accs = new List<Account>();
    for (Integer i = 0; i < 160; i++) {
      Account acc = new Account(Name = 'acc' + i);
      accs.add(acc);
    }
    insert accs;

    List<Salon__c> salons = new List<Salon__c>();
    for (Integer i = 0; i < 160; i++) {
      Salon__c salon = new Salon__c(
        Account__c = accs[i].Id,
        Name = 'salon' + i,
        Parking_slots__c = 1
      );
      salons.add(salon);
    }
    insert salons;

    List<Vehicle__c> vehs = new List<Vehicle__c>();
    for (Integer i = 0; i < 160; i++) {
      Vehicle__c veh = new Vehicle__c(
        Salon__c = salons[i].Id,
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = '4GHBV58MNBV852852'
      );
      vehs.add(veh);
    }
    insert vehs;

    List<Vehicle__c> vehsTest = new List<Vehicle__c>();
    for (Integer i = 0; i < 160; i++) {
      Vehicle__c vehTest = new Vehicle__c(
        Salon__c = salons[i].Id,
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = '4GHBV58MNBV852852'
      );
      vehsTest.add(vehTest);
    }

    //Start test
    Test.startTest();
    List<Database.SaveResult> results = Database.insert(vehsTest, false);
    Test.stopTest();

    for (Integer i = 0; i < results.size(); i++) {
      System.assert(!results[i].isSuccess());
      System.assert(results[i].getErrors().size() > 0);
      System.assertEquals(
        'There are not enough parking spots for vehicles in this salon ' +
        salons[i].Name,
        results[i].getErrors()[0].getMessage()
      );
    }
  }
}
