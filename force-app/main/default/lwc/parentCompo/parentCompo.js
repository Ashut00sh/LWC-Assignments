import { LightningElement } from 'lwc';

export default class ParentCompo extends LightningElement {
    counterVal = 0;
    handleChange(event){
        this.counterVal = parseInt(event.target.value);
    }
    hanldeAddCounter(){
        // const updateCounter = this.template.querySelector('c-child-compo');
        // updateCounter.addMaxCounter();
        this.template.querySelector('c-child-compo').addMaxCounter();
    }
}