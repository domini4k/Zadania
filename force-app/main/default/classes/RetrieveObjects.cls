/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for reciving Vehicles to another company using REST API
 **/
@RestResource(urlMapping='/v1/RetrieveObjects/*')
global with sharing class RetrieveObjects {
  @HttpGet
  global static String retrieve() {
    RestRequest req = RestContext.request;
    String objectName = req.headers.get('objects');
    String result;
    ID parentName = Id.valueOf(req.headers.get('parentName'));
    if (objectName == 'Accounts'){   

        List<Account> listAccount =[Select Name from Account];
        result = JSON.serialize(listAccount);
        
    }
    else {
        
        if (objectName == 'Salons'){
            List<Salon__c> listSalons = [SELECT Name FROM Salon__c WHERE Account__c = parentName];
            result = JSON.serialize(listSalons);
        }
        else if (objectName == 'Vehicles'){
            List<Vehicle__c> listVehicles = [SELECT Name FROM Vehicle__c WHERE Salon__c = parentName];
            result = JSON.serialize(listVehicles);
        }
    }
    return result;
  }
}
