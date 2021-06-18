/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for batch deleting telemetry data
 **/
public with sharing class DeleteTelemetryBatch implements Database.Batchable<sObject> {
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      [SELECT ID FROM Telemetry__c WHERE Created__c < yesterday]
    );
  }
  public void execute(Database.BatchableContext bc, List<Telemetry__c> scope) {
    // process each batch of records
    delete scope;
  }

  public void finish(Database.BatchableContext bc) {
    AsyncApexJob job = [
      SELECT
        Id,
        Status,
        NumberOfErrors,
        JobItemsProcessed,
        TotalJobItems,
        CreatedBy.Email
      FROM AsyncApexJob
      WHERE Id = :bc.getJobId()
    ];
    System.debug(job);
  }
}
