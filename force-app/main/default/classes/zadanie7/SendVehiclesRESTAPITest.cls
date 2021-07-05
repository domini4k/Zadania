/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for test RESTAPI class
 **/
@isTest
private class SendVehiclesRESTAPITest {
    /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description Test Setup
   **/
    @testSetup
    static void setupPost() {
        List<Account> accs = TestDataFactory.Accounts(160);
        List<Salon__c> salons = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      Constant.SALON_STATUS_OPEN,
      true
    );
    List<Vehicle__c> vehs = new List<Vehicle__c>();
    for (Integer i = 0; i < 160; i++) {
      Vehicle__c veh = new Vehicle__c(
        Salon__c = salons[i].Id,
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = '4GHBV58MNGV852369',
        Transfer_to_another_company__c = TRUE
      );
      vehs.add(veh);
    }
    insert vehs;
    }
    /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description Test Setup
   **/
    static testmethod void testQueueable() {
        // query for test data to pass to queueable class
        List<Vehicle__c> vehs = [SELECT ID FROM Vehicle__c WHERE Serial_number__c = '4GHBV58MNGV852369'];
        // startTest/stopTest block to force async processes to run
        Test.setMock(HttpCalloutMock.class, new SendVehiclesRESTAPIMock());
        Test.startTest();
        List<Database.DeleteResult> results = Database.delete(vehs, false);
        Test.stopTest();
        for (Integer i = 0; i < 160; i++) {
      System.assert(results[i].isSuccess());
      System.assert(results[i].getErrors().size() == 0);
    }
        System.assertEquals(0, [select count() from Vehicle__c where Serial_number__c = '4GHBV58MNGV852369']);
    }
}