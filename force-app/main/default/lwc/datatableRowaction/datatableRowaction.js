
import { LightningElement } from 'lwc';
import getData from '@salesforce/apex/AccountController.getData';

export default class DataTablewithwire extends LightningElement {
   
    //search bar:
    searchValue;
    displayResult;
    handleSearch(event){
        this.searchValue=event.target.value;
        this.imperativecall();

    }
    imperativecall(){
        getData({str:this.searchValue})
        .then((result)=>{
            console.log('result is',result);
            this.displayResult=result;
        })
        .catch((error)=>{
            console.log('error occured in search datatable js',error);
        })
    }

    
}
