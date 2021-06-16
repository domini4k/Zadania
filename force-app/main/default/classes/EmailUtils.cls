public with sharing class EmailUtils {
    @future(callout=true)
    public static void SendEmailAsync(List<Car_Posting__c> newCarOffers) {
        if (newCarOffers == null){
            return;
        }
        String toAddress = 'dominiak123@gmail.com';
        sendEmail(toAddress, newCarOffers)

    }
        
    private static void sendEmail(String toAddress, List<Car_Posting__c> newCarOffersId) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject('New Car Offers');
        mail.setPlainTextBody('Your Case: ' + case.Id +' has been created.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}
