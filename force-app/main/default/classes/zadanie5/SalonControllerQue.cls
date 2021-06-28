/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for asynchronous managing renovations
 **/
public with sharing class SalonControllerQue implements Queueable {
  private List<Salon__c> salons;
  public void createRenovationCase(
    List<Salon__c> inSalons,
    Map<Id, Salon__c> inSalonsOldMap
  ) {
    //Check how many salons changed their status to closed and use them
    List<Salon__c> salonsClosing = new List<Salon__c>();
    for (Salon__c salon : inSalons) {
      if (
        inSalonsOldMap.get(salon.Id).Status__c != salon.Status__c &&
        salon.Status__c == Constant.SALON_STATUS_CLOSED
      ) {
        salonsClosing.add(salon);
      }
    }
    if (salonsClosing.size() == 0) {
      return;
    }
    this.salons = salonsClosing;
  }
  public void execute(QueueableContext context) {
    //Create new cases related to updated salons
    List<Case> newCases = new List<Case>();
    List<Id> newCasesID = new List<Id>();
    for (Salon__c salon : salons) {
      Case newCase = new Case(
        Subject = Constant.SUBJECT_TEXT + salon.Name,
        Salon__c = salon.Id
      );
      newCases.add(newCase);
      newCasesID.add(newCase.Id);
    }

    Http server = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(Constant.QUEUEABLE_ENDPOINT);
    req.setMethod(Constant.QUEUEABLE_METHOD);
    req.setBody(JSON.serialize(newCasesID));
    HttpResponse resp = server.send(req);

    if (resp.getStatusCode() == 201) {
      for (Case newCase : newCases) {
        newCase.Status = Constant.SALON_STATUS_CLOSED;
      }
    } else {
      for (Case newCase : newCases) {
        newCase.Status = Constant.SALON_STATUS_FAILED;
      }
      System.debug(LoggingLevel.ERROR, Constant.QUEUEABLE_ERROR_MESSAGE);
    }

    insert newCases;
  }
}
