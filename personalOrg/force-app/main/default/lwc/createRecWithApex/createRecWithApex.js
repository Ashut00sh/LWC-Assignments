import { LightningElement } from 'lwc';
import insertAccountRecords from '@salesforce/apex/CraeateRecord.insertAccountRecords'
import { NavigationMixin } from 'lightning/navigation';
export default class CreateRecWithApex extends NavigationMixin(LightningElement) {
    accId;
    accountName;
    accountNumber;
    showViewButton = false;
    handleAccNameChange(event){
        this.accountName = event.target.value;
    }

    handleAccNumChange(event){
        this.accountNumber = event.target.value;
    }
    viewAccRecord(){
         // method to redirect to record page 
         this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.accId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }
    onCreateAcc(){
        //method to call apex
        insertAccountRecords({accName: this.accountName, accNum : this.accountNumber })
        .then(response =>{
            this.accId = response[0].Id;
            this.showViewButton = true;
            console.log('accId: '+this.accId);
            console.log('response: '+JSON.stringify(response));
        })
        .catch(error => {
            console.log('Error Occured: '+JSON.stringify(error));
        })

       
    }
}