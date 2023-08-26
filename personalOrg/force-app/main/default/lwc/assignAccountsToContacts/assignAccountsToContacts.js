import { LightningElement,api,track } from 'lwc';
import getRelatedContact from '@salesforce/apex/AssignAccount.getRelatedContact';
import assignAccount from '@salesforce/apex/AssignAccount.assignAccount';

const action = [
    {label: 'Assign', name:'assign'},
    {label:'view', name:'view'},
];

const columns = [
    {label:'Name', fieldName:'Name'},
    {label:'Id', fieldName:'Id'},
    {
        type:'action',
        typeAttributes :{ rowActions : astions},
    },
];

export default class AssignAccountsToContacts extends LightningElement {
    @track showAccount = 'show Accounts';
    @track isvisible = false;
    @api recordId;
    @track data = [];
    @track accountdata = [];
    columns = columns;
    error;
    connectedCallback(){
        console.log('record id: '+this.recordId);
        //get contact records from apex
        getRelatedContact({accountId : this.recordId})
        .then( result => {
            this.data = result.data;
        })
        .catch(error => {
            this.error = error;
        })
    }
    //hide functionality
    handleClick(event){
        const label = event.target.label;
        if(label === 'show Accounts'){
            this.showAccount = 'hide Accounts';
            this.isvisible = true;
        }else{
            this.showAccount = 'show Accounts';
            this.isvisible = false;
        }
    }

    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'assign':
                this.assignAccount(row);
                break;
            case 'view':
                this.navigateToAccountRecordPage(row);
            default:
                break;
        }
    }
}