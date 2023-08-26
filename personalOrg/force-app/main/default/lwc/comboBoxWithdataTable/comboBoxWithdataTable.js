import { LightningElement, track } from 'lwc';
import getAccounts from '@salesforce/apex/ComboBoxWithDataTable.getAccounts'
import getContactRec from '@salesforce/apex/ComboBoxWithDataTable.getContactRec'
const columns = [
    {label : 'Contact Name',fieldName:'Name'},
    {label: 'Contact Email', fieldName:'Email'},
]
export default class ComboBoxWithdataTable extends LightningElement {
    @track value = '';
    @track optionArray = [];
    @track data = [];
    @track columns = columns;
    cardVisibility = false;
    get option(){
        return this.optionArray;
    }
    connectedCallback(){
        getAccounts()
        .then( Response =>{
            console.log('res: '+JSON.stringify(Response));
            let arr = [];
            for(var i=0; i<Response.length; i++){
                arr.push({ label : Response[i].Name, value : Response[i].Id})
            }

            this.optionArray = arr;
            console.log('optionArr: '+ JSON.stringify(this.optionArray));
        })
    }
    handleChange(event){
        this.cardVisibility = true;
        this.value = event.detail.value;
        //call apex to get realted contact
        getContactRec({AccountId: this.value})
        .then(result =>{
            this.data = result;
        })
        .catch(error=> {
            window.alert('Error Occured: '+error);
        })
    }
}