import { LightningElement, api, track } from 'lwc';
import getRelatedRec from '@salesforce/apex/accountRelatedRec.getRelatedRec';

//opportunity columns
const oppcolumn =[
    {label:'Oppo Id', fieldName:'Id'},
    {label:'Oppo Name', fieldName:'Name'}
]
//contact columns
const conColumn =[
    {label:'Contact Id', fieldName:'Id'},
    {label:'Contact Name', fieldName:'Name'},
    {label:'Email',fieldName:'Email'}
]

export default class AccountRelatedChildRec extends LightningElement {
    @api buttonLabel = 'Show';
    opportunityData = [];
    contactData = [];
    oppcolumn = oppcolumn;
    conColumn = conColumn;
    @api recordId;
    @api showDataTable = false;

    onButtonClick(event){
        if(event.target.label === 'Show'){
            this.showDataTable = true;
            this.buttonLabel = 'Hide';
        }else if(event.target.label === 'Hide'){
            this.showDataTable = false;
            this.buttonLabel = 'Show';
        }
        console.log('show2: '+this.showDataTable);
    }

    connectedCallback(){
        //call apex method to get the related records
        console.log('recordId123: '+this.recordId);
        getRelatedRec({accId : this.recordId})
        .then(result => {
            let tempRec = result;
            console.log('tempRec: '+JSON.stringify(tempRec));
            let temp = tempRec.map(row => {
                return Object.assign({
                    oppName : row.Opportunities,
                    contactObj : row.Contacts
                })
            })
            console.log('temp: '+JSON.stringify(temp));
            //store opportunities and contact in different array
            temp.forEach(element => {
                //store the oppportunity data 
                this.opportunityData = element.oppName;
                console.log('oppData: '+JSON.stringify(this.opportunityData));
                //store the contact data
                this.contactData = element.contactObj;
                console.log('contactData: '+JSON.stringify(this.contactData));
            });
        })
        .catch(error => {
            console.log('error: '+JSON.stringify(error));
        })
    }
}