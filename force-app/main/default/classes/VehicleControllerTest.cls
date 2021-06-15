@isTest
private with sharing class VehicleControllerTest {
    @isTest static void VehicleDelete() {
        //create sample data
        List<Vehicle__c> vehs = new List<Vehicle__c>();
        for(Integer i=0;i<160;i++){
            Vehicle__c veh = new Vehicle__c(Brand__c = 'Brand'+i, Car_model__c='Car Model'+i, Serial_number__c='4GHBV58MNBV852852');
            vehs.add(veh);
        }
        insert vehs;

        List<Telemetry__c> tels = new List<Telemetry__c>();
        for(Integer i=0;i<160;i++){
            Telemetry__c tel = new Telemetry__c(Vehicle__c=vehs[i].Id);
            tels.add(tel);
        }
        insert tels;

        Test.startTest();
        Database.DeleteResult[] results = Database.delete (vehs, false);
        Test.stopTest();

        List<Telemetry__c> telsDeleted = [SELECT Id FROM Telemetry__c WHERE Vehicle__r.Serial_number__c = '4GHBV58MNBV852852'];
        List<Case> cases = [SELECT Id FROM Case WHERE Subject = 'Car 4GHBV58MNBV852852 was succesfully disposed'];
        System.debug(cases.size());
        for(Database.DeleteResult dr : results){
            System.assert(dr.isSuccess());
            System.assert(dr.getErrors().size() == 0);
        }
            System.assert(telsDeleted.size() == 0);
            System.assert(cases.size() == 160);

    }
}
