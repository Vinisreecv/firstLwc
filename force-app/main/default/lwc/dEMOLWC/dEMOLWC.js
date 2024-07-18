import { LightningElement, wire,api } from 'lwc';
import contactMetaData from '@salesforce/apex/contactMetadataController.contactMetaData';

const COLUMNS = [
   
    { label: 'LastName', fieldName: 'LastName' },
    { label: 'Email', fieldName: 'Email' },
    { label: 'Phone', fieldName: 'Phone' },
    { label: 'OwnerId', fieldName: 'OwnerId' },

];


export default class DEMOLWC extends LightningElement {

    @api recordId;
    records;
    //wiredRecords;
    error;
    columns = COLUMNS;
    //draftValues = [];

   /* @wire(contactMetaData,{ accountId: '$recordId'})  
    wiredRecs( value ) {

        this.wiredRecords = value;
        const { data, error } = value;

        if ( data ) {
                        
            this.records = data;
            this.error = undefined;
            console.log(this.records)

        } else if ( error ) {

            this.error = error;
            this.records = undefined;

        }

    }  */
    @wire(contactMetaData,{recordId:'$recordId'})
    wiredAccounts({
        error,
        data
    }) {
        if (data) {
            this.records = data;

        } else if (error) {
            this.error = error;
        }
    }
    
}