public with sharing class OfferController {
    public static void AvoidDuplicates (List<Car_Posting__c> newCarOffers) {

        // Retrieve only physically listed offers in all Salons
        List<Car_Posting__c> offersPhysical = new List<Car_Posting__c>();
        offersPhysical = [SELECT Vehicle__c, Salon__r.Name FROM Car_Posting__c WHERE Virtual__c = FALSE];
                  
        //Iterate through two lists
        for (Car_Posting__c newCarOffer : newCarOffers){
            for (Car_Posting__c offerPhysical : offersPhysical){
                //Check if any element from two lists is duplicate.
                if (newCarOffer.Vehicle__c == offerPhysical.Vehicle__c && newCarOffer.Virtual__c==FALSE){
                    newCarOffer.Vehicle__c.addError('Car is already physically listed in ' + offerPhysical.Salon__r.Name + '.');
                }
                
            }
        }
        
    }
}