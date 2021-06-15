trigger Vehicle on Vehicle__c (before delete) {

    VehicleController.VehicleDeletion(trigger.old);

}