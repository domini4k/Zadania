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

    public static void addVechicle(List<Vehicle__c> vehicles){

        List<Salon__c> salons = [SELECT Name, Parking_slots__c FROM Salon__c];
        List<Vehicle__c> vehiclesAll = [SELECT Salon__c FROM Vehicle__c];

        // Map how many slots are taken in related salon
        Map<Id, Integer> parkingSlotsTaken = new Map<Id, Integer>();
        for (Salon__c salon : salons){
            Integer parkingSlots = 0;
            for (Vehicle__c vehicle : vehiclesAll){
                if (vehicle.Salon__c == salon.Id){
                    parkingSlots++;
                }
            }
            parkingSlotsTaken.put(salon.Id,parkingSlots);
        }

        // Map how many slots are about to be taken after insert
        Map<Id, Integer> parkingSlotsInsert = new Map<Id, Integer>();
        for (Salon__c salon : salons){
            Integer parkingSlots = 0;
            for (Vehicle__c vehicle : vehicles){
                if (vehicle.Salon__c == salon.Id){
                    parkingSlots++;
                }
            }
            parkingSlotsInsert.put(salon.Id,parkingSlots);
        }

        for (Salon__c salon : salons){
            if (salon.Parking_slots__c - parkingSlotsTaken.get(salon.Id) - parkingSlotsInsert.get(salon.Id) < 0){
                for (Vehicle__c vehicle : vehicles){
                    if (vehicle.Salon__c == salon.Id){
                        vehicle.addError('There are not enough parking spots for vehicles in this salon '+salon.Name);
                    }
                }
                
            }
        }

    }
}
