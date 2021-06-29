@isTest
public class SalonControllerQueTest {
    
    static testmethod void testQueueable() {
        
        List<Account> accs = TestDataFactory.Accounts(160);

        List<Salon__c> salons = TestDataFactory.Salons(
            160,
            accs,
            100,
            true,
            Constant.SALON_STATUS_OPEN,
            false
            );

        SalonControllerQue job = new SalonControllerQue();
        job.salons = salons;

        Test.startTest();
        System.enqueueJob(job);
        Test.stopTest();

        System.assertEquals(160, [select count() from case where Salon__c = :salons]);
    }
}