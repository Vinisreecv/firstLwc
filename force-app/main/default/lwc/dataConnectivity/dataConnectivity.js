import { LightningElement ,api} from 'lwc';

import ACCOUNT_OBJECT from '@salesforce/schema/Account'
import Name_FIELD from '@salesforce/schema/Account.Name';
import INDUSTRY_FIELD from '@salesforce/schema/Account.industry';
import ANNUALREVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';

export default class DataConnectivity extends LightningElement {
//record page visibility

@api objectApiName
@api recordId


    //homepage visibility using Lds:

   // objectName=ACCOUNT_OBJECT;
    fieldsList=[Name_FIELD,INDUSTRY_FIELD,ANNUALREVENUE_FIELD];

    updateHandler(event){

        //alert(event.detail.id)

    }
}