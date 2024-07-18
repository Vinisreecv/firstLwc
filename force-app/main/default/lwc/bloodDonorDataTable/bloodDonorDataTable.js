import { LightningElement,track,wire } from 'lwc';
import getbloodDonorDataList from '@salesforce/apex/blooddonorController.getbloodDonorDataList'
import NAME from '@salesforce/schema/BloodDonor__c.Name';

export default class BloodDonorDataTable extends LightningElement {

    @track columns = [{
        
        label: 'BloodDonor Name',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    }
   
];
@track bloodDonorList;
//wiredResult;

 //Get account records from apex class
 @wire(getbloodDonorDataList)
 wiredAccounts(result) {
     this.wiredResult = result;
     if (result.data) {
         this.bloodDonorList = result.data;
        // refreshApex(this.wiredResult);
     } else if (result.error) {
         this.error = result.error;
     }
 }
}