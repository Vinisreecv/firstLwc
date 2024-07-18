import { LightningElement } from 'lwc';

export default class Databinding extends LightningElement {

    fruits=['Apple','orange','banana'];
    firstName='vini';

    //get method to access the array
    get fruits(){
        return this.fruits[0];

    }
    handleChange(event){
        console.log(event.target.name);
        console.log(event.target.value);
        this.firstName=event.target.value;
    }
}