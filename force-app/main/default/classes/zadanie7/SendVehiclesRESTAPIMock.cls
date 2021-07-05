/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for mock the response
 **/
@isTest
global class SendVehiclesRESTAPIMock implements HttpCalloutMock
{
  global HttpResponse respond(HttpRequest req)
    {
        HttpResponse res = new HttpResponse();
        res.setHeader(Constant.CONTENT_TYPE, Constant.APPLICATION);
        res.setBody('{"id": "accesstoken"}');
        res.setStatusCode(200);
        return res;
    }

}