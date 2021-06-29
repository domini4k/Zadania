
@isTest
private class UpdateCheckboxTest {
    
    static void testUpdateCheckbox() {
        // query for test data to pass to queueable class
        List<String> vehsIds = new List<String>();
        for (Integer i=0;i<160;i++){
            vehsIds.add('Id'+i);
        }
        // startTest/stopTest block to force async processes to run
        Test.setMock(HttpCalloutMock.class, new UpdateCheckboxRESTAPIMock());
        Test.startTest();
        UpdateCheckboxRESTAPI.vehicles(vehsIds);
        Test.stopTest();
        
        // Validate the job ran. Check if record have correct parentId now
        System.assertEquals(0, [select count() from Vehicle__c where Serial_number__c = '4GHBV58MNGV852369']);
    }
}