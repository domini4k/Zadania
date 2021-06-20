/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for testing OfferController class
 **/
@isTest
private with sharing class OfferControllerTest {
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing OfferController class
   **/
  @isTest
  static void testAddDuplicate() {
    String mssg = 'Car is already physically listed';
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> salonsA = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Salon__c> salonsB = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Vehicle__c> vehs = TestDataFactory.Vehicles(
      160,
      salonsA,
      '4GHBV58MNBV852'
    );
    List<Car_Posting__c> carOffers = TestDataFactory.carOffers(
      160,
      vehs,
      salonsA,
      false,
      true
    );
    List<Car_Posting__c> carOffersTest = TestDataFactory.carOffers(
      160,
      vehs,
      salonsB,
      false,
      false
    );

    Test.startTest();
    Database.SaveResult[] results = Database.insert(carOffersTest, false);
    Test.stopTest();

    for (Integer i = 0; i < results.size(); i++) {
      System.assert(!results[i].isSuccess());
      System.assert(results[i].getErrors().size() > 0);
      System.assertEquals(mssg, results[i].getErrors()[0].getMessage());
    }
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing OfferController class
   **/
  @isTest
  static void testAddNormal() {
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> salonsA = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Salon__c> salonsB = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Vehicle__c> vehs = TestDataFactory.Vehicles(
      160,
      salonsA,
      '4GHBV58MNBV852'
    );
    List<Car_Posting__c> carOffersTest = TestDataFactory.carOffers(
      160,
      vehs,
      salonsB,
      false,
      false
    );

    Test.startTest();
    Database.SaveResult[] results = Database.insert(carOffersTest, false);
    Test.stopTest();

    for (Integer i = 0; i < results.size(); i++) {
      System.assert(results[i].isSuccess());
      System.assert(results[i].getErrors().size() == 0);
    }
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing OfferController class
   **/
  @isTest
  static void testAddVirtualSameVeh() {
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> salonsA = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Salon__c> salonsB = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Vehicle__c> vehs = TestDataFactory.Vehicles(
      160,
      salonsA,
      '4GHBV58MNBV852'
    );
    List<Car_Posting__c> carOffers = TestDataFactory.carOffers(
      160,
      vehs,
      salonsA,
      false,
      true
    );
    List<Car_Posting__c> carOffersTest = TestDataFactory.carOffers(
      160,
      vehs,
      salonsB,
      true,
      false
    );

    Test.startTest();
    Database.SaveResult[] results = Database.insert(carOffersTest, false);
    Test.stopTest();

    for (Integer i = 0; i < results.size(); i++) {
      System.assert(results[i].isSuccess());
      System.assert(results[i].getErrors().size() == 0);
    }
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for testing OfferController class
   **/
  @isTest
  static void testAddDuplicateScript() {
    String mssg = Constant.offerControllerErrorMessage;
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> salonsA = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Salon__c> salonsB = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Vehicle__c> vehs = TestDataFactory.Vehicles(
      160,
      salonsA,
      '4GHBV58MNBV852'
    );
    List<Car_Posting__c> carOffers = TestDataFactory.carOffers(
      80,
      vehs,
      salonsA,
      false,
      false
    );
    List<Car_Posting__c> carOffersTest = TestDataFactory.carOffers(
      80,
      vehs,
      salonsB,
      false,
      false
    );
    carOffersTest.addAll(carOffers);

    Test.startTest();
    Database.SaveResult[] results = Database.insert(carOffersTest, false);
    Test.stopTest();

    for (Integer i = 0; i < results.size(); i++) {
      System.assert(!results[i].isSuccess());
      System.assert(results[i].getErrors().size() > 0);
      System.assertEquals(mssg, results[i].getErrors()[0].getMessage());
    }
  }
}
