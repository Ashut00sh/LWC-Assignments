import { LightningElement, track } from 'lwc';

export default class ConditionalOperatorComp extends LightningElement {
    @track showLabel = 'show';
    @track cardVisi = false;
    showCard = 'Show and hide the card';
    handleClick(event){
        const label = event.target.label;
        if(label === 'show'){
            this.showLabel = 'hide';
            this.cardVisi = true;
        }else if(label === 'hide'){
            this.showLabel = 'show';
            this.cardVisi = false;
        }
    }
}