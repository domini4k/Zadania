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
  public static List<Account> Accounts(Integer j) {
    List<Account> accs = new List<Account>();
    for (Integer i = 0; i < j; i++) {
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
    Integer j,
    List<Account> accs,
    Integer parkingSlots,
    Boolean warehouse,
    String status,
    Boolean insrt
  ) {
    List<Salon__c> salons = new List<Salon__c>();
    for (Integer i = 0; i < j; i++) {
      Salon__c salon = new Salon__c(
        Account__c = accs[i].Id,
        Name = 'salon' + i,
        Parking_slots__c = parkingSlots,
        Warehouse__c = warehouse,
        Status__c = status
      );
      salons.add(salon);
    }
    if (insrt == true) {
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
    Integer j,
    List<Salon__c> salons,
    String serialNumber
  ) {
    List<Vehicle__c> vehs = new List<Vehicle__c>();
    for (Integer i = 0; i < j; i++) {
      Vehicle__c veh = new Vehicle__c(
        Salon__c = salons[i].Id,
        Brand__c = 'Brand' + i,
        Car_model__c = 'Car Model' + i,
        Serial_number__c = serialNumber + (i + 100)
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
    Integer j,
    List<Vehicle__c> vehs,
    List<Salon__c> salons,
    Boolean virt,
    Boolean insrt
  ) {
    List<Car_Posting__c> carOffers = new List<Car_Posting__c>();
    for (Integer i = 0; i < j; i++) {
      Car_Posting__c carOffer = new Car_Posting__c(
        Vehicle__c = vehs[i].Id,
        Salon__c = salons[i].Id,
        Virtual__c = virt
      );
      carOffers.add(carOffer);
    }
    if (insrt == true) {
      insert carOffers;
    }
    return carOffers;
  }
}
