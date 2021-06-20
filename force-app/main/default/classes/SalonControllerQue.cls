/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class asynchronous managing renovations
 **/
public with sharing class SalonControllerQue implements Queueable {
    private List<Salon__c> salons;
    public CreateRenovationCase(List<Salon__c> inSalons, Map<Id, Salon__c> inSalonsOldMap) {
         //Check how many salons changed their status to closed and use them
        List<Salon__c> salonsClosing = new List<Salon__c>();
        for (Salon__c salon : inSalons) {
        if (
            inSalonsOldMap.get(salon.Id).Status__c != salon.Status__c &&
            salon.Status__c == 'Closed'
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
        for (Salon__c salon : salons){
            
            Case newCase = new Case(Subject ='Renovation Case '+ salon.Name, Salon__c = salon.Id );
            newCases.add(newCase);
            Map<String, String> infoMap = new Map<String, String>();
            infoMap.put('Subject', newCase.Subject);
            infoMap.put('Salon', newCase.Salon__c);
            infoMap.put('CaseId', newCase.Id);

            Http server = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://jsonplaceholder.typicode.com/posts');
            req.setMethod('POST');
            req.setBody(JSON.serialize(infoMap)); 
            HttpResponse resp = server.send(req);
            If(resp.getStatusCode() =201)
            {
                newCase.Status = 'Closed';

            }else
            {
                newCase.Status = 'Failed';
                System.debug(LoggingLevel.ERROR,’Bład połączenia’);
            }


            }
            insert newCases;

    }
}
