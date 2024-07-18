import { LightningElement } from 'lwc';

export default class ChildcomponentA extends LightningElement {
    childinputText;

    childinputTextHandler(event){
        this.childinputText=event.target.value;

    }
    handleClick(){
        this.dispatchEvent(new CustomEvent('sendevent',{
            detail:this.childinputText
        }))
    }
}