@isTest
global class SendVehiclesRESTAPIMock implements HttpCalloutMock
{
  global HttpResponse respond(HttpRequest req)
    {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id": "accesstoken"}');
        res.setStatusCode(200);
        return res;
    }

}