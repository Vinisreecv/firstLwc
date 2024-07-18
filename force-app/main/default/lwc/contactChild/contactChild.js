
import { LightningElement, wire, api, track } from 'lwc';


import getRelatedContacts from '@salesforce/apex/ContactController.getRelatedContacts';

export default class ContactChild extends LightningElement {
    

    @api accountId;
    contacts = [];
    @track showTable=false;


    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Email', fieldName: 'Email', type: 'email' }
    ];


    @wire(getRelatedContacts, { accountId: '$accountId' })
    wiredAccounts(result) {
        if (result.data) {
            this.contacts = result.data;
            this.showTable=true;
        } else if (result.error) {
            this.error = result.error;
        }
    }
    }




