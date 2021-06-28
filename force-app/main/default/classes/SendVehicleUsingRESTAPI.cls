/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for sending Vehicles to another company using REST API
 **/
public class SendVehicleUsingRESTAPI implements Queueable, Database.AllowsCallouts {
  public List<Vehicle__c> vehicles;
  //czy to mozna hardcodowac?
  private final String clientId = '3MVG9SOw8KERNN08uhAwkhN5G97pi5WwZQ_FT4yjfRfEuwGz_EvqcOJuz0wr52jI.mJXaqoyVcsGKUAJ5oZvy';
  private final String clientSecret = 'D8AC614EB5C9C3C35864780C7C7D6098D5DD3CB5A3F6C292FF015BCE66F32F0C';
  private final String username = 'dominiak123@wise-moose-72zl27.com';
  private final String password = 'Podkladka1';
  public class deserializeResponse {
    public String id;
    public String access_token;
  }
  public String ReturnAccessToken(SendVehicleUsingRESTAPI jobAccessToken) {
    String reqbody =
      'grant_type=password' +
      '&client_id=' +
      clientId +
      '&client_secret=' +
      clientSecret +
      '&username=' +
      username +
      '&password=' +
      password;
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setBody(reqbody);
    req.setMethod('POST');
    req.setEndpoint(
      'https://wise-moose-72zl27-dev-ed.my.salesforce.com/services/oauth2/token'
    );
    HttpResponse res = h.send(req);
    deserializeResponse response = (deserializeResponse) JSON.deserialize(
      res.getbody(),
      deserializeResponse.class
    );
    return response.access_token;
  }
  public void execute(QueueableContext context) {
    SendVehicleUsingRESTAPI jobAccessToken = new SendVehicleUsingRESTAPI();
    String accessToken = jobAccessToken.ReturnAccessToken(jobAccessToken);

    String endPoint = 'https://wise-moose-72zl27-dev-ed.my.salesforce.com/services/apexrest/v1/postVehiclesDel/';
    Http h2 = new Http();
    HttpRequest req2 = new HttpRequest();
    req2.setHeader('Authorization', 'Bearer ' + accessToken);
    req2.setHeader('Content-Type', 'application/json');
    req2.setHeader('accept', 'application/json');
    req2.setBody(JSON.serialize(vehicles));
    req2.setMethod('POST');
    req2.setEndpoint(endPoint);
    HttpResponse res2 = h2.send(req2);
  }
}
