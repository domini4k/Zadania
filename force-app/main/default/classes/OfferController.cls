public with sharing class OfferController {
  public static void AvoidDuplicates(List<Car_Posting__c> newCarOffers) {
    // Retrieve only physically listed offers in all Salons
    List<Car_Posting__c> offersPhysical = [
      SELECT Vehicle__c, Salon__r.Name
      FROM Car_Posting__c
      WHERE Virtual__c = FALSE
    ];

    List<Vehicle__c> vehicles = [SELECT Id FROM Vehicle__c];

    // Map how many previous physicall offers are related to one vehicle
    Map<Id, Integer> numberOfCarOffers = new Map<Id, Integer>();
    for (Vehicle__c vehicle : vehicles) {
      Integer count = 0;
      for (Car_Posting__c carOffer : offersPhysical) {
        if (carOffer.Vehicle__c == vehicle.Id) {
          count++;
        }
      }
      for (Car_Posting__c newCarOffer : newCarOffers) {
        if (
          newCarOffer.Vehicle__c == vehicle.Id &&
          newCarOffer.Virtual__c == false
        ) {
          count++;
        }
      }
      numberOfCarOffers.put(vehicle.Id, count);
    }

    for (Car_Posting__c newCarOffer : newCarOffers) {
      if (
        numberOfCarOffers.get(newCarOffer.Vehicle__c) > 1 &&
        newCarOffer.Virtual__c == false
      ) {
        newCarOffer.addError('Car is already physically listed in');
      }
    }
  }
}
