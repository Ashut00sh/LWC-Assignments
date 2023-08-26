import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
import NAME_FIELD from '@salesforce/schema/Account.Name'
export default class CreateRectWithOutApex extends LightningElement {
    
    accId;
    name='';

    handleNameChange(event){
        this.name = event.target.value;
        console.log('name: '+ JSON.stringify(this.name));
    }

    handleCreateAcc(){
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.name;
        const recordInput = {apiName : ACCOUNT_OBJECT.objectApiName, fields};
        createRecord(recordInput)
        .then(response => {
            console.log('response: '+ JSON.stringify(response));
            this.accId = response.Id;
        })
    }
}