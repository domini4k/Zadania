@isTest
private with sharing class OfferControllerTest {
    @isTest static void testAddDuplicate() {
        //create sample data. Later the code will try to add another offer of vehicle veh to salon2
        Account acc = new Account(Name='acc');
        insert acc;
        Salon__c salon1 = new Salon__c(Account__c=acc.Id, Name='salon1');
        Salon__c salon2 = new Salon__c(Account__c=acc.Id, Name='salon2');
        insert salon1;
        insert salon2;
        Vehicle__c veh = new Vehicle__c(Salon__c=salon1.Id, Brand__c = 'Brand', Car_model__c='Car Model', Serial_number__c='4GHBV58MNBV852369');
        insert veh;
        Car_Posting__c carOffer = new Car_Posting__c(Vehicle__c=veh.Id, Salon__c=salon1.Id, Virtual__c=FALSE);
        insert carOffer;

        Test.startTest();
        Car_Posting__c carOfferTest = new Car_Posting__c(Vehicle__c=veh.Id, Salon__c=salon2.Id, Virtual__c=FALSE);
        Database.SaveResult result = Database.insert (carOfferTest, false);
        Test.stopTest();
        
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Car is already physically listed in salon1.',
                             result.getErrors()[0].getMessage());
    }

    @isTest static void testAddVirtualSameVeh() {
        //create sample data. Later the code will try to add another offer of vehicle veh to salon2, but now as a
        // virtual offer
        Account acc = new Account(Name='acc');
        insert acc;
        Salon__c salon1 = new Salon__c(Account__c=acc.Id, Name='salon1');
        Salon__c salon2 = new Salon__c(Account__c=acc.Id, Name='salon2');
        insert salon1;
        insert salon2;
        Vehicle__c veh = new Vehicle__c(Salon__c=salon1.Id, Brand__c = 'Brand', Car_model__c='Car Model', Serial_number__c='4GHBV58MNBV852369');
        insert veh;
        Car_Posting__c carOffer = new Car_Posting__c(Vehicle__c=veh.Id, Salon__c=salon1.Id, Virtual__c=FALSE);
        insert carOffer;

        Test.startTest();
        Car_Posting__c carOfferTest = new Car_Posting__c(Vehicle__c=veh.Id, Salon__c=salon2.Id, Virtual__c=TRUE);
        Database.SaveResult result = Database.insert (carOfferTest, false);
        Test.stopTest();
        
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
    }
}
