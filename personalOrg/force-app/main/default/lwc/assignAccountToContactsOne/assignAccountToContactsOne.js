import { LightningElement,track,api } from 'lwc';
import getRelatedContact from '@salesforce/apex/AssignAccount.getRelatedContact';
import assignAccount from '@salesforce/apex/AssignAccount.assignAccount';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation'; 
const actions = [
    {label:'Assign', action:'assign'},
    {label: 'View', action:'view'},
];

const columns = [
    {label:'Contact Name', fieldName:'Name'},
    {lable:'Email Address', fieldName:'Email'},
    {
        type:'action',
        typeAttributes:{rowActions: actions},
    },
];
export default class AssignAccountToContactsOne extends NavigationMixin(LightningElement) {
    @track isVisible = false;
    @api recordId;
    @track showContact = 'Show Contacts';
    @track data = [];
    @track accountData = [];
    @track columns = columns;
    error;
    connectedCallback(){
        //get contact list from apex
        //this.recordId = '0015g00001E9QAMAA3';
        console.log('recordId: '+this.recordId);
        getRelatedContact({accountId: this.recordId})
        .then(response => {
            this.data = response;
        })
        .catch(error => {
            this.error = error;
        })
    }
    handleClick(event){
        const label = event.target.label;
        if(label === 'Show Contacts'){
            this.isVisible =true;
            this.showContact = 'Hide Contacts';
        }else if(label === 'Hide Contacts'){
            this.isVisible = false;
            this.showContact = 'Show Contacts';
        }
    }
    handleRowActionFunction(event){
        const actionName = event.detail.action.label;
        const row = event.detail.row;
        alert('rowAction: '+actionName);
        switch(actionName){
            case 'Assign':
                this.assignAccount(row);
                break;
            case 'View':
                this.navigateToAccount(row);
                break;
            default:
        }
    }

    assignAccount(currentRow){
        const selectedRow = currentRow;
        console.log('selectedRow: '+selectedRow);
        console.log('selected row ID: '+ selectedRow.AccountId);
        //call apex to assign account to related contact list 
        assignAccount({accountId: selectedRow.AccountId, contactId: selectedRow.Id})
        .then(result => {
            this.accountData = result;
            console.log('result from asign account: '+ JSON.stringify(result));
        })
        .catch(err => {
            this.error = err;
        })

        this.ShowToastEvent();
        window.location.reload; //for refresh page 
    }

    ShowToastEvent(){
        const event = new ShowToastEvent({
            label: 'Record Updated Suc:',
            message: 'Account Get updated Successfully',
            variant:'Success',
            mode:'dissmissable'
        })
        this.dispatchEvent(event);
    }
    //account record page navigation
    navigateToAccount(rowData){
        alert('in navigate account page ');
        const selectedRow = rowData;
        console.log('selectedRow: '+selectedRow);
        console.log('selected row ID: '+ selectedRow.Id);
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId : selectedRow.Id,
                objectApiName:'Contact',
                actionName : 'view',
            } 
        });

        //reference 
          // View a custom object record.
        //   this[NavigationMixin.Navigate]({
        //     type: 'standard__recordPage',
        //     attributes: {
        //         recordId: 'a03B0000002tEurIAE',
        //         objectApiName: 'namespace__ObjectName', // objectApiName is optional
        //         actionName: 'view'
        //     }
        // });
    }
}