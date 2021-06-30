/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for asynchronous managing renovations
 **/
public with sharing class SalonControllerQueChain implements Queueable, Database.AllowsCallouts{
    private List<Case> cases;
    public SalonControllerQueChain(List<Case> inCases){
        this.cases = inCases;
    }
    
    public void execute(QueueableContext context) {
        if (cases == null){
            return;
        }
        List<Id> newCasesID = new List<Id>();
        for (Case newCase : cases){
            newCasesID.add(newCase.Id);
            }

        Http server = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Constant.QUEUEABLE_ENDPOINT);
        req.setMethod(Constant.QUEUEABLE_METHOD);
        req.setBody(JSON.serialize(newCasesID));
        HttpResponse resp = server.send(req);

        if (resp.getStatusCode() == 201) {
        for (Case newCase : cases) {
            newCase.Status = Constant.SALON_STATUS_CLOSED;
        }
        } else {
        for (Case newCase : cases) {
            newCase.Status = Constant.SALON_STATUS_FAILED;
        }
        System.debug(LoggingLevel.ERROR, Constant.QUEUEABLE_ERROR_MESSAGE);
        }

        update cases;
        }
}
