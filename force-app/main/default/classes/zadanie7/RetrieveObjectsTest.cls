/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for testing RestResource
 **/
@isTest
public with sharing class RetrieveObjectsTest {
    /**
     * @author Pawel Dominiak <pawel.dominiak@accenture.com>
     * @date 16/06/2021
     * @description This method is for testing RestResource
     **/
    @isTest
    static void testHttpPostAcc() {
    
    List<Account> accs = TestDataFactory.Accounts(160);
    
    RestRequest req = new RestRequest(); 
    req.requestURI = Constant.ENDPOINT_SHARK + 'apexrest/v1/RetrieveObjects/';
    req.addHeader(Constant.CONTENT_TYPE, Constant.APPLICATION);
    req.httpMethod = Constant.REST_GET;
    req.addHeader(Constant.OBJECT_NAME, Constant.ACCOUNTS);
    RestContext.request = req;

    Test.startTest();
    String result = RetrieveObjects.retrieve();
    Test.stopTest();
    
    List<Account> res = (List<Account>)JSON.deserialize(result, List<Account>.class);
    List<Account> dtbRes = [SELECT Id FROM Account];
    System.assertEquals(dtbRes.size(), res.size());
    
}
    /**
     * @author Pawel Dominiak <pawel.dominiak@accenture.com>
     * @date 16/06/2021
     * @description This method is for testing RestResource
     **/
    @isTest
    static void testHttpPostSal() {
    
    Account acc = new Account(Name='acc');
    insert acc;
    List<Salon__c> salons = new List<Salon__c>();
    for (Integer i = 0; i < 160; i++) {
      Salon__c salon = new Salon__c(
        Account__c = acc.Id,
        Name = 'salon' + i,
        Parking_slots__c = 100,
        Warehouse__c = false,
        Status__c = Constant.SALON_STATUS_OPEN
      );
      salons.add(salon);
    }
    insert salons;
    
    RestRequest req = new RestRequest(); 
    req.requestURI = Constant.ENDPOINT_SHARK + 'apexrest/v1/RetrieveObjects/';
    req.addHeader(Constant.CONTENT_TYPE, Constant.APPLICATION);
    req.httpMethod = Constant.REST_GET;
    req.addHeader(Constant.OBJECT_NAME, Constant.SALONS);
    req.addHeader(Constant.PARENT_ID, acc.Id);
    RestContext.request = req;

    Test.startTest();
    String result = RetrieveObjects.retrieve();
    Test.stopTest();
    
    List<Salon__c> dtbRes = [SELECT Id FROM Salon__c WHERE Account__c = :acc.Id];
    List<Salon__c> res = (List<Salon__c>)JSON.deserialize(result, List<Salon__c>.class);
    System.assertEquals(dtbRes.size(), res.size());
    }
    
    /**
     * @author Pawel Dominiak <pawel.dominiak@accenture.com>
     * @date 16/06/2021
     * @description This method is for testing RestResource
     **/
    @isTest
    static void testHttpPostVeh() {
    
    Account acc = new Account(Name='acc');
    insert acc;
    Salon__c salon = new Salon__c(
        Account__c = acc.Id,
        Name = 'salon',
        Parking_slots__c = 170,
        Warehouse__c = false,
        Status__c = Constant.SALON_STATUS_OPEN
      );
    insert salon;
    List<Vehicle__c> vehs = new List<Vehicle__c>();
    for (Integer i = 0; i < 160; i++) {
      Vehicle__c veh = new Vehicle__c(
        Salon__c = salon.Id,
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = '4GHBV58MNBV852' + (i + 100)
      );
      vehs.add(veh);
    }
    insert vehs;
    
    RestRequest req = new RestRequest(); 
    req.requestURI = Constant.ENDPOINT_SHARK + 'apexrest/v1/RetrieveObjects/';
    req.addHeader(Constant.CONTENT_TYPE, Constant.APPLICATION);
    req.httpMethod = Constant.REST_GET;
    req.addHeader(Constant.OBJECT_NAME, Constant.VEHICLES);
    req.addHeader(Constant.PARENT_ID, salon.Id);
    RestContext.request = req;

    Test.startTest();
    String result = RetrieveObjects.retrieve();
    Test.stopTest();
    
    List<Vehicle__c> dtbRes = [SELECT Id FROM Vehicle__c WHERE Salon__c = :salon.Id];
    List<Vehicle__c> res = (List<Vehicle__c>)JSON.deserialize(result, List<Vehicle__c>.class);
    System.assertEquals(dtbRes.size(), res.size());
    
}
}
