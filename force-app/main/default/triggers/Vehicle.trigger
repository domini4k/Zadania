trigger Vehicle on Vehicle__c(before delete, before insert, before update) {
  if (Trigger.isDelete) {
    VehicleController.VehicleDeletion(Trigger.old);
  }
  if (Trigger.isUpdate || Trigger.isInsert) {
    VehicleController.addVechicle(Trigger.new);
  }

}
