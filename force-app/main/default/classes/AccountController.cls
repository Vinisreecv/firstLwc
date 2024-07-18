public with sharing class AccountController{

//
@AuraEnabled(cacheable=true)
    public static List<Account> getAccountDataList() {
        return [SELECT Id, Name, Type, Rating,
                Phone, Website, Email__c
                FROM Account 
                ORDER BY CreatedDate DESC];
    }


    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
       

        List<Account> accList= [ SELECT id, Name, Industry, Rating,Phone FROM Account LIMIT 10];
        system.debug(accList);
         return [ SELECT id, Name, Industry, Rating,Phone FROM Account LIMIT 10];
    } 

       
    @AuraEnabled
   public static List<Account> getData(string str) {
       try{
            string Name= '%'+str+'%';
        

        return [ SELECT id, Name, Industry, Rating,Phone,Type FROM Account WHERE Name LIKE :name];
        }
    catch(Exception e){
            throw new AuraHandledException(e.getMessage());

       }
   } 
}