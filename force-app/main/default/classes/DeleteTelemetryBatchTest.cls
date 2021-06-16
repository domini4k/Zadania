@isTest
private class UpdateContactAddressesTest {
    @testSetup
    static void setup() {
        List<Vehicle__c> vehicles = new List<Vehicle__c>();
        List<Telemetry__c> telemetries = new List<Telemetry__c>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            vehicles.add(new Vehicle__c(Brand__c = 'Brand' + i,
                                        Car_model__c = 'Car Model' + i,
                                        Serial_number__c = '4GHNV58MNBV852369'));
        }
        insert vehicles;

        for (Integer i=0;i<10;i++) {
            telemetries.add(new Telemetry__c(vehicles[i], Created__c = LAST_WEEK));
        }
        insert telemetries;
    }
    @isTest static void test() {
        Test.startTest();
        DeleteTelemetryBatch dtb = new DeleteTelemetryBatch();
        Id batchId = Database.executeBatch(dtb);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(0, [SELECT count() FROM Telemetry__c WHERE Serial_number__c = '4GHNV58MNBV852369']);
    }
}