/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for listing information about objects in companies using REST API
 **/
public class ReceiveObjectsInfoRESTAPI {
  private final String clientId = '3MVG9SOw8KERNN092PrKygczI_Uh6NRAls6AVkV7rUyyXA9Waqjd23oVTIrd7rXaVQcl9oJtNO7zlPqNZ3LOz';
  private final String clientSecret = 'DC167EA1890CD029730B596450F872C986248916618B494BE7F5BBF5FB47F1CA';
  private final String username = 'dominiak123@wise-shark-ppge52.com';
  private final String password = 'Podkladka1';
  public class deserializeResponse {
    public String id;
    public String access_token;
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for returning acccess token
   **/
  public String ReturnAccessToken(ReceiveObjectsInfoRESTAPI jobAccessToken) {
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
      'https://wise-shark-ppge52-dev-ed.my.salesforce.com/services/oauth2/token'
    );
    HttpResponse res = h.send(req);
    deserializeResponse response = (deserializeResponse) JSON.deserialize(
      res.getbody(),
      deserializeResponse.class
    );
    system.debug('@@@@access_token@@' + response);
    return response.access_token;
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for requesting info about specific objects
   **/
  public static List<String> callGetObjects(String inObject, String inParentID) {
    if (inObject == null){
      return null;
    }
      List<String> result = new List<String>();
    ReceiveObjectsInfoRESTAPI insAccessToken = new ReceiveObjectsInfoRESTAPI();
    String accessToken = insAccessToken.ReturnAccessToken(insAccessToken);
      
    if (accessToken != null) {
      String endPoint = 'https://wise-shark-ppge52-dev-ed.my.salesforce.com/services/apexrest/v1/RetrieveObjects/';
      Http h2 = new Http();
      HttpRequest req2 = new HttpRequest();
      //Pass object name and their parent in body
      if (inParentID != null){
        req2.setHeader('ParentID', inParentID);
      }
      req2.setHeader('ObjectName', inObject);
      req2.setHeader('Authorization', 'Bearer ' + accessToken);
      req2.setHeader('Content-Type', 'application/json');
      req2.setHeader('accept', 'application/json');
      req2.setMethod('GET');
      req2.setEndpoint(endPoint);
      HttpResponse res2 = h2.send(req2);
      String trimmedResponse = res2.getBody().unescapeCsv().remove('\\');
      system.debug('@@@RESPONSE@@'+trimmedResponse);
        
      List<Object> objectList = (List<Object>) JSON.deserializeUntyped(
      trimmedResponse
    );
      
      for (Integer i = 0; i < objectList.size(); i++) {
      Map<String, Object> objectMap = (Map<String, Object>) ((Map<String, Object>) objectList[
        i
      ]);
      result.add(objectMap.get('Car_model__c').toString());
      System.debug(objectMap.get('Car_model__c'));
      }
    }
      return result;
  }
}