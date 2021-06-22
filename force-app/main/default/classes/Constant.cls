public with sharing class Constant {
  public static final String OFFER_CONTROLLER_ERROR_MESSAGE = 'Car is already physically listed';
  public static final String SALON_CONTROLLER_ERROR_MESSAGE_WAREHOUSE = 'There can be only one warehouse related to specific account';
  public static final String SALON_CONTROLLER_ERROR_MESSAGE_PARKING = 'There are more vehicles than desired parking spots';
  public static final String VEHICLE_CONTROLLER_ERROR_MESSAGE = 'There are not enough parking spots for vehicles in this salon ';
  public static final String SALON_STATUS_CLOSED = 'Closed';
  public static final String SALON_STATUS_FAILED = 'Failed';
  public static final String SUBJECT_TEXT = 'Renovation Case ';
  public static final String QUEUEABLE_ENDPOINT = 'https://jsonplaceholder.typicode.com/posts';
  public static final String QUEUEABLE_METHOD = 'POST';
  public static final String QUEUEABLE_ERROR_MESSAGE = 'Błąd połączenia';
  public static final String DIRECTOR_EMAIL = 'example.mail@examplemail.com';
  public static final String EMAIL_SUBJECT = 'New Car Offers';
  public static final String EMAIL_BODY = 'New car offers have been created: ';
  public static final String CRON_EXPR = '0 0 0 15 3 ? 2022';
  public static final String JOB_SCHEDULE_TITLE = 'TelemetryDeletionTest';
}
