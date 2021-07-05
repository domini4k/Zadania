/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for sending Vehicles to another company using REST API
 **/
@RestResource(urlMapping='/v1/postVehiclesDel/*')
global with sharing class ImportVehicles {
    /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for sending Vehicles to another company using REST API
   **/
  @HttpPost
  global static void receiveVeh() {
    RestRequest vehicleRequest = RestContext.request;
    String requestBody = vehicleRequest.requestBody.toString();

    List<Vehicle_Test__c> vehiclesToInsert = new List<Vehicle_Test__c>();
    List<Object> vehiclesList = (List<Object>) JSON.deserializeUntyped(
      requestBody
    );

    for (Integer i = 0; i < vehiclesList.size(); i++) {
      Map<String, Object> vehicleMap = (Map<String, Object>) ((Map<String, Object>) vehiclesList[
        i
      ]);

      Vehicle_Test__C vehicleToInsert = new Vehicle_Test__C();

      vehicleToInsert.Brand__c = String.valueof(vehicleMap.get('Brand__c'));
      vehicleToInsert.Car_model__c = String.valueof(
        vehicleMap.get('Car_model__c')
      );
      vehicleToInsert.Serial_number__c = String.valueof(
        vehicleMap.get('Serial_number__c')
      );

      vehiclesToInsert.add(vehicleToInsert);
    }
    insert vehiclesToInsert;
  }
}
