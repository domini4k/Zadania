/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for managing emails
 **/
public with sharing class EmailUtils {
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for sending asynchronous emails
   **/
  public static void sendEmail(List<Car_Posting__c> inNewCarOffers) {
    List<String> newCarOffersID = new List<String>();
    for (Car_Posting__c caroffer : inNewCarOffers) {
      newCarOffersID.add(carOffer.Id);
    }
    SendEmailAsync(newCarOffersID);
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for sending asynchronous emails
   **/
  @future(callout=true)
  public static void sendEmailAsync(
    List<String> inNewCarOffersID
  ) {
    if (inNewCarOffersID == null) {
      return;
    }
    List<String> toAddresses = new List<String>();
    toAddresses.add(Constant.DIRECTOR_EMAIL);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    List<String> mssg = new List<String>();
    
    for (Integer i = 0; i < inNewCarOffersID.size(); i++) {
      mssg.add(inNewCarOffersID[i]);
    }
    String separator = ', ';
    String message = String.join(mssg, separator);

    mail.setToAddresses(toAddresses);
    mail.setSubject(Constant.EMAIL_SUBJECT);
    mail.setPlainTextBody(Constant.EMAIL_BODY + message);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
