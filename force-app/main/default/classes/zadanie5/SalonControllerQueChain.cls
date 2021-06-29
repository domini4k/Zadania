/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for asynchronous managing renovations
 **/
public with sharing class SalonControllerQueChain implements Queueable, Database.AllowsCallouts{
    public List<Case> inCases;
    
    public void execute(QueueableContext context) {
        List<Id> newCasesID = new List<Id>();
        for (Case c : inCases){
            newCasesID.add(c.Id);
            }

        Http server = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Constant.QUEUEABLE_ENDPOINT);
        req.setMethod(Constant.QUEUEABLE_METHOD);
        req.setBody(JSON.serialize(newCasesID));
        HttpResponse resp = server.send(req);

        if (resp.getStatusCode() == 201) {
        for (Case newCase : inCases) {
            newCase.Status = Constant.SALON_STATUS_CLOSED;
        }
        } else {
        for (Case newCase : inCases) {
            newCase.Status = Constant.SALON_STATUS_FAILED;
        }
        System.debug(LoggingLevel.ERROR, Constant.QUEUEABLE_ERROR_MESSAGE);
        }

        update inCases;
        }
}
