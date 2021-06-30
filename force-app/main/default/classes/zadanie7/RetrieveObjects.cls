/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for reciving Vehicles to another company using REST API
 **/
@RestResource(urlMapping='/v1/RetrieveObjects/*')
global with sharing class RetrieveObjects {
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description Get method
   **/
  @HttpGet
  global static String retrieve() {
    RestRequest req = RestContext.request;
    Map<String, String> headers = req.headers;
    
    String objectName = headers.get('ObjectName');
    String parentID;
    ID parentName;
    if (objectName != 'Accounts'){
      parentID = headers.get('ParentID');
      parentName = Id.valueOf(parentID);
    }
    String result;
    
    if (objectName == 'Accounts'){   
        List<Account> listAccount =[Select Name from Account];
        result = JSON.serialize(listAccount);
    }
    else {
        if (objectName == 'Salons'){
            List<Salon__c> listSalons = [SELECT Name FROM Salon__c WHERE Account__c = :parentName];
            result = JSON.serialize(listSalons);
        }
        else if (objectName == 'Vehicles'){
            List<Vehicle__c> listVehicles = [SELECT Brand__c, Car_model__c FROM Vehicle__c WHERE Salon__c = :parentName];
            result = JSON.serialize(listVehicles);
        }
    }
    return result;
  }
}
