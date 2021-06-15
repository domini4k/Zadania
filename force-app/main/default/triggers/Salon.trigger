trigger Salon on Salon__c(before update, before insert) {
  SalonController.transferToWarehouse(Trigger.new);
  SalonController.updateParkingSlots(Trigger.new);

}
