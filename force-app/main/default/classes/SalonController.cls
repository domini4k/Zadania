public with sharing class SalonController {
    public static void transferToWarehouse(List<Salon__c> salons) {
        
        //Check if any salon from list has 'Closed' as a status
        //If not exit function, If yes use another list to save on iteration
        List<Salon__c> salonsClosing = new List<Salon__c>();
        for (Salon__c salon : salons){
            if (salon.Status__c == 'Closed'){
                salonsClosing.add(salon);
            }
        }
        if(salonsClosing.size()==0){
            return;
        }

        //Retrieve all vehicles from database
        List<Vehicle__c> vehicles = [SELECT Salon__r.Id FROM Vehicle__c];

        //Check if any vehicle is listed in closing salon. If yes, delete lookup relationship and 
        //set boolean value to true.
        for (Salon__c salon: salonsClosing){
            for (Vehicle__c vehicle : vehicles){
                if (vehicle.Salon__r.Id == salon.Id){
                    vehicle.Salon__c = null;
                    vehicle.In_warehouse__c = TRUE;
                }
            }
        }
        update vehicles;

        //Retrieve all car offers from database
        List<Car_Posting__c> carOffers = [SELECT Salon__r.Id FROM Car_Posting__c];
        List<Car_Posting__c> carOffersToDelete = new List<Car_Posting__c>();

        //Check what offers are related to closing salon and delete them
        for (Salon__c salon: salonsClosing){
            for (Car_Posting__c carOffer : carOffers){
                if (carOffer.Salon__r.Id == salon.Id){
                    carOffersToDelete.add(carOffer);
                }
            }

        }
        delete carOffersToDelete;
    }
}
