import { LightningElement,api,wire,track} from 'lwc';

import getAccountList from '@salesforce/apex/AccountController.getAccountList'

export default class ParentCompnent extends LightningElement {
//call apex -wire property or function
@wire(getAccountList)
accounHandler(response){
    if(response)
    console.log(response)
}




}