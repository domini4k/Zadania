/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for testing scheduler
 **/
@isTest
public with sharing class ScheduleTelemetryDeletionTest {
  /**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This method is for scheduling batch job
 **/
  @isTest
  static void testScheduler() {
    List<AsyncApexJob> jobsBefore = [
      SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
      FROM AsyncApexJob
    ];
    System.assertEquals(0, jobsBefore.size());

    Test.startTest();
    // Schedule the test job
    String jobId = System.schedule(
      Constant.JOB_SCHEDULE_TITLE,
      Constant.CRON_EXPR,
      new ScheduleTelemetryDeletion()
    );
    Test.stopTest();
    // Check schedulable is in the job list
    List<AsyncApexJob> jobsScheduled = [
      SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
      FROM AsyncApexJob
      WHERE JobType = 'ScheduledApex'
    ];
    System.assertEquals(1, jobsScheduled.size());
    System.assertEquals(
      'ScheduleTelemetryDeletion',
      jobsScheduled[0].ApexClass.Name
    );

    // check apex batch is in the job list
    List<AsyncApexJob> jobsApexBatch = [
      SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
      FROM AsyncApexJob
      WHERE JobType = 'BatchApex'
    ];
    System.assertEquals(1, jobsApexBatch.size());
    System.assertEquals(
      'DeleteTelemetryBatch',
      jobsApexBatch[0].ApexClass.Name
    );
  }
}
