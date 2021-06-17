trigger Salon on Salon__c(before update, before insert) {
  if (Trigger.isInsert) {
    SalonController.avoidDuplicateWarehouses(Trigger.new);
  } else if (Trigger.isUpdate) {
    SalonController.updateParkingSlots(Trigger.new);
    SalonController.transferToWarehouse(Trigger.new, Trigger.oldMap);
  }

}
