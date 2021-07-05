public with sharing class ObjectController {
    
    @AuraEnabled
    public static List<Account> accounts() {
        HttpResponse res = ReceiveObjectsInfoRESTAPI.callGetObjects('Accounts', null);
        String trimmedResponse = res.getBody().unescapeCsv().remove('\\');
            
        List<Account> acctList = (List<Account>) JSON.deserialize(
        trimmedResponse, List<Account>.class);
        
        return acctList;
    }
    @AuraEnabled
    public static List<Salon__c> salons(Id accId) {
        HttpResponse res = ReceiveObjectsInfoRESTAPI.callGetObjects('Salons', accId);
        String trimmedResponse = res.getBody().unescapeCsv().remove('\\');
            
        List<Salon__c> salonList = (List<Salon__c>) JSON.deserialize(
        trimmedResponse, List<Salon__c>.class);
        
        return salonList;
    }
    public static List<Vehicle_Test__c> vehicles(Id salonId) {
        HttpResponse res = ReceiveObjectsInfoRESTAPI.callGetObjects('Vehicles', salonId);
        String trimmedResponse = res.getBody().unescapeCsv().remove('\\');
            
        List<Vehicle_Test__c> vehicleList = (List<Vehicle_Test__c>) JSON.deserialize(
        trimmedResponse, List<Vehicle_Test__c>.class);
        return vehicleList;
    }
}
