import { LightningElement } from 'lwc';

export default class ParentcomponentA extends LightningElement {

    recivedfromchild;

    recivedevent(event){
        this.recivedfromchild=event.detail

    }
}