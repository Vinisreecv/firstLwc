/**
* @File Name          : NewAccountFormCls.cls
* @Description        : This controller help to get Dynamic PageLayout and Create Account and Services andCase record .
* @TestClass          : NewAccountFormClsTest
* @Author             : Citiustech
* @Modification Log   :
* Ver       Date               Developer                       Modification
* 1.0    15-11-2023            Sukanya          Initial Implementation.
**/
public with sharing class NewAccountFormCls {
    
    /********************************************************************************************************************************************************
* Method Name          : getCurrentUserProgram
* @Description         : Retrieves the current user's program based on the active Program Users.
* @CreatedDate         : 15th Nov 2023
* @Author              : Sukanya 
**********************************************************************************************************************************************************/
    @AuraEnabled 
    public static List<Program_Users__c> getCurrentUserProgram(){
        List<Program_Users__c> proObjUser = REMSUtility.getCurrentUserPrograms();
        return proObjUser;
    }
    
    /********************************************************************************************************************************************************
* Method Name          : getAccountRecordTypeList
* @Description        : Retrieves the list of Pagelayout Configurations for the current user's program.
* @CreatedDate         : 15th Nov 2023
* @Author              : Sukanya 
**********************************************************************************************************************************************************/
    @AuraEnabled 
    public static List<Pagelayout_Configuration__mdt> getAccountRecordTypeList(String programName) {
        try {
            List<Pagelayout_Configuration__mdt> serviceList = [SELECT Id, Object_Name__c, Label, PageLayout_Name__c, Program__c, Program_Name__c, Quick_Action_Name__c,
                                                               RecordType_Name__c, Rems_Service_RCtype__c, Requestor_Type__c, Title__c 
                                                               FROM Pagelayout_Configuration__mdt 
                                                               WHERE Program_Name__r.MasterLabel = :programName  AND Quick_Action_Name__c='' AND Title__c != '' ORDER BY Label];
            return serviceList;
        } catch (QueryException e) {
            throw new AuraHandledException('Error fetching Pagelayout_Configuration__mdt records: ' + e.getMessage());
        }    
    }
    
    /********************************************************************************************************************************************************
* Method Name          : getAccountEdtPage
* @Description        : Retrieves the fields for Editing an account based on the specified service configuration and record type.
* @CreatedDate         : 21th Nov 2023
* @Author              : Saurabh 
* @param recordtypeId    : Id of the selected record type.
* @return                : Map of section names to a list of WrapperClass containing field details.
**********************************************************************************************************************************************************/
    
    @AuraEnabled(cacheable=true)
    public static Map<String, List<REMSUtility.WrapperClass>> getAccountEdtPage(String accountId){
        if(String.isEmpty(accountId)) {
            return null;
        }
        Map<String, List<REMSUtility.WrapperClass>> serviceFieldMap = new Map<String, List<REMSUtility.WrapperClass>>();
        try {
            List<Account> accountList = [SELECT Id, RecordType.DeveloperName, REMS_Program__r.Name FROM Account WHERE Id =: accountId];
            
            if (!accountList.isEmpty()) {
                serviceFieldMap = REMSUtility.getData(accountId, 'Account', accountList[0].RecordType.DeveloperName, accountList[0].REMS_Program__r.Name,'');
            }
        } catch (Exception ex) {
            throw new AuraHandledException('An unexpected error occurred: ' + ex.getMessage());
        }
        return serviceFieldMap;
    }    
    
    
    /********************************************************************************************************************************************************
* Method Name          : getAccountCreationPage
* @Description        : Retrieves the fields for creating an account based on the specified service configuration and record type.
* @CreatedDate         : 17th Nov 2023
* @Author              : Sukanya 
* @param serviceConfigId : Id of the selected service configuration.
* @param recordtypeId    : Id of the selected record type.
* @return                : Map of section names to a list of WrapperClass containing field details.
**********************************************************************************************************************************************************/
    @AuraEnabled 
    public static Map<String,List<REMSUtility.WrapperClass>> getAccountCreationPage(String serviceConfigId,string recordtypeId){
        Map<String, List<REMSUtility.WrapperClass>> serviceFieldMap = new Map<String, List<REMSUtility.WrapperClass>>();
        Map<String, String> serviceMap = new Map<String, String>();
        Map<String, Pagelayout_Configuration__mdt> programUserMap = new Map<String, Pagelayout_Configuration__mdt>();
        
        try {
            List<Pagelayout_Configuration__mdt> serviceList = [SELECT Id, Object_Name__c, Label, PageLayout_Name__c, Program__c, Program_Name__c, Quick_Action_Name__c, RecordType_Name__c, Rems_Service_RCtype__c, Requestor_Type__c, Title__c, Program_Name__r.MasterLabel FROM Pagelayout_Configuration__mdt
                                                               WHERE Id = :serviceConfigId AND RecordType_Name__c = :recordtypeId];
            
            if (!serviceList.isEmpty()) {
                serviceFieldMap = REMSUtility.getData(null, serviceList[0].Object_Name__c, serviceList[0].RecordType_Name__c, serviceList[0].Program_Name__r.MasterLabel, serviceList[0].Requestor_Type__c);
            }
        }  catch (Exception ex) {
            throw new AuraHandledException('An unexpected error occurred: ' + ex.getMessage());
        }
        
        return serviceFieldMap;
    }
    
    /********************************************************************************************************************************************************
* Method Name          :getEnrollmentRecordType
* @Description        : Retrieves the Pagelayout Configuration for the specified service configuration Id.
* @CreatedDate         : 15th Nov 2023
* @Author              : Sukanya 
* @param serviceConfigId : Id of the selected service configuration.
* @return               : Pagelayout_Configuration__mdt record.
**********************************************************************************************************************************************************/    
    @AuraEnabled
    public static Pagelayout_Configuration__mdt getEnrollmentRecordType(String serviceConfigId) {
        try {
            Map<String, List<WrapperClass>> serviceFieldMap = new Map<String, List<WrapperClass>>();
            Map<String, String> serviceMap = new Map<String, String>();
            Map<String, Pagelayout_Configuration__mdt> programUserMap = new Map<String, Pagelayout_Configuration__mdt>();
            List<Pagelayout_Configuration__mdt> serviceList = [SELECT Id, Object_Name__c, Label, PageLayout_Name__c, Program__c, Program_Name__c, Quick_Action_Name__c, RecordType_Name__c, Rems_Service_RCtype__c, Requestor_Type__c, Title__c, Program_Name__r.Label, Program_Name__r.MasterLabel,Allow_Duplicate_NPI__c FROM Pagelayout_Configuration__mdt
                                                               WHERE Id = :serviceConfigId];
            System.debug('serviceList'+serviceList);
            if (!serviceList.isEmpty()) {
                //Ramesh Added
                list<RecordType> recordTypeList = [SELECT Id FROM RecordType WHERE SobjectType ='Case' AND DeveloperName = : serviceList[0].RecordType_Name__c LIMIT 1];
                if(!recordTypeList.isEmpty()){
                    serviceList[0].RecordType_Name__c = recordTypeList[0].Id;
                }
                //Ramesh End
                //Id recordTypeId = [SELECT Id FROM RecordType WHERE NamespacePrefix ='productdi' AND SobjectType ='Case' AND DeveloperName = : serviceList[0].RecordType_Name__c LIMIT 1].Id;
                //serviceList[0].RecordType_Name__c = recordTypeId; //Ramesh Commented
            }
            return serviceList[0];
        }catch (Exception ex) {
            throw new AuraHandledException('An unexpected error occurred in getEnrollmentRecordType method:' + ex.getMessage());
        }
    }
    
    /********************************************************************************************************************************************************
*  Method Name: createAccount
*  Parameters: String caseRecordId, String serviceReqType, String servicerecordType, String TarObject, String TarRecordType, string programName
*  Description: This method creates an account based on the provided parameters and updates the associated case record.
*  Created Date: 15 Nov, 2023
*  Developers: Sukanya 
**********************************************************************************************************************************************************/
    @AuraEnabled
    public static String createAccount(String caseRecordId, String serviceReqType, String servicerecordType, String TarObject, String TarRecordType, String programName) {
        try {
            List<Account> actList = getAccounts(caseRecordId, serviceReqType, servicerecordType, TarObject, TarRecordType, programName);
            Database.SaveResult[] srList = Database.insert(actList, false);
            string accountId;
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    accountId = sr.getId();
                }else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) { 
                        System.debug(err.getMessage());            
                    }
                } 
            }
            updateCase(caseRecordId,accountId);
            return accountId;
        } catch (Exception ex) {
            System.debug(ex.getMessage()+':::'+ex.getStackTraceString());
            throw new AuraHandledException('An unexpected error occurred: ' + ex.getMessage());
        }
    }

    private static List<Account> getAccounts(String caseRecordId, String serviceReqType, String servicerecordType, String TarObject, String TarRecordType, String programName){
        List<Account> actList = new List<Account>();
        String srecodtypeName = [SELECT Name, DeveloperName FROM RecordType WHERE Id = :TarRecordType LIMIT 1].DeveloperName;

        List<Field_Mapping_Config__mdt> fieldMappingList = [SELECT Source_Object__c, Source_Field__c, Source_RecordType_Name__c, Target_Field__c, Target_Object__c, Target_RecordType_Name__c FROM Field_Mapping_Config__mdt
        WHERE Is_Account_Creation__c = true AND Source_Object__c = : TarObject AND Program__r.MasterLabel=:programName AND Source_RecordType_Name__c =: srecodtypeName AND Target_RecordType_Name__c!=null AND IsActive__c = TRUE];
                if(Test.isRunningTest()){
            fieldMappingList = new List<Field_Mapping_Config__mdt>{new Field_Mapping_Config__mdt(Source_Object__c='Case',Source_Field__c=REMSAppLiterals.NAMESPACE_STRING+'Ship_to_Address_Same_as_Above__c',Target_Field__c=REMSAppLiterals.NAMESPACE_STRING+'Ship_to_Address_Same_as_Above__c',Source_RecordType_Name__c='Outpatient_Pharmacy_Enrollment',Target_RecordType_Name__c='Outpatient_Pharmacy_Account'),
                new Field_Mapping_Config__mdt(Source_Object__c='Case',Source_Field__c=REMSAppLiterals.NAMESPACE_STRING+'Date__c',Target_Field__c=REMSAppLiterals.NAMESPACE_STRING+'Prescriber_Signature_Date__c',Source_RecordType_Name__c='Outpatient_Pharmacy_Enrollment',Target_RecordType_Name__c='Outpatient_Pharmacy_Account'),
                new Field_Mapping_Config__mdt(Source_Object__c='Case',Source_Field__c=REMSAppLiterals.NAMESPACE_STRING+'DEA__c',Target_Field__c=REMSAppLiterals.NAMESPACE_STRING+'DEA__c',Source_RecordType_Name__c='Outpatient_Pharmacy_Enrollment',Target_RecordType_Name__c='Outpatient_Pharmacy_Account')};
        }
        Map<String, String> TargetSourceMap = new Map<String, String>();
        Set<String> dynamicFieldSet = new Set<String>();

        for (Field_Mapping_Config__mdt mdt : fieldMappingList) {
            TargetSourceMap.put(mdt.Target_Field__c, mdt.Source_Field__c);
            dynamicFieldSet.add(mdt.Source_Field__c);
        }

        List<SObject> sObjectRecList = new List<SObject>();
        Map<String, String> TargetFieldToValueMap = new Map<String, String>();

        String dynamicFieldStr = String.join(new List<String>(dynamicFieldSet), ',');
        String dynamicQueryStr = 'SELECT ' + dynamicFieldStr + ' FROM Case WHERE Id = :caseRecordId';

        sObjectRecList = Database.query(dynamicQueryStr);

        for (String Field : TargetSourceMap.KeySet()) {
            String Value = TargetSourceMap.get(Field);
            String FieldValue = String.valueOf(sObjectRecList[0].get(Value));
            TargetFieldToValueMap.put(Field, String.isBlank(FieldValue) ? ' ' : FieldValue);
        }
        system.debug('++++fieldmappingLIst'+fieldMappingList[0]);
        Account acc = new Account();
        Id recordTypeId = [SELECT Id FROM RecordType WHERE SobjectType ='Account' AND DeveloperName = : fieldMappingList[0].Target_RecordType_Name__c LIMIT 1].Id;
        acc.RecordTypeId = recordTypeId;
        for (String fld : TargetFieldToValueMap.keySet()) {
            if (Schema.getGlobalDescribe().get(acc.getSObjectType().getDescribe().getName()).getDescribe().fields.getMap().get(fld).getDescribe().getType() == Schema.DisplayType.Date) {
                try {
                    if(TargetFieldToValueMap.get(fld) != null){
                        Date dateValue = Date.valueOf(TargetFieldToValueMap.get(fld));
                        acc.put(fld, dateValue);
                    }
                } catch (Exception e) {
                    acc.put(fld, null);
                }
            }else if (Schema.getGlobalDescribe().get(acc.getSObjectType().getDescribe().getName()).getDescribe().fields.getMap().get(fld).getDescribe().getType() == Schema.DisplayType.Boolean) {
                try {
                    if(TargetFieldToValueMap.get(fld) != null){
                        Boolean booleanValue = Boolean.valueOf(TargetFieldToValueMap.get(fld));
                        acc.put(fld, booleanValue);
                    }
                } catch (Exception e) {
                    acc.put(fld, null);
                }
            } else {
                acc.put(fld, TargetFieldToValueMap.get(fld));
            }
        }
        actList.add(acc);
        return actList;
    }
    
    /********************************************************************************************************************************************************
* Method Name: updateCase
* Parameters: String caseRecordId, Id accountId, Id remsSummaryId
* Description: This private method updates a Case record with the specified participant and REMS service summary IDs.
*              It is used in the process of creating an Account and associating it with a Case.
* Created Date: [Insert Date]
* Developers: [Insert Developer Names]
**********************************************************************************************************************************************************/
    @AuraEnabled
    public static void updateCase(String caseRecordId, Id accountId) {
        try {
            List<REMS_Service_Summary__c> remsSummaryList = [SELECT Id,Requestor_Type__c,REMSProgram__c,REMSProgram__r.Name, RecordtypeId, RecordType.DeveloperName,Participant__c  FROM REMS_Service_Summary__c WHERE Participant__c  = :accountId LIMIT 1];
            if(!remsSummaryList.isEmpty()){
                Account accObj = [Select Id,REMS_ID__c from Account where Id=:accountId limit 1];
                Case cs = new Case(Id = caseRecordId);
                cs.Participant__c = accountId;
                cs.REMS_Service_Summary__c = remsSummaryList[0].Id;
                if(remsSummaryList[0].RecordType.DeveloperName !='Enrollment'){
                    cs.Status = 'Complete';
                    cs.Outcome__c = 'Complete';
                }
                cs.REMS_ID__c = accObj.REMS_ID__c;
                update cs;
            }
        } catch (Exception ex) {
            System.debug(ex.getMessage()+':::'+ex.getStackTraceString());
            throw new AuraHandledException('Error updating Case: ' + ex.getMessage());
        }
    }
    /********************************************************************************************************************************************************
* Method Name          : getCaseEditPage
* @Description        : Retrieves the fields for Editing an Case based on the specified service configuration and record type.
* @CreatedDate         : 19th Dec 2023
* @Author              : Sukanya 
* @param recordtypeId    : Id of the selected record type.
* @return                : Map of section names to a list of WrapperClass containing field details.
**********************************************************************************************************************************************************/
    
    @AuraEnabled(cacheable=true)
    public static Map<String, List<REMSUtility.WrapperClass>> getCaseEditPage(String caseId){
        if(String.isEmpty(caseId)) {
            return null;
        }
        Map<String, List<REMSUtility.WrapperClass>> serviceFieldMap = new Map<String, List<REMSUtility.WrapperClass>>();
        try {
            List<Case> caseList = [SELECT Id, RecordType.DeveloperName, REMS_Program__r.Name, Service_Requestor_Type__c FROM Case WHERE Id =: caseId];
            
            if (!caseList.isEmpty()) {
                serviceFieldMap = REMSUtility.getData(caseId, 'Case', caseList[0].RecordType.DeveloperName, caseList[0].REMS_Program__r.Name,caseList[0].Service_Requestor_Type__c);
                Map<String,Boolean> readOnlyFldsMap = getReadonlyFields (caseId, caseList[0].REMS_Program__r.Name,caseList[0].RecordType.DeveloperName,caseList[0].Service_Requestor_Type__c) ;
                if(!readOnlyFldsMap.isEmpty()){
                    for(String SectionName: serviceFieldMap.keySet()){
                    for(REMSUtility.WrapperClass serviceFldObj: serviceFieldMap.get(SectionName)){
                        if(readOnlyFldsMap.containsKey(serviceFldObj.fieldName)){
                            serviceFldObj.editable = true;
                        }
                        
                    }
                    }
                }
            }
        } catch (Exception ex) {
            throw new AuraHandledException('An unexpected error occurred: ' + ex.getMessage());
        }
        return serviceFieldMap;
    }    
    
    /********************************************************************************************************************************************************
* Method Name          : getServiceCreation
* @Description         : Retrieves the Service creation Records.
* @CreatedDate         : 15th Nov 2023
* @Author              : Satyam
**********************************************************************************************************************************************************/
    @AuraEnabled
    public static Map<String, List<REMSUtility.WrapperClass>> getServiceCreation(REMS_Service_Configuration__mdt serviceConfigObj) {
        Map<String, List<REMSUtility.WrapperClass>> serviceFieldMap = new Map<String, List<REMSUtility.WrapperClass>>();
        Map<String, String> serviceMap = new Map<String, String>();
        try {
            system.debug('Service : '+serviceConfigObj);
            serviceFieldMap = REMSUtility.getData(
                null,
                serviceConfigObj.Object__c,
                serviceConfigObj.Case_Record_Type__c,
                serviceConfigObj.Program_Configuration__r.MasterLabel,
                serviceConfigObj.Participant_Type__c
            );
            System.debug('NewAccount FROM line 294---'+serviceFieldMap);
        } catch (Exception ex) {
            throw new AuraHandledException(
                'An unexpected error occurred: ' + ex.getMessage()
            );
        }
        
        return serviceFieldMap;
    }
    
    /********************************************************************************************************************************************************
* Method Name            : getServiceConfigRecords
* @Description           : Retrieves the NPI Status change for a specific participant type, service type, and program name.
* @param participantType : The type of participant for filtering records.
* @param serviceType     : The type of service for filtering records.
* @param programName     : The name of the program for filtering records.
* @return                : An instance of REMS_Service_Configuration__mdt containing the retrieved information.
* @CreatedDate           : 9th Nov 2023
* @Author                : Sukanya
**********************************************************************************************************************************************************/
    
    @AuraEnabled
    public static REMS_Service_Configuration__mdt getServiceConfigRecords(String participantType,String serviceType,String programName) {
        return  [SELECT Id, Object__c, Service_Type__c, Case_Record_Type__c, Program_Configuration__c, Program_Configuration__r.MasterLabel, 
                 Participant_Type__c,Title__c,Participant_Field__c,Account_Record_Type__c,Service_Record_Type__c, Validate_AR_Info__c,
                 Validate_NPI__c,Upload_Attachments__c, Sub_Participant_Type__c,Requestor_Type__c,Override_Requestor_Type__c,
                 Validate_Dupcheck__c,Warning_Message__c, Allow_Duplicate_NPI__c
                 FROM REMS_Service_Configuration__mdt
                 WHERE Participant_Type__c = :participantType
                 AND Service_Type__c = :serviceType
                 AND  Program_Configuration__r.MasterLabel =: programName LIMIT 1];
    }
    
    
    /********************************************************************************************************************************************************
* Method Name          : validateNpiStatus
* @Description         : Retrieves the NPI Status change.
* @CreatedDate         : 15th Nov 2023
* @Author              : Satyam
**********************************************************************************************************************************************************/
    @AuraEnabled
    public static Boolean validateNpiStatus(String npiValue) {
        Boolean isValidNpi = false;
        List<HealthcareProviderNpi> healthCareNpi = [
            SELECT Id, Npi
            FROM HealthcareProviderNpi
            WHERE Npi = :npiValue
            LIMIT 1
        ];
        if (!healthCareNpi?.isEmpty()) {
            if (healthCareNpi[0].Npi == npiValue) {
                isValidNpi = true;
            }
        }
        return isValidNpi;
    }
    
    /********************************************************************************************************************************************************
* Method Name          : fetchRecordTypeId
* @Description         : Retrieves the RecordTypeId.
* @CreatedDate         : 15th Nov 2023
* @Author              : Satyam
**********************************************************************************************************************************************************/
    @AuraEnabled
    public static String fetchRecordTypeId(
        String recordTypeName,
        String objectName
    ) {
        return REMSUtility.retrieveRecTypeDeveloperNameId(objectName).get(recordTypeName);
    }
    
    /********************************************************************************************************************************************************
* Method Name          : getCaseFieldAndValueMap
* @Description         : Retrieves the Case Fields with its values.
* @CreatedDate         : 15th Nov 2023
* @Author              : Satyam
**********************************************************************************************************************************************************/
    @AuraEnabled
    public static Map<String, String> getCaseFieldAndValueMap(String accountId,String requestorType,String targetObject,String sourceObject,String sourceRecordType,String parentFieldType,String programName,Boolean overrideReqType) {
        List<Account> actList = new List<Account>();
        List<SObject> sObjectRecList = new List<SObject>();
        Map<String, String> TargetFieldToValueMap = new Map<String, String>();
        Map<String, String> TargetSourceMap = new Map<String, String>();
        Set<String> dynamicFieldSet = new Set<String>();
        if(overrideReqType == true && !String.isBlank(accountId)){
            actList = [SELECT Id,Recordtype.Name FROM Account WHERE Id=:accountId];
            requestorType = actList[0].Recordtype.Name;
        }
        List<Field_Mapping_Config__mdt> fieldMappingList = [SELECT Source_Object__c,Source_Field__c,Target_Field__c,Target_Object__c,Target_RecordType_Name__c,Source_RecordType_Name__c,Parent_Field__c,IsActive__c,Order__c
                                                            FROM Field_Mapping_Config__mdt WHERE Source_Object__c = :sourceObject AND Program__r.MasterLabel = :programName AND Target_Object__c = :targetObject AND Request_Type__c = :requestorType
                                                            AND Source_RecordType_Name__c = :sourceRecordType AND Parent_Field__c = :parentFieldType AND IsActive__c =: true ORDER By Order__c];
        for (Field_Mapping_Config__mdt mdt : fieldMappingList) {
            TargetSourceMap.put(mdt.Source_Field__c, mdt.Target_Field__c);
            dynamicFieldSet.add(mdt.Target_Field__c);
        }
        System.debug(fieldMappingList);
        String dynamicFieldStr = String.join( new List<String>(dynamicFieldSet),',' );
        if(accountId!=null && accountId!=''){
            String dynamicQueryStr = 'SELECT ' + dynamicFieldStr + ' FROM Account WHERE Id = :accountId';
            System.debug(dynamicQueryStr);
            sObjectRecList = Database.query(dynamicQueryStr);
            for (String Field : TargetSourceMap.KeySet()) {
                
                String FieldValue = String.valueOf(
                    sObjectRecList[0].get(TargetSourceMap.get(Field))
                );
                
                TargetFieldToValueMap.put(Field ,  String.isBlank(FieldValue) ? '': FieldValue);
                //TargetFieldToValueMap.put(Field, String.isBlank(FieldValue) ? ' ': FieldValue);
            }   
        }else{
            for (String Field : TargetSourceMap.KeySet()) {
                TargetFieldToValueMap.put(Field ,  '');
            }
        }
        return TargetFieldToValueMap;
    }
    
    
    /********************************************************************************************************************************************************
* Method Name          : createEnrollmentService
* @Description         : This method creates the Enrollment Service.
* @CreatedDate         : 15th Nov 2023
* @Author              : Satyam
**********************************************************************************************************************************************************/
    @AuraEnabled
    public static String createEnrollmentService(
        String programId,
        String accountId,
        String participantType,
        String ServiceRecordTypeName
    ) {
        try{
            REMS_Service_Summary__c serviceRecord = new REMS_Service_Summary__c();
            serviceRecord.REMSProgram__c = programId;
            serviceRecord.Participant__c = accountId;
            serviceRecord.Requestor_Type__c = participantType;
            serviceRecord.RecordTypeId = fetchRecordTypeId(
                ServiceRecordTypeName,
                REMSAppLiterals.SERVICE_SUMMARY_OBJECT
            );
            insert serviceRecord;
            return serviceRecord.Id ;
        } catch (Exception ex) {
            throw new AuraHandledException(
                'An unexpected error occurred: ' + ex.getMessage()
            );
        }
    }
    
    /********************************************************************************************************************************************************
MethodName : getNameSpace
Description: This method will to get Namespace
CreatedDate: 10 Oct, 2023
***********************************************************************************************************************************************************/ 
    @AuraEnabled    
    public static String getNameSpace(){
        String NameSpace_Str = REMSAppLiterals.NAMESPACE_STRING;
        return NameSpace_Str;
    } 
    
    
    @AuraEnabled(cacheable=true)
    public static List<String> getPermissionSets() {
        String currentUserId = UserInfo.getUserId();
        List<String> permissionSetNames = new List<String>();
        for (PermissionSetAssignment assignment : [SELECT PermissionSet.Name
                                                   FROM PermissionSetAssignment
                                                   WHERE AssigneeId = :currentUserId]) {
                                                       permissionSetNames.add(assignment.PermissionSet.Name);
                                                   }
        return permissionSetNames;
    }
    
    /********************************************************************************************************************************************************
MethodName : checkNPIDuplicate
Description: This method retrieves the checkNPIDuplicate.
CreatedDate: 23 Feb 2024
@Author    : Jakeer
***********************************************************************************************************************************************************/
    @AuraEnabled
    public static Boolean checkNPIDuplicate(String NPIValue, String recordType, String program){
        Boolean checkNPIDuplicate = false;
        try {
            if(NPIValue.length() ==10){
                List<Account> accounts = new List<Account>([SELECT Id,Name,National_Provider_Identifier__c FROM Account WHERE National_Provider_Identifier__c=:NPIValue AND Recordtype_Label__c = :recordType AND REMS_Program__c = :program LIMIT 1]);
                if(accounts.size() > 0) return checkNPIDuplicate=true;
            }
            
        } catch (Exception e) {
            checkNPIDuplicate=false;
            throw new AuraHandledException(e.getMessage());
        }
        return checkNPIDuplicate;
    }
    /********************************************************************************************************************************************************
MethodName : getAssessmentResponse
Description: This method retrieves Assessment Submission Result based on Account Id.
CreatedDate: 18 Feb 2024
@Author    : Sukanya
**************************************************************************************************************/
    
    @AuraEnabled(cacheable=true)
    public static String getAssessmentResponse(String accountId) {
        try{
            List<Account> actObjList =[SELECT Id FROM Account WHERE Id=:accountId LIMIT 1];
            if(!actObjList.isEmpty()){
                List<Case> caseObjList =[SELECT Id, First_Name__c, Last_Name__c,REMS_Program__c,Service_Requestor_Type__c FROM Case WHERE Participant__c =:actObjList[0].Id AND Recordtype.DeveloperName=:REMSAPPLITERALS.CASE_RECORDTYPE_KNOWLEDGE_ASSESSMENT ORDER BY CreatedDate DESC LIMIT 1];
                
                if(caseObjList.isEmpty()){
                    return null;
                }
                
                List<Assessment__c> assessmentList= [SELECT id, Name FROM Assessment__c 
                                                     WHERE REMS_Program__c= :caseObjList[0].REMS_Program__c 
                                                     AND Participant_Type__c = :caseObjList[0].Service_Requestor_Type__c LIMIT 1];
                if(assessmentList.isEmpty()){
                    return null;
                }
                
                List<Assessment_Submission__c> recentSubmissionList = new  List<Assessment_Submission__c>();
                recentSubmissionList= [SELECT Id,Name, Assessment_Result__c, Assessment__r.Name
                                       FROM Assessment_Submission__c
                                       WHERE Case__c=:caseObjList[0].Id 
                                       AND Assessment__c=:assessmentList[0].Id
                                       ORDER BY CreatedDate desc LIMIT 1];                 
                if(!recentSubmissionList.isEmpty()){
                    return recentSubmissionList[0].Assessment_Result__c;
                }else {
                    return 'Not Started';
                }   
            }else{
                return 'Not Started';
            }
            
        }
        catch (Exception ex) {
            throw new AuraHandledException('An unexpected error occurred: ' + ex.getMessage());   
        }                                
    }
    
    /********************************************************************************************************************************************************
* Wrapper Class: WrapperClass
* Description: This inner class represents a wrapper for fields and configurations used in the Lightning component.
* Developers: Sukanya 
**********************************************************************************************************************************************************/
    
    public class WrapperClass{
        @AuraEnabled
        public String fieldType{get;set;}
        @AuraEnabled
        public String fieldLabel{get;set;}
        @AuraEnabled
        public String fieldAPIName{get;set;}
        @AuraEnabled 
        public List<String> pickListValues{get;set;}
        @AuraEnabled
        public Boolean required{get;set;}
        @AuraEnabled
        public Boolean visible{get;set;}
        @AuraEnabled
        public Boolean editable{get;set;}
        @AuraEnabled
        public String objectName{get;set;}
        @AuraEnabled
        public String recordType{get;set;}
        @AuraEnabled
        public String programCode{get;set;}
        @AuraEnabled
        public String sectionName{get;set;}
        @AuraEnabled
        public Integer order{get;set;}
        @AuraEnabled
        public String fieldName{get;set;}
        @AuraEnabled
        public String fieldValue{get;set;}
        @AuraEnabled
        public Boolean softrequired{get;set;}
    } 
    /****************************************************************************************************
MethodName : getPrimaryARDetails
Description: This method retrieves the primary Affiliation Record details based on the provided Account Id, Program Name, and Case Record Type Name.
CreatedDate: 22 Mar 2024
@Author    : Devara Moses
* **********************************************************************************************/
    @AuraEnabled
    public static Map<String,String> getPrimaryARDetails(Id accountId, String programName, String caseRecordtypeName){
        Affiliation_Setup_Configuration__mdt affConfigObj;
        List<Affiliation_Setup_Configuration__mdt> affConfigList = new List<Affiliation_Setup_Configuration__mdt>();
        List<Affiliation__c> arAffList = new List<Affiliation__c>();
        Map<String,String> affiliationARMap = new Map<String,String>();
        affConfigList = REMSUtility.geteAffiliationSetupRecords(caseRecordtypeName, programName);
        if(!affConfigList.isEmpty()){ 
            affConfigObj = affConfigList[0];
        }
        if(Test.isRunningTest()) {
            affConfigObj = new Affiliation_Setup_Configuration__mdt(
                Affiliated_Target_Field__c = 'Pharmacy_User__c',
                Affiliation_Parent_Field__c = 'Pharmacy__c',
                Affiliation_Reference_Field__c = 'Participant__c',
                Affiliation_Source_Field__c = 'Prescriber_Delegate__c',
                Affiliation_Source_Record_Type__c = 'Prescriber_enrollment',
                Affiliation_Target_Record_Type__c = 'Prescriber_Delegate_Affiliation'
            );
        }
        if(affConfigObj!=null){
            String affQuery = 'Select Id, '+affConfigObj.Affiliated_Target_Field__c+' FROM Affiliation__c WHERE '+affConfigObj.Affiliation_Parent_Field__c+' = :accountId And User_Role__c=\''+REMSAppLiterals.PRIMARY_AR_ROLE+'\' order by lastmodifieddate desc Limit 1';
            arAffList = Database.query(affQuery); 
            if(!arAffList.isEmpty()){
                affiliationARMap.put(affConfigObj.Affiliation_Source_Field__c, (String)arAffList[0].get(affConfigObj.Affiliated_Target_Field__c));
                return affiliationARMap;
            }
        }
        return null;
    }
    
    @AuraEnabled
    public static Boolean deleteContentDocument(sObject recordToDelete){
        Boolean isSuccess = false;
        try {
            delete recordToDelete;
            isSuccess = true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return isSuccess;
    }
    
    @AuraEnabled
    public static Boolean relatedContentDocument(Id caseId,List<Id> listContentDocumentId){
        Boolean isSuccess = false;
        List<ContentDocumentLink> listContentDocumentLink = new List<ContentDocumentLink>();
        try {
            if (!listContentDocumentId?.isEmpty()) {
                for (Id idContentDocument : listContentDocumentId) {
                    ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                    objContentDocumentLink.LinkedEntityId = caseId;
                    objContentDocumentLink.contentdocumentid = idContentDocument;
                    objContentDocumentLink.ShareType = 'V';
                    listContentDocumentLink.add(objContentDocumentLink);
                }
                if (!listContentDocumentLink.isEmpty()) {
                    insert listContentDocumentLink;
                }
            }
            isSuccess = true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return isSuccess;
    }
    
    @AuraEnabled
    
    public static Map<String,Boolean> getReadonlyFields(Id caseRecordId, String programName, String recordTypeName, String requestorTypeName){
       system.debug('+++requestorTypeName'+requestorTypeName);
        Map<String,Boolean> readOnlyFldsMap = new Map<String,Boolean>();
        List<Program_Fields_Configuration__c> parentPFCList = new List<Program_Fields_Configuration__c>();
        List<Field_Mapping_Config__mdt> relatedfldMapList = new List<Field_Mapping_Config__mdt>();
        Set<String> parentFldSet = new Set<String>();
        String caseQueryFlds;
        String caseQuery;
        parentPFCList = [SELECT Id,Target_Object_Field__c from Program_Fields_Configuration__c WHERE Target_Object_Record_Type__c=:recordTypeName
                         AND Requestor_Type__c=:requestorTypeName AND Disabled_Related_Fields__c=true
                         AND REMS_Program__r.Name = :programName AND Target_Object_Field__c!=null];
        if(!parentPFCList.isEmpty()){
            for(Program_Fields_Configuration__c pfcObj: parentPFCList){
                parentFldSet.add(pfcObj.Target_Object_Field__c);
            }
        
        if(!parentFldSet.isEmpty()){
            caseQueryFlds = String.join(parentFldSet, ',');
        }
        if(caseQueryFlds!=null){
            caseQuery = 'SELECT Id, '+caseQueryFlds+' FROM Case WHERE ID=:caseRecordId';
            Case caseObj=Database.Query(caseQuery);
            if(caseObj!=null){
                relatedfldMapList = getRealtedFieldMappingConfig(parentFldSet, programName, requestorTypeName, recordTypeName);
                for(Field_Mapping_Config__mdt fldMapObj: relatedfldMapList){
                    if(caseObj.get(fldMapObj.Parent_Field__c)!=null){
                        readOnlyFldsMap.put(fldMapObj.Source_Field__c,False);
                    }
                }
            }
        }
    }

    return readOnlyFldsMap;
    
}
    @AuraEnabled
    public static String updateSubstakeholder(Id caseId, Map<String,Object> parentFldSet, String programName, String requestorTypeName, String recordTypeName){
        List<Field_Mapping_Config__mdt> relatedfldMapList = new List<Field_Mapping_Config__mdt>();
        if(!parentFldSet.keyset().isEmpty() && caseId!=null){
        relatedfldMapList = getRealtedFieldMappingConfig(parentFldSet.keyset(), programName, requestorTypeName, recordTypeName);
        String caseQueryFields;
        String caseQuery;
        Case caseObj;
        Map<String,Account> parentChildFldsMap = new Map<String,Account>();
            if(!relatedfldMapList.isEmpty()){
                for(Field_Mapping_Config__mdt fldMapObj: relatedfldMapList){
                    if(fldMapObj.Source_Field__c!=null){
                        caseQueryFields = caseQueryFields!=null?caseQueryFields+','+fldMapObj.Source_Field__c:fldMapObj.Source_Field__c;
                    }
                }
            
        caseQuery = 'SELECT Id, '+caseQueryFields+' FROM Case WHERE Id=:caseId';
        caseObj = Database.Query(caseQuery);
        for(Field_Mapping_Config__mdt fldMapObj: relatedfldMapList){
            if(fldMapObj.Source_Field__c!=null && fldMapObj.Target_Field__c!=null){
                if(parentChildFldsMap.containsKey(fldMapObj.Parent_Field__c)){
                    parentChildFldsMap.get(fldMapObj.Parent_Field__c).put(fldMapObj.Target_Field__c,caseObj.get(fldMapObj.Source_Field__c));
                }else{
                    Account subStakeObj = new Account();
                    subStakeObj.put('Id',parentFldSet.get(fldMapObj.Parent_Field__c));
                    subStakeObj.put(fldMapObj.Target_Field__c,caseObj.get(fldMapObj.Source_Field__c));
                    parentChildFldsMap.put(fldMapObj.Parent_Field__c,subStakeObj);
                }
            }
        }
        }
            if(!parentChildFldsMap.isEmpty()){        
            	update parentChildFldsMap.values();
        	}
        }
        return 'Success';
    }
    public static List<Field_Mapping_Config__mdt> getRealtedFieldMappingConfig(Set<String> parentFldSet, String programName, String requestorTypeName, String recordTypeName){
        List<Field_Mapping_Config__mdt> fldMapList = new List<Field_Mapping_Config__mdt>();
        fldMapList = [SELECT Id,Source_Field__c,Target_Field__c,Parent_Field__c from Field_Mapping_Config__mdt WHERE Parent_Field__c in :parentFldSet
                                                          AND Program__r.MasterLabel = :programName AND Request_Type__c=:requestorTypeName AND Source_RecordType_Name__c=:recordTypeName];
    	return fldMapList;
    }

    /********************************************************************************************************************************************************
* Method Name          : getCasesForStakeholder
* @Description         : Retrieves the cases for given accountId
* @CreatedDate         : 25 Apr 2024
* @Author              : Amrit
**********************************************************************************************************************************************************/
@AuraEnabled
public static List<Case> getCasesForStakeholder(Id accountId, REMS_Service_Configuration__mdt serviceConfigObj) {
    List<Case> cases = new List<Case>([SELECT Id FROM Case WHERE Participant__c = :accountId AND Status != 'Complete' AND RecordType.DeveloperName = :serviceConfigObj.Case_Record_Type__c]);
    return cases;
}

/********************************************************************************************************************************************************
* Method Name          : sendOutboundCommunication
* @Description         : Create Platform Event when outbound call case updated with service Id
* @CreatedDate         : 25 Apr 2024
* @Author              : Wilco offshore
**********************************************************************************************************************************************************/

@AuraEnabled 
public static void sendOutboundCommunication(String participantId, String programId, String phoneNumber){
    Outbound_Call__e outboundCallEvent = new Outbound_Call__e();
    outboundCallEvent.Participant__c = participantId;
    outboundCallEvent.ProgramId__c = programId;
    outboundCallEvent.Phone_Number__c = phoneNumber;

    // Call method to publish events
    Database.SaveResult result = EventBus.publish(outboundCallEvent);

    if(!result.getErrors().isEmpty()){
        for(Database.Error err : result.getErrors()) {
            System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage());
        }
    }
      
}

@AuraEnabled
public static Map<String,String> validateDuplicateEmail(Map<String,Object> duplicateConfigs, String parentAccountId, string affPrimaryRef,
                                            String emailMap){
                                                system.debug('+++duplicateConfigs'+duplicateConfigs);
    Map<String,DuplicateDataWrapperCls> duplicateConfigMap = new Map<String,DuplicateDataWrapperCls> ();
   // duplicateConfigMap = duplicateConfigs;
    duplicateConfigMap = (Map<String,DuplicateDataWrapperCls>) json.deserialize(JSON.serialize(duplicateConfigs), Map<String,DuplicateDataWrapperCls>.class);
    String affQuery = 'SELECT Id';
    String accQuery = 'SELECT Id';
    Set<String> accEmailFldSet = new Set<String>();
    Set<String> affQueryFldSet = new Set<String>();
    Set<Id> accountIdSet = new Set<Id>();
    Map<Id,String> affptcpantAccountMap = new Map<Id,String>();
    Map<String,String> errormsgMap = new Map<String,String>();
    for(String emailaffFldObj: emailMap.split('#')){
        affQuery = affQuery +','+ emailaffFldObj.split(':')[0];
        affQueryFldSet.add(emailaffFldObj.split(':')[0]);
        if(!accEmailFldSet.contains(emailaffFldObj.split(':')[1])){
            accEmailFldSet.add(emailaffFldObj.split(':')[1]);
            accQuery = accQuery +','+ emailaffFldObj.split(':')[1];
        }
    }  
    
    affQuery = affQuery + ' FROM Affiliation__c WHERE '+affPrimaryRef+'=\''+parentAccountId+'\'';
    for(Affiliation__c affObj: Database.query(affQuery)){
        for(string affptcpent: affQueryFldSet){
            if(affObj.get(affptcpent)!=null){
                accountIdSet.add((Id)affObj.get(affptcpent));
                affptcpantAccountMap.put((Id)affObj.get(affptcpent),affptcpent);
            }
        }
    }

    accQuery = accQuery + ' FROM Account WHERE Id IN :accountIdSet';
    List<Account> accountList = new List<Account>();
    accountList = Database.query(accQuery);
    for(DuplicateDataWrapperCls fldConfigObj: duplicateConfigMap.values()){
        String errorMap;
        for(String emailObj: accEmailFldSet){
            for(Account accObj: accountList){
                if((String)accObj.get(emailObj) == fldConfigObj.fieldvalue){
                    string affRefFieldApiName = affptcpantAccountMap.get(accObj.Id);
                    string affRefFieldApiLabel;
                    for(String affFieldLabel:System.Label.Affiliation_References_Label_Map.split('#')){
                        if(affFieldLabel.contains(affRefFieldApiName)){
                            affRefFieldApiLabel = affFieldLabel.substring(affRefFieldApiName.length()+1);
                        }

                    }
                    errorMap  = errorMap!=null ? errorMap +','+ affRefFieldApiLabel+':'+'Email': affRefFieldApiLabel+':'+'Email';
                }
            }
        }
        errormsgMap.put(fldConfigObj.fieldName,errorMap);
    }
    return errormsgMap;
}

public class DuplicateDataWrapperCls{
    @AuraEnabled
    public string fieldName{get;set;}
    @AuraEnabled
    public string duplicateAffPrimaryPtcpant{get;set;}
    @AuraEnabled
    public string duplicateParentRef{get;set;}
    @AuraEnabled
    public string duplicateParentEmailMap{get;set;}
    @AuraEnabled
    public string fieldvalue{get;set;}
  }

}