/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for managing car offers
 **/
public with sharing class OfferController {
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method prevents from adding multiple physicall offers
   **/
  public static void avoidDuplicates(List<Car_Posting__c> inNewCarOffers) {
    if (inNewCarOffers == null) {
      return;
    }
    Set<Id> newCarOffersVehicleID = new Set<Id>();
    List<Car_Posting__c> newPhysicallOffers = new List<Car_Posting__c>();
    for (Car_Posting__c newCarOffer : inNewCarOffers) {
      if (newCarOffer.Virtual__c == false)
        newCarOffersVehicleID.add(newCarOffer.Vehicle__c);
      newPhysicallOffers.add(newCarOffer);
    }
    // Retrieve only physically listed offers in Salons from Database
    List<Car_Posting__c> offersPhysical = [
      SELECT Vehicle__c, Salon__r.Name
      FROM Car_Posting__c
      WHERE Virtual__c = FALSE AND Vehicle__c IN :newCarOffersVehicleID
    ];

    // Map how many physicall offers are related to one vehicle
    Map<Id, Integer> numberOfCarOffers = new Map<Id, Integer>();
    // Put in the map offers from database
    for (Car_Posting__c carOffer : offersPhysical) {
      numberOfCarOffers.put(carOffer.Vehicle__c, 1);
    }
    // Put in the map offers from trigger
    for (Car_Posting__c newCarOffer : newPhysicallOffers) {
      if (numberOfCarOffers.containsKey(newCarOffer.Vehicle__c)) {
        Integer newValue = numberOfCarOffers.get(newCarOffer.Vehicle__c) + 1;
        numberOfCarOffers.put(newCarOffer.Vehicle__c, newValue);
      } else {
        numberOfCarOffers.put(newCarOffer.Vehicle__c, 1);
      }
    }
    // Add errors
    for (Car_Posting__c newCarOffer : inNewCarOffers) {
      if (
        numberOfCarOffers.get(newCarOffer.Vehicle__c) > 1 &&
        !newCarOffer.Virtual__c
      ) {
        newCarOffer.addError(Constant.OFFER_CONTROLLER_ERROR_MESSAGE);
      }
    }
  }
}
