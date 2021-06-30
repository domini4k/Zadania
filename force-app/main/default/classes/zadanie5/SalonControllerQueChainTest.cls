@isTest
public with sharing class SalonControllerQueChainTest {
    @isTest 
    static void testPostCallout() {

    List<Case> casesTest = new List<Case>();
    for (Integer i=0;i<160;i++){
        Case newCase = new Case();
        newCase.Status = 'New';
        newCase.Origin = 'Web';
        casesTest.add(newCase);
    }
    insert casesTest;
    Test.setMock(HttpCalloutMock.class, new SalonControllerQueChainMock()); 

    SalonControllerQueChain job = new SalonControllerQueChain(casesTest);
    // startTest/stopTest block to force async processes to run
    Test.startTest();
    System.enqueueJob(job);
    Test.stopTest();
    
    List<Case> casesAfter = [SELECT Status from Case WHERE Id in :casesTest];

    for (Case newCase : casesAfter){
        System.assertEquals('Closed', newCase.Status);
    }
    
    
}
}
