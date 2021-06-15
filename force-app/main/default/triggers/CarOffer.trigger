trigger CarOffer on Car_Posting__c(before insert) {
  OfferController.AvoidDuplicates(Trigger.new);

}
