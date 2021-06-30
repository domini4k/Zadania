/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for testing RestResource
 **/
@isTest
public with sharing class UpdateCheckboxReceiveTest {
    /**
     * @author Pawel Dominiak <pawel.dominiak@accenture.com>
     * @date 16/06/2021
     * @description This method is for testing RestResource
     **/
    @isTest
    static void testHttpPost() {
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> salons = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      Constant.SALON_STATUS_OPEN,
      true
    );
    List<Vehicle__c> vehs = new List<Vehicle__c>();
    for (Integer i = 0; i < 160; i++) {
      Vehicle__c veh = new Vehicle__c(
        Salon__c = salons[i].Id,
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = '4GHBV58MNBV852888',
        Transfer_to_another_company__c = false
      );
      vehs.add(veh);
    }
    insert vehs;
    List<Id> vehsId = new List<Id>();
    for (Vehicle__c veh : vehs){
        vehsId.add(veh.Id);
    }

    RestRequest req = new RestRequest(); 
    req.requestBody = Blob.valueOf(JSON.serialize(vehsId));
    req.requestURI = 'https://wise-shark-ppge52-dev-ed.my.salesforce.com/services/apexrest/v1/postVehiclesUpdate/';
    req.addHeader('Content-Type', 'application/json');
    req.httpMethod = 'POST';
    RestContext.request = req;

    Test.startTest();
    UpdateCheckboxReceive.receiveVeh();
    Test.stopTest();

    List<Vehicle__c> vehsAfter = [SELECT Id, Transfer_to_another_company__c FROM Vehicle__c WHERE Serial_number__c = '4GHBV58MNBV852888'];
    for (Vehicle__c veh : vehsAfter){
        System.assertEquals(veh.Transfer_to_another_company__c, true);
    }
    }
}
