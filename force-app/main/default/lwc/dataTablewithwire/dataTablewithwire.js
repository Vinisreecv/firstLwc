
import { LightningElement, track, wire } from 'lwc';
import getAccountList from '@salesforce/apex/AccountController.getAccountList';

export default class DataTablewithwire extends LightningElement {
    @track datavalue;
    @track error;
    
    @track columns = [
        { label: 'Label', fieldName: 'Name' },
        { label: 'Phone', fieldName: 'Phone' },
        { label: 'Industry', fieldName: 'Industry' },
    ];

    @wire(getAccountList)
    wiredAccounts({data,error}) {
        if (data) {
            this.datavalue = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.datavalue = undefined;
        }
    }
}
