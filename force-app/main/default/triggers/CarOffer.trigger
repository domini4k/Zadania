trigger CarOffer on Car_Posting__c(before insert, after insert) {
  if (Trigger.isAfter) {
    EmailUtils.sendEmail(Trigger.new);
  }
  if (Trigger.isBefore) {
    OfferController.avoidDuplicates(Trigger.new);
  }

}
