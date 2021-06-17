/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for testing VehicleController class
 **/
@isTest
private with sharing class VehicleControllerTest {
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing VehicleController class
   **/
  @isTest
  static void VehicleDelete() {
    //create sample data
    String serialNumber = '4GHBV58MNBV852852';
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
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing VehicleController class
   **/
  @isTest
  static void addVehicle() {
    //create sample data
    String mssg = 'There are not enough parking spots for vehicles in this salon ';
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> salons = TestDataFactory.Salons(
      160,
      accs,
      1,
      false,
      'Open',
      true
    );
    List<Vehicle__c> vehs = TestDataFactory.Vehicles(
      160,
      salons,
      '4GHBV58MNBV852'
    );

    List<Vehicle__c> vehsTest = new List<Vehicle__c>();
    for (Integer i = 0; i < 160; i++) {
      Vehicle__c vehTest = new Vehicle__c(
        Salon__c = salons[i].Id,
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = '4GHBV58MNBV852' + (i + 100)
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
        mssg + salons[i].Name,
        results[i].getErrors()[0].getMessage()
      );
    }
  }
}
