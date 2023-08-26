import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class MetaTierPlatform extends LightningElement {
    @api strName = 'This is the child platform component';
    errorMessage = 'Success Message :)';
    devident = 10;
    divisor = 2;
    connectedCallback(){
        console.log('in connected callback');
        let result = this.divisionFunction(this.devident, this.divisor);
        alert('Final result arrow function:    '+ result);
    }
    //1 st function
    handleClick(){
        this.showToastFun(this.errorMessage);
    }
    // 2 function
    showToastFun(varError){
        const event = new ShowToastEvent({
            title : varError,
            message: 'This is the toast example',
            messageData: [
                'Salesforce',
                {
                    url: 'googlec.com',
                    label: 'here',
                },
            ],
            variant:'success',
        });
        this.dispatchEvent(event);
    }
    //Funstion 3
    divisionFunction = (divident, divisor) => {
        return (divident/divisor);
    }
}