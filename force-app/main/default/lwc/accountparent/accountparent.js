import { LightningElement ,api, wire, track} from 'lwc';
import getAccountList from '@salesforce/apex/AccountController.getAccountDataList';
import NAME from '@salesforce/schema/Account.Name';
import TYPE from '@salesforce/schema/Account.Type';
import EMAIL from '@salesforce/schema/Account.Email__c';
import RATING from '@salesforce/schema/Account.Rating';
import OBJECT_NAME from '@salesforce/schema/Account';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Accountparent extends LightningElement {
    

    @track isModalOpen = false;
    @track isModalUpdateOpen = false;
    objectApiName =  OBJECT_NAME;
    accountFields = [NAME, TYPE, EMAIL, RATING];


    @track columns = [{
            label: 'Account name',
            fieldName: 'Name',
            type: 'text',
            sortable: true
        },
        {
            label: 'Type',
            fieldName: 'Type',
            type: 'text',
            sortable: true
        },
        {
            label: 'Email',
            fieldName: 'Email__c',
            type: 'Email',
            sortable: true
        },
        {
            label: 'Rating',
            fieldName: 'Rating',
            type: 'test',
            sortable: true
        }
    ];
 
    @track error;
    @track accList ;
    wiredResult;
    selectedAccountId;
    passAccountId;


    //Get account records from apex class
    @wire(getAccountList)
    wiredAccounts(result) {
        this.wiredResult = result;
        if (result.data) {
            this.accList = result.data;
            refreshApex(this.wiredResult);
        } else if (result.error) {
            this.error = result.error;
        }
    }
    
    //
    handleSuccess(){
        this.isModalOpen = false;
        const event = new ShowToastEvent({
            title: 'success',
            message: 'Record is created successfully',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        refreshApex(this.wiredResult);
    };
    
    handleUpdateSuccess() {
        this.isModalUpdateOpen = false;
        const event = new ShowToastEvent({
            title: 'success',
            message: 'Record is updated successfully',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        return refreshApex(this.wiredResult);
    }


   


    handleSelect(event) {
        let selectedItem = event.detail.selectedRows;
        if (selectedItem) {
            this.selectedAccountId=selectedItem[0].Id;
            console.log('csd '+this.selectedAccountId)
        } 
    }


    createModalClick() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }


    updateModalClick() {
        if (this.selectedAccountId.length != null){
        this.isModalUpdateOpen = true;
       
        console.log(this.selectedAccountId.length)
        }
        else {
            const evt = new ShowToastEvent({
                title: 'info',
                message: 'Please select record',
                variant: 'info',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }   
    }
    closeUpdateModal() {
        this.isModalUpdateOpen = false;
    }
 
 showContactClick(){
    this.passAccountId = this.selectedAccountId;
    console.log(this.passAccountId)
 }   
}

