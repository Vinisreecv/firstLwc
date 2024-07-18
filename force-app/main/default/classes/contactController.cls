public with sharing class contactController {

        
        @AuraEnabled(cacheable=true)
        public static List<Contact> getRelatedContacts(Id accountId) {
        
        
            return [SELECT Id, Name, Email FROM Contact WHERE AccountId = :accountId];
        
        
        }
       
    
}