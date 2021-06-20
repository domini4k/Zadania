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
  public static void SendEmailAsync(
    List<String> inNewCarOffersID,
    List<String> inNewCarOffersSalon
  ) {
    if (inNewCarOffersID == null || inNewCarOffersSalon == null) {
      return;
    }
    List<String> toAddresses = new List<String>();
    toAddresses.add('example.mail@examplemail.com');
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String mssg = '';

    List<Salon__c> salonNames = [
      SELECT Name
      FROM Salon__c
      WHERE Id IN :inNewCarOffersSalon
    ];
    for (Integer i = 0; i < inNewCarOffersID.size(); i++) {
      mssg = mssg + inNewCarOffersID[i] + ' (' + salonNames[i].Name + '); ';
    }

    mail.setToAddresses(toAddresses);
    mail.setSubject('New Car Offers');
    mail.setPlainTextBody('New car offers have been created: ' + mssg);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
