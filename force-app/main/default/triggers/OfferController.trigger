trigger OfferController on Car_Posting__c(after insert) {
  EmailUtils.sendEmail(Trigger.new);
}
