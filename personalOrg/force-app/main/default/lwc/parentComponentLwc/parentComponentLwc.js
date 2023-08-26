import { LightningElement } from 'lwc';

export default class ParentComponentLwc extends LightningElement {
    countValue = 0;
    handleDecrement(){
        if(this.countValue > 0)
        this.countValue--;
    }
    handleIncrement(){
        this.countValue++;
    }
    handleMulti(event){
        const multiplyingNum = event.detail;
        if(multiplyingNum === '2'){
            console.log('in 2');
            this.countValue *= 2;
        }else if(multiplyingNum === '4'){
            console.log('in 4');
            this.countValue /= 4;
        }
    }
    handleReset(){
        this.countValue = 0;
    }
}