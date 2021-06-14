@isTest
private with sharing class SalonControllerTest {
    @isTest static void setStatusToClosed() {
            
        //create sample data
        List<Account> accs = new List<Account>();
        for(Integer i=0;i<160;i++){
            Account acc = new Account(Name='acc'+i);
            accs.add(acc);
        }
        insert accs;

        List<Salon__c> warehouses = new List<Salon__c>();
        for(Integer i=0;i<160;i++){
            Salon__c warehouse = new Salon__c(Account__c=accs[i].Id, Name='Warehouse', Warehouse__c=TRUE);
        warehouses.add(warehouse);
        }
        insert warehouses;
        System.debug(warehouses);
        List<Salon__c> salons = new List<Salon__c>();
        for(Integer i=0;i<160;i++){
            Salon__c salon = new Salon__c(Account__c=accs[i].Id, Name='salon'+i);
            salons.add(salon);
        }
        insert salons;

        List<Vehicle__c> vehs = new List<Vehicle__c>();
        for(Integer i=0;i<160;i++){
            Vehicle__c veh = new Vehicle__c(Salon__c=salons[i].Id, Brand__c = 'Brand'+i, Car_model__c='Car Model'+i, Serial_number__c='4GHBV58MNBV852369');
            vehs.add(veh);
        }
        insert vehs;
        
        List<Car_Posting__c> carOffersA = new List<Car_Posting__c>();
        List<Car_Posting__c> carOffersB = new List<Car_Posting__c>();
        for(Integer i=0;i<160;i++){
            Car_Posting__c carOfferA = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salons[i].Id, Virtual__c=FALSE);
            Car_Posting__c carOfferB = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salons[i].Id, Virtual__c=TRUE);
            carOffersA.add(carOfferA);
            carOffersB.add(carOfferB);
        }
        insert carOffersA;
        insert carOffersB;

        for (Salon__c salon : salons){
            salon.Status__c = 'Closed';
        }

        //Start test
        Test.startTest();
        List<Database.SaveResult> results = Database.update (salons, false);
        Test.stopTest();

        //Retrieve results
        List<Vehicle__c> vehsAfterTest = [SELECT Salon__c, Salon__r.Account__c FROM Vehicle__c WHERE Serial_number__c='4GHBV58MNBV852369'];
        List<Salon__c> warehousesTest = [SELECT Id, Account__c FROM Salon__c WHERE Warehouse__c = TRUE];
        
        Map<Vehicle__c,Salon__c> warehousesMappedTest = new Map<Vehicle__c,Salon__c>();
        for (Vehicle__c veh : vehsAfterTest){
            for (Salon__c warehouse : warehousesTest){
                if (warehouse.Account__c == veh.Salon__r.Account__c){
                    warehousesMappedTest.put(veh, warehouse);
                }
            }
        }

        List<Car_Posting__c> carOffers = [SELECT Id FROM Car_Posting__c WHERE Vehicle__r.Serial_number__c='4GHBV58MNBV852369'];
        
        //Compare them to expected values
        for(Integer i=0;i<160;i++){
            System.debug(results[i].getErrors());
            System.assert(results[i].isSuccess());
            System.assert(results[i].getErrors().size() == 0);
            System.assert(vehsAfterTest[i].Salon__c == warehousesMappedTest.get(vehsAfterTest[i]).Id);
        }
        System.assert(carOffers.size() == 0);
        
    }
     @isTest static void updateSalonNotClosing() {
        //create sample data
        List<Account> accs = new List<Account>();
        for(Integer i=0;i<160;i++){
            Account acc = new Account(Name='acc'+i);
            accs.add(acc);
        }
        insert accs;

        List<Salon__c> warehouses = new List<Salon__c>();
        for(Integer i=0;i<160;i++){
            Salon__c warehouse = new Salon__c(Account__c=accs[i].Id, Name='Warehouse', Warehouse__c=TRUE);
        warehouses.add(warehouse);
        }
        insert warehouses;
        System.debug(warehouses);
        List<Salon__c> salons = new List<Salon__c>();
        for(Integer i=0;i<160;i++){
            Salon__c salon = new Salon__c(Account__c=accs[i].Id, Name='salon'+i);
            salons.add(salon);
        }
        insert salons;

        List<Vehicle__c> vehs = new List<Vehicle__c>();
        for(Integer i=0;i<160;i++){
            Vehicle__c veh = new Vehicle__c(Salon__c=salons[i].Id, Brand__c = 'Brand'+i, Car_model__c='Car Model'+i, Serial_number__c='4GHBV58MNBV852369');
            vehs.add(veh);
        }
        insert vehs;
        
        List<Car_Posting__c> carOffersA = new List<Car_Posting__c>();
        List<Car_Posting__c> carOffersB = new List<Car_Posting__c>();
        for(Integer i=0;i<160;i++){
            Car_Posting__c carOfferA = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salons[i].Id, Virtual__c=FALSE);
            Car_Posting__c carOfferB = new Car_Posting__c(Vehicle__c=vehs[i].Id, Salon__c=salons[i].Id, Virtual__c=TRUE);
            carOffersA.add(carOfferA);
            carOffersB.add(carOfferB);
        }
        insert carOffersA;
        insert carOffersB;

        for (Salon__c salon : salons){
            salon.Status__c = 'Open';
        }

        //Start test
        Test.startTest();
        List<Database.SaveResult> results = Database.update (salons, false);
        Test.stopTest();

        //Retrieve results
        List<Vehicle__c> vehsAfterTest = [SELECT Salon__c, Salon__r.Account__c FROM Vehicle__c WHERE Serial_number__c='4GHBV58MNBV852369'];
        List<Salon__c> warehousesTest = [SELECT Id, Account__c FROM Salon__c WHERE Warehouse__c = TRUE];
        
        Map<Vehicle__c,Salon__c> warehousesMappedTest = new Map<Vehicle__c,Salon__c>();
        for (Vehicle__c veh : vehsAfterTest){
            for (Salon__c warehouse : warehousesTest){
                if (warehouse.Account__c == veh.Salon__r.Account__c){
                    warehousesMappedTest.put(veh, warehouse);
                }
            }
        }

        List<Car_Posting__c> carOffers = [SELECT Id FROM Car_Posting__c WHERE Vehicle__r.Serial_number__c='4GHBV58MNBV852369'];
        
        //Compare them to expected values
        for(Integer i=0;i<160;i++){
            System.assert(results[i].isSuccess());
            System.assert(results[i].getErrors().size() == 0);
        }
        System.assert(carOffers.size() == 320);
        
    }
    @isTest static void testAddDuplicateWarehouse() {
        //create sample data
        List<Account> accs = new List<Account>();
        for(Integer i=0;i<160;i++){
            Account acc = new Account(Name='acc'+i);
            accs.add(acc);
        }
        insert accs;

        List<Salon__c> salons = new List<Salon__c>();
        List<Salon__c> salonsTest = new List<Salon__c>();
        for(Integer i=0;i<160;i++){
            Salon__c salon = new Salon__c(Account__c=accs[i].Id, Name='salon'+i, Warehouse__c=TRUE);
            Salon__c salonTest = new Salon__c(Account__c=accs[i].Id, Name='salonTest'+i, Warehouse__c=TRUE);
            salons.add(salon);
            salonsTest.add(salonTest);
        }
        insert salons;
        
        Test.startTest();
        Database.SaveResult[] results = Database.insert (salonsTest, false);
        Test.stopTest();
        
        for(Integer i=0;i<results.size();i++){
            System.assert(!results[i].isSuccess());
            System.assert(results[i].getErrors().size() > 0);
            System.assertEquals('There can be only one warehouse related to specific account',
                             results[i].getErrors()[0].getMessage());
        }
    }
}