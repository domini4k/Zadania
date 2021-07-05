/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for listing information about objects in companies using REST API
 **/
public class ReceiveObjectsInfoRESTAPI {
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
   * @description This method is for returning acccess token
   **/
  public String returnAccessToken() {
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
    req.setEndpoint(Constant.ENDPOINT + 'oauth2/token');
    HttpResponse res = httpServer.send(req);
    DeserializeResponse response = (DeserializeResponse) JSON.deserialize(
      res.getbody(),
      DeserializeResponse.class
    );
    return response.access_token;
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for requesting info about specific objects
   **/
  public static HttpResponse callGetObjects(String inObject, String inParentID) {
    if (inObject == null){
      return null;
    }
    String accessToken = ReturnAccessToken();
  
    String endPoint = Constant.ENDPOINT +'apexrest/v1/RetrieveObjects/';
    Http httpServer = new Http();
    HttpRequest req = new HttpRequest();
    //Pass object name and their parent in body
    if (inParentID != null){
      req.setHeader('ParentID', inParentID);
    }
    req.setHeader('ObjectName', inObject);
    req.setHeader(Constant.AUTHORIZATION, 'Bearer ' + accessToken);
    req.setHeader(Constant.CONTENT_TYPE, Constant.APPLICATION);
    req.setHeader(Constant.ACCEPT, Constant.APPLICATION);
    req.setMethod(Constant.REST_GET);
    req.setEndpoint(endPoint);
    HttpResponse res = httpServer.send(req);
      
    return res;
  }
}