public with sharing class contactMetadataController {

    
    //public static List < contact__mdt > fetchSampleRecs(Id accountId) {
        
        //return [ SELECT Id, MasterLabel, Name__c FROM contact__mdt];
        
    //}
    @AuraEnabled( cacheable=true ) 
    public static List<sObject> contactMetaData(String recordId) {
        conOppCase__mdt conMetadata = [SELECT Id, DeveloperName, FieldNames__c, MasterLabel, objectName__c
                                       FROM conOppCase__mdt 
                                       WHERE DeveloperName = 'ContacDataTable'];
        
         String objectName = conMetadata.objectName__c;
        String columnNames = conMetadata.FieldNames__c;
        
        String query = 'SELECT ' + columnNames + ' FROM ' + objectName + ' WHERE AccountId = :recordId';
        System.debug(query);
        List<sObject> sobjList = Database.query(query);
        System.debug(sobjList);
        
        return sobjList;
}
}