trigger Salon on Salon__c (before update) {
    
    SalonController.transferToWarehouse(trigger.new);
        
}