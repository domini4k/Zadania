/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for asynchronous managing renovations
 **/
public with sharing class SalonControllerQue implements Queueable {
  public List<Salon__c> salons;
  
  public void execute(QueueableContext context) {
    //Create new cases related to updated salons
    List<Case> newCases = new List<Case>();
    
    for (Salon__c salon : salons) {
      Case newCase = new Case(
        Subject = Constant.SUBJECT_TEXT + salon.Name,
        Salon__c = salon.Id
      );
      newCases.add(newCase);
      
    }
    insert newCases;
    if(!Test.isRunningTest()) {
      SalonControllerQueChain job = new SalonControllerQueChain();
      job.inCases = newCases;
      ID jobIDChain = System.enqueueJob(job);

    }
  }
}
