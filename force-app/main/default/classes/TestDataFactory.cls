/**
 * @author Pawel Dominiak <pawel.dominiak@accenture.com>
 * @date 16/06/2021
 * @description This class is for preparing testing data
 **/
public with sharing class TestDataFactory {
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for preparing Accounts to test
   **/
  public static List<Account> Accounts(Integer inAmount) {
    List<Account> accs = new List<Account>();
    for (Integer i = 0; i < inAmount; i++) {
      Account acc = new Account(Name = 'acc' + i);
      accs.add(acc);
    }
    insert accs;
    return accs;
  }

  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for preparing Salons to test
   **/
  public static List<Salon__c> Salons(
    Integer inAmount,
    List<Account> inAccs,
    Integer inParkingSlots,
    Boolean inWarehouse,
    String inStatus,
    Boolean inInsrt
  ) {
    List<Salon__c> salons = new List<Salon__c>();
    for (Integer i = 0; i < inAmount; i++) {
      Salon__c salon = new Salon__c(
        Account__c = inAccs[i].Id,
        Name = 'salon' + i,
        Parking_slots__c = inParkingSlots,
        Warehouse__c = inWarehouse,
        Status__c = inStatus
      );
      salons.add(salon);
    }
    if (inInsrt == true) {
      insert salons;
    }
    return salons;
  }

  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for preparing Vehicles to test
   **/
  public static List<Vehicle__c> Vehicles(
    Integer inAmount,
    List<Salon__c> inSalons,
    String inSerialNumber
  ) {
    List<Vehicle__c> vehs = new List<Vehicle__c>();
    for (Integer i = 0; i < inAmount; i++) {
      Vehicle__c veh = new Vehicle__c(
        Salon__c = inSalons[i].Id,
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = inSerialNumber + (i + 100)
      );
      vehs.add(veh);
    }
    insert vehs;
    return vehs;
  }
  /**
   * @author Pawel Dominiak <pawel.dominiak@accenture.com>
   * @date 16/06/2021
   * @description This method is for preparing Car Offer to test
   **/
  public static List<Car_Posting__c> carOffers(
    Integer inAmount,
    List<Vehicle__c> inVehs,
    List<Salon__c> inSalons,
    Boolean inVirt,
    Boolean inInsrt
  ) {
    List<Car_Posting__c> carOffers = new List<Car_Posting__c>();
    for (Integer i = 0; i < inAmount; i++) {
      Car_Posting__c carOffer = new Car_Posting__c(
        Vehicle__c = inVehs[i].Id,
        Salon__c = inSalons[i].Id,
        Virtual__c = inVirt
      );
      carOffers.add(carOffer);
    }
    if (inInsrt == true) {
      insert carOffers;
    }
    return carOffers;
  }
}
