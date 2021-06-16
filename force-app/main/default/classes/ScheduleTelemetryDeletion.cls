global class ScheduleTelemetryDeletion implements Schedulable {
  global void execute(SchedulableContext ctx) {
    DeleteTelemetryBatch b = new DeleteTelemetryBatch();
    database.executebatch(b);
  }
}
