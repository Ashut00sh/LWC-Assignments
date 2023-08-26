import { LightningElement,api, track } from 'lwc';
import getRecordsData from '@salesforce/apex/ObjectData.getRecordsData';
import Phone from '@salesforce/schema/Account.Phone';

export default class DynamicObjeThree extends LightningElement {
    @track objName = '';
    @track selectedFields = [];
    @track  actions = [
        { label: 'Edit', name: 'Edit' },
        { label: 'Delete', name: 'delete' },
    ];
    @track reocordsData;

    @api handleRecords(fields, objectName){
        this.selectedFields = fields;
        this.objName = objectName;
        this.getRecordsOfSelectedFields();
    }
    getRecordsOfSelectedFields(){
        getRecordsData({selectedObject : this.objName ,selectedFields : this.selectedFields})
        .then(result => {
            this.columns = [];
            this.selectedFields.forEach(field => {
                console.log('filed123:: '+field);
                const column = {
                    label: field, 
                    fieldName: field,
                    type : 'text'
                }
                if(field != undefined && field == Phone){
                    console.log('PhoneField Value :: '+field);
                    this.column = {
                        label: field, 
                        fieldName: field,
                        type : 'text',
                        cellAttributes:{
                            class:{
                                fieldName:'color'
                            }
                        }, 
                    }
                }
                this.columns = [...this.columns , column];
            });
    
            this.columns = this.columns.concat( {
                type: 'action',
                typeAttributes: { rowActions: this.actions },
            },)

            this.reocordsData = result;
            this.reocordsData.forEach(element => {
                console.log('element: '+JSON.stringify(element));
                // if(element.Phone !=)
                console.log('Phone is'+element.Phone);
                //&& element.Phone.includes('+')
                if(element.Phone != undefined ){
                   return {...element,   
                        "color":"slds-text-color_success",
                         "color":"datatable-orange"
                    }
                }
            });
            console.log('Dsd',JSON.stringify(this.reocordsData));
        })
        .catch(error => {
            console.log('Error: '+error);
        })
    }
   
}