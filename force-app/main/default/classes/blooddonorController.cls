public with sharing class blooddonorController {
   
//
@AuraEnabled(cacheable=true)
public static List<BloodDonor__c> getbloodDonorDataList() {
    return [SELECT Id, Name,PhoneNumber__c,Blood_group__c
        
            FROM BloodDonor__c 
            ];
}
}