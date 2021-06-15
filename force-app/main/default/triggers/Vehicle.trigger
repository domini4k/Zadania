trigger Vehicle on Vehicle__c (before delete, before insert, before update) {

    if (trigger.isDelete){
        VehicleController.VehicleDeletion(trigger.old);
    }
    if (trigger.isUpdate || trigger.isInsert){
        VehicleController.addVechicle(trigger.new);
    }

}