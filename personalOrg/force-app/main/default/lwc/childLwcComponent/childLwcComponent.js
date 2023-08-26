import { LightningElement } from 'lwc';

export default class ChildLwcComponent extends LightningElement {
    handleSubstract(){
        this.dispatchEvent(new CustomEvent('substract'));
    }

    handleAdd(){
        this.dispatchEvent(new CustomEvent('add'));
    }

    handleMultiply(event){
        const multiplyValue = event.target.value;
        this.dispatchEvent(new CustomEvent('multiplyvalue', {
            detail: multiplyValue
        }))
    }
    handleReset(){
        this.dispatchEvent(new CustomEvent('reset'));
    }
}