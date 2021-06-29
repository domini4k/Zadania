
@isTest
private class UpdateCheckboxTest {
    @isTest
    static void testUpdateCheckbox() {
        List<String> vehsIds = new List<String>();
        for (Integer i=0;i<160;i++){
            vehsIds.add('Id'+i);
        }
        Test.setMock(HttpCalloutMock.class, new UpdateCheckboxMock());
        
        HttpResponse response = UpdateCheckboxRESTAPI.vehicles(vehsIds);
        
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        System.assertEquals(200, response.getStatusCode());
        
    }
}