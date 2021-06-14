@isTest
private with sharing class SalonControllerTest {
    @isTest static void setStatusToClosed() {
        //create sample data. Later the code will try to add another offer of vehicle veh to salon2
        Account acc = new Account(Name='acc');
        insert acc;
        Salon__c salon = new Salon__c(Account__c=acc.Id, Name='salon');
        insert salon;
        Vehicle__c veh = new Vehicle__c(Salon__c=salon.Id, Brand__c = 'Brand', Car_model__c='Car Model', Serial_number__c='4GHBV58MNBV852369');
        insert veh;
        Car_Posting__c carOffer1 = new Car_Posting__c(Vehicle__c=veh.Id, Salon__c=salon.Id, Virtual__c=FALSE);
        Car_Posting__c carOffer2 = new Car_Posting__c(Vehicle__c=veh.Id, Salon__c=salon.Id, Virtual__c=TRUE);
        insert carOffer1;
        insert carOffer2;

        //Strat test
        Test.startTest();
        salon.Status__c = 'Closed';
        Database.SaveResult result = Database.update (salon, false);
        Test.stopTest();

        //Retrieve results
        List<Car_Posting__c> carOffers = [SELECT Id FROM Car_Posting__c WHERE Vehicle__c=:veh.Id];
        Vehicle__c vehAfterTest = [SELECT Salon__c, In_warehouse__c FROM Vehicle__c WHERE Serial_number__c='4GHBV58MNBV852369'];
        
        //Compare them to expected values
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        System.assert(vehAfterTest.Salon__c == null);
        System.assert(vehAfterTest.In_warehouse__c == true);
        System.assert(carOffers.size() == 0);
        
    }
    @isTest static void updateSalonNotClosing() {
        //create sample data. Later the code will try to add another offer of vehicle veh to salon2
        Account acc = new Account(Name='acc');
        insert acc;
        Salon__c salon = new Salon__c(Account__c=acc.Id, Name='salon');
        insert salon;
        Vehicle__c veh = new Vehicle__c(Salon__c=salon.Id, Brand__c = 'Brand', Car_model__c='Car Model', Serial_number__c='4GHBV58MNBV852369');
        insert veh;
        Car_Posting__c carOffer1 = new Car_Posting__c(Vehicle__c=veh.Id, Salon__c=salon.Id, Virtual__c=FALSE);
        Car_Posting__c carOffer2 = new Car_Posting__c(Vehicle__c=veh.Id, Salon__c=salon.Id, Virtual__c=TRUE);
        insert carOffer1;
        insert carOffer2;

        //Strat test
        Test.startTest();
        salon.Status__c = 'Open';
        Database.SaveResult result = Database.update (salon, false);
        Test.stopTest();

        //Retrieve results
        List<Car_Posting__c> carOffers = [SELECT Id FROM Car_Posting__c WHERE Vehicle__c=:veh.Id];
        Vehicle__c vehAfterTest = [SELECT Salon__c, In_warehouse__c FROM Vehicle__c WHERE Serial_number__c='4GHBV58MNBV852369'];
        
        //Compare them to expected values
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        System.assert(vehAfterTest.Salon__c == salon.Id);
        System.assert(vehAfterTest.In_warehouse__c == false);
        System.assert(carOffers.size() == 2);
        
    }
}