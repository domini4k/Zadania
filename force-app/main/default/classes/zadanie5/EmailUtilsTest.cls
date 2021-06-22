@IsTest
private class EmailUtilsTest {
  @IsTest
  private static void testSendEmail() {
    //sample data
    List<Account> accs = TestDataFactory.Accounts(160);
    List<Salon__c> salons = TestDataFactory.Salons(
      160,
      accs,
      100,
      false,
      'Open',
      true
    );
    List<Vehicle__c> vehs = TestDataFactory.Vehicles(
      160,
      salons,
      '4GHBV58MNBV852'
    );
    List<Car_Posting__c> carOffers = TestDataFactory.carOffers(
      160,
      vehs,
      salons,
      false,
      false
    );
    List<Id> cars = new List<Id>();
    for (Car_Posting__c carOffer : carOffers) {
      cars.add(carOffer.Id);
    }

    Test.startTest();
    insert carOffers;
    Integer invocations = Limits.getFutureCalls();
    Test.stopTest();

    system.assertEquals(1, invocations);
  }
}
