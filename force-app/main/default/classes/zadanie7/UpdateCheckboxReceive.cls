/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for updating checkbox from request from another org
 **/
@RestResource(urlMapping='/v1/postVehiclesUpdate/*')
global with sharing class UpdateCheckboxReceive {
  /**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description Post method
 **/
  @HttpPost
  global static void receiveVeh() {
    RestRequest vehicleRequest = RestContext.request;
    String requestBody = vehicleRequest.requestBody.toString();
    //Transform data from body to list of valid IDs
    List<Id> vehiclesToUpdateIDs = new List<Id>();
    List<Object> vehiclesList = (List<Object>) JSON.deserializeUntyped(
      requestBody
    );
    for (Object vehicle : vehiclesList) {
      String newString = vehicle.toString();
      Id newId = Id.valueOf(newString);
      vehiclesToUpdateIDs.add(newId);
    }
    //Select vehicles from database which Id is in list above
    List<Vehicle__c> vehiclesToUpdate = [
      SELECT Id
      FROM Vehicle__c
      WHERE Id IN :vehiclesToUpdateIDs
    ];
    //Update checkbox
    for (Vehicle__c vehicle : vehiclesToUpdate) {
      vehicle.Transfer_to_another_company__c = true;
    }
    update vehiclesToUpdate;
  }
}
