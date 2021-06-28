/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for testing batch deleting telemetry data
 **/
@isTest
private with sharing class DeleteTelemertryBatchTest {
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for test setup 
   **/
  @testSetup
  static void setup() {
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
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is actuall test
   **/
  @isTest
  static void checkIfDeleted() {
    Test.startTest();
    DeleteTelemetryBatch dtb = new DeleteTelemetryBatch();
    Id batchId = Database.executeBatch(dtb);
    Test.stopTest();

    List<Id> vehsID = new List<Id>();
    List<Vehicle__c> vehs = [
      SELECT Id
      FROM Vehicle__c
      WHERE Serial_number__c = '4GHBV58MNBV852852'
    ];
    for (Vehicle__c veh : vehs) {
      vehsID.add(veh.Id);
    }
    System.assertEquals(
      0,
      [SELECT COUNT() FROM Telemetry__c WHERE Vehicle__c IN :vehsID]
    );
  }
}
