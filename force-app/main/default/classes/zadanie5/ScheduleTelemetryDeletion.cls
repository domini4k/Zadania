/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for scheduling batch job
 **/
global class ScheduleTelemetryDeletion implements Schedulable {
  global void execute(SchedulableContext context) {
    DeleteTelemetryBatch deleteTelBatch = new DeleteTelemetryBatch();
    database.executebatch(deleteTelBatch);
  }
}
