/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for sending Vehicles to another company using REST API
 **/
public class SendVehicleUsingRESTAPI implements Queueable, Database.AllowsCallouts {
  public List<Vehicle__c> vehicles;
  static String clientId = Constant.CLIENT_ID;
  static String clientSecret = Constant.CLIENT_SECRET;
  static String username = Constant.LOGIN;
  static String password = Constant.PASSWORD;
  public class DeserializeResponse {
    public String id;
    public String access_token;
  }
   /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for returning access token
   **/
  public static String returnAccessToken() {
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
    Http httpServer = new Http();
    HttpRequest req = new HttpRequest();
    req.setBody(reqbody);
    req.setMethod(Constant.REST_POST);
    req.setEndpoint(
      Constant.ENDPOINT_MOOSE + 'oauth2/token'
    );
    HttpResponse res = httpServer.send(req);
    DeserializeResponse response = (DeserializeResponse) JSON.deserialize(
      res.getbody(),
      DeserializeResponse.class
    );
    return response.access_token;
  }
  public void execute(QueueableContext context) {
    String accessToken = returnAccessToken();

    String endPoint = Constant.ENDPOINT_MOOSE + 'apexrest/v1/postVehiclesDel/';
    Http httpServer = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader(Constant.AUTHORIZATION, 'Bearer ' + accessToken);
    req.setHeader(Constant.CONTENT_TYPE, Constant.APPLICATION);
    req.setHeader(Constant.ACCEPT, Constant.APPLICATION);
    req.setBody(JSON.serialize(vehicles));
    req.setMethod(Constant.REST_POST);
    req.setEndpoint(endPoint);
    HttpResponse res = httpServer.send(req);
  }
}
