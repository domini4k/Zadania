@isTest
private with sharing class OfferControllerTest {
    @isTest static void testAddDuplicate() {
        //create sample data
        List<Account> accs = new List<Account>();
        for(Integer i=0;i<160;i++){
            Account acc = new Account(Name='acc'+i);
            accs.add(acc);
        }
        insert accs;

        List<Salon__c> salonsA = new List<Salon__c>();
        List<Salon__c> salonsB = new List<Salon__c>();
        for(Integer i=0;i<160;i++){
            Salon__c salonA = new Salon__c(Account__c=accs[i].Id, Name='salonA'+i, Parking_slots__c = 100);
            Salon__c salonB = new Salon__c(Account__c=accs[i].Id, Name='salonB'+i, Parking_slots__c = 100);
            salonsA.add(salonA);
            salonsB.add(salonB);
        }
        insert salonsA;
        insert salonsB;

        List<Vehicle__c> vehs = new List<Vehicle__c>();
        for(Integer i=0;i<160;i++){
            Vehicle__c veh = new Vehicle__c(Salon__c=salonsA[i].Id, Brand__c = 'Brand'+i, Car_model__c='Car Model'+i, Serial_number__c='4GHBV58MNBV852'+(i+100));
            vehs.add(veh);
        }
        insert vehs;
        
        List<Car_Posting__c> carOffers = new List<Car_Posting__c>();
        for(Integer i=0;i<160;i++){
            Car_Posting__c carOffer = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salonsA[i].Id, Virtual__c=FALSE);
            carOffers.add(carOffer);
        }
        insert carOffers;

        List<Car_Posting__c> carOffersTest = new List<Car_Posting__c>();
        for(Integer i=0;i<160;i++){
            Car_Posting__c carOfferTest = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salonsB[i].Id, Virtual__c=FALSE);
            carOffersTest.add(carOfferTest);
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert (carOffersTest, false);
        Test.stopTest();
        
        for(Integer i=0;i<160;i++){
            System.assert(!results[i].isSuccess());
            System.assert(results[i].getErrors().size() > 0);
            System.assertEquals('Car is already physically listed in',
                             results[i].getErrors()[0].getMessage());
    }
}
@isTest static void testAddNormal() {
        //create sample data
        List<Account> accs = new List<Account>();
        for(Integer i=0;i<160;i++){
            Account acc = new Account(Name='acc'+i);
            accs.add(acc);
        }
        insert accs;

        List<Salon__c> salonsA = new List<Salon__c>();
        List<Salon__c> salonsB = new List<Salon__c>();
        for(Integer i=0;i<160;i++){
            Salon__c salonA = new Salon__c(Account__c=accs[i].Id, Name='salonA'+i, Parking_slots__c = 100);
            Salon__c salonB = new Salon__c(Account__c=accs[i].Id, Name='salonB'+i, Parking_slots__c = 100);
            salonsA.add(salonA);
            salonsB.add(salonB);
        }
        insert salonsA;
        insert salonsB;

        List<Vehicle__c> vehs = new List<Vehicle__c>();
        for(Integer i=0;i<160;i++){
            Vehicle__c veh = new Vehicle__c(Salon__c=salonsA[i].Id, Brand__c = 'Brand'+i, Car_model__c='Car Model'+i, Serial_number__c='4GHBV58MNBV852'+(i+100));
            vehs.add(veh);
        }
        insert vehs;
        
        List<Car_Posting__c> carOffersTest = new List<Car_Posting__c>();
        for(Integer i=0;i<160;i++){
            Car_Posting__c carOfferTest = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salonsB[i].Id, Virtual__c=FALSE);
            carOffersTest.add(carOfferTest);
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert (carOffersTest, false);
        Test.stopTest();
        
        for(Integer i=0;i<results.size();i++){
            System.assert(results[i].isSuccess());
            System.assert(results[i].getErrors().size() == 0);
            
    }
}

    @isTest static void testAddVirtualSameVeh() {
        //create sample data. 
        List<Account> accs = new List<Account>();
        for(Integer i=0;i<160;i++){
            Account acc = new Account(Name='acc'+i);
            accs.add(acc);
        }
        insert accs;

        List<Salon__c> salonsA = new List<Salon__c>();
        List<Salon__c> salonsB = new List<Salon__c>();
        for(Integer i=0;i<160;i++){
            Salon__c salonA = new Salon__c(Account__c=accs[i].Id, Name='salonA'+i, Parking_slots__c = 100);
            Salon__c salonB = new Salon__c(Account__c=accs[i].Id, Name='salonB'+i, Parking_slots__c = 100);
            salonsA.add(salonA);
            salonsB.add(salonB);
        }
        insert salonsA;
        insert salonsB;

        List<Vehicle__c> vehs = new List<Vehicle__c>();
        for(Integer i=0;i<160;i++){
            Vehicle__c veh = new Vehicle__c(Salon__c=salonsA[i].Id, Brand__c = 'Brand'+i, Car_model__c='Car Model'+i, Serial_number__c='4GHBV58MNBV852'+(i+100));
            vehs.add(veh);
        }
        insert vehs;
        
        List<Car_Posting__c> carOffers = new List<Car_Posting__c>();
        for(Integer i=0;i<160;i++){
            Car_Posting__c carOffer = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salonsA[i].Id, Virtual__c=FALSE);
            carOffers.add(carOffer);
        }
        insert carOffers;

        List<Car_Posting__c> carOffersTest = new List<Car_Posting__c>();
        for(Integer i=0;i<160;i++){
            Car_Posting__c carOfferTest = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salonsB[i].Id, Virtual__c=TRUE);
            carOffersTest.add(carOfferTest);
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert (carOffersTest, false);
        Test.stopTest();
        
        for(Integer i=0;i<160;i++){
            System.assert(results[i].isSuccess());
            System.assert(results[i].getErrors().size() == 0);
    }
        
    }
    @isTest static void testAddDuplicateScript() {
        //create sample data
        List<Account> accs = new List<Account>();
        for(Integer i=0;i<160;i++){
            Account acc = new Account(Name='acc'+i);
            accs.add(acc);
        }
        insert accs;

        List<Salon__c> salonsA = new List<Salon__c>();
        List<Salon__c> salonsB = new List<Salon__c>();
        for(Integer i=0;i<160;i++){
            Salon__c salonA = new Salon__c(Account__c=accs[i].Id, Name='salonA'+i, Parking_slots__c = 100);
            Salon__c salonB = new Salon__c(Account__c=accs[i].Id, Name='salonB'+i, Parking_slots__c = 100);
            salonsA.add(salonA);
            salonsB.add(salonB);
        }
        insert salonsA;
        insert salonsB;

        List<Vehicle__c> vehs = new List<Vehicle__c>();
        for(Integer i=0;i<160;i++){
            Vehicle__c veh = new Vehicle__c(Salon__c=salonsA[i].Id, Brand__c = 'Brand'+i, Car_model__c='Car Model'+i, Serial_number__c='4GHBV58MNBV852'+(i+100));
            vehs.add(veh);
        }
        insert vehs;
        
        List<Car_Posting__c> carOffersTest = new List<Car_Posting__c>();
        for(Integer i=0;i<80;i++){
            Car_Posting__c carOffer = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salonsA[i].Id, Virtual__c=FALSE);
            Car_Posting__c carOfferTest = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salonsB[i].Id, Virtual__c=FALSE);
            carOffersTest.add(carOffer);
            carOffersTest.add(carOfferTest);
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert (carOffersTest, false);
        Test.stopTest();
        
        for(Integer i=0;i<results.size();i++){
            System.assert(!results[i].isSuccess());
            System.assert(results[i].getErrors().size() > 0);
            System.assertEquals('Car is already physically listed in',
                             results[i].getErrors()[0].getMessage());
    }
}
}
