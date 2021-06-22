/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for testing scheduler
 **/
@isTest
public with sharing class ScheduleTelemetryDeletionTest {
  @isTest
  static void testScheduler() {
    String cronExpr = '0 0 0 15 3 ? 2022';

    List<AsyncApexJob> jobsBefore = [
      SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
      FROM AsyncApexJob
    ];
    System.assertEquals(0, jobsBefore.size(), 'not expecting any asyncjobs');

    Test.startTest();
    // Schedule the test job
    String jobId = System.schedule(
      'TelemetryDeletionTest',
      cronExpr,
      new ScheduleTelemetryDeletion()
    );
    Test.stopTest();

    // Check schedulable is in the job list
    List<AsyncApexJob> jobsScheduled = [
      SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
      FROM AsyncApexJob
      WHERE JobType = 'ScheduledApex'
    ];
    System.assertEquals(1, jobsScheduled.size(), 'expecting one scheduled job');
    System.assertEquals(
      'ScheduleTelemetryDeletion',
      jobsScheduled[0].ApexClass.Name,
      'expecting specific scheduled job'
    );

    // check apex batch is in the job list
    List<AsyncApexJob> jobsApexBatch = [
      SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
      FROM AsyncApexJob
      WHERE JobType = 'BatchApex'
    ];
    System.assertEquals(
      1,
      jobsApexBatch.size(),
      'expecting one apex batch job'
    );
    System.assertEquals(
      'DeleteTelemetryBatch',
      jobsApexBatch[0].ApexClass.Name,
      'expecting specific batch job'
    );
  }
}
