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
  public static void SendEmail(List<Car_Posting__c> inNewCarOffers) {
    List<String> newCarOffersID = new List<String>();
    List<String> newCarOffersSalon = new List<String>();
    for (Car_Posting__c caroffer : inNewCarOffers) {
      newCarOffersID.add(carOffer.Id);
      newCarOffersSalon.add(caroffer.Salon__c);
    }
    SendEmailAsync(newCarOffersID, newCarOffersSalon);
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for sending asynchronous emails
   **/
  @future(callout=true)
  public static void sendEmailAsync(
    List<String> inNewCarOffersID,
    List<String> inNewCarOffersSalon
  ) {
    if (inNewCarOffersID == null || inNewCarOffersSalon == null) {
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
    String.join(mssg, separator);

    mail.setToAddresses(toAddresses);
    mail.setSubject(Constant.EMAIL_SUBJECT);
    mail.setPlainTextBody(Constant.EMAIL_BODY + mssg);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
