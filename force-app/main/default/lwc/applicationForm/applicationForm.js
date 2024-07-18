import { LightningElement } from 'lwc';

export default class ApplicationForm extends LightningElement {
    parentName='parent'
    greeting = 'World';

    handlechange(event){
        this.greeting=event.target.value;
    }

}