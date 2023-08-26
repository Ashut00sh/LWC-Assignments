import { LightningElement,track } from 'lwc';
import getAccount from '@salesforce/apex/ComboBox.getAccount';
export default class ComboBox extends LightningElement {
    @track value = '';
    @track accOption = [];
    get options(){
        return this.accOption;
    }
    handleChange(event){
        this.value = event.detail.value;
    }
    connectedCallback(){
        getAccount()
        .then(result => {
            let arr = [];
            for(var i=0; i<result.length; i++){
                arr.push({ label : result[i].Name, value : result[i].Id})
            }
            this.accOption = arr;
        })
    }
}