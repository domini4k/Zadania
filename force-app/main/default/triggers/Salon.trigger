trigger Salon on Salon__c (before update, before insert) {
    
    SalonController.transferToWarehouse(trigger.new);
        
}