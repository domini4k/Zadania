public with sharing class VehicleController {
    public static void VehicleDeletion(List<Vehicle__c> vehicles) {

        //Retrieve all telemetry data
        List<Telemetry__c> data = [SELECT Vehicle__c FROM Telemetry__c];

        List<Telemetry__c> dataToDelete = new List<Telemetry__c>();
        List<Case> newCases = new List<Case>();

        for (Vehicle__c vehicle : vehicles){
            //Create case for each vehicle
            Case newCase = new Case(Status = 'New', Origin = 'Web', Subject = 'Car '+ vehicle.Serial_number__c+ 
            ' was succesfully disposed', 
            Description = 'Parameters: ' +'\n'+
            'Brand: '+vehicle.Brand__c+'\n'+
            'Model: '+vehicle.Car_model__c+'\n'+
            'Serial number: '+vehicle.Serial_number__c);

            newCases.add(newCase);
        
            //Pick all telemetry data for each vehicle
            for (Telemetry__c telemetry : data){
                if (telemetry.Vehicle__c == vehicle.Id){
                    dataToDelete.add(telemetry);
                }
            }
        }
        insert newCases;
        delete dataToDelete;



    }
}
