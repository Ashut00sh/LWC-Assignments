import { LightningElement, api, track } from 'lwc';
import getFields from '@salesforce/apex/ObjectData.getFields';

export default class DynamicObjTwo extends LightningElement {
    @track objectName;
    @track options = [];
    @track selectedFields = [];
    @track isShowFields = false;
    @api handleFields(objName){
        this.isShowFields = true;
        this.objectName = objName;
        console.log('objeNAme:: '+this.objectName);
        this.getFieldsOfObject();
    }

    getFieldsOfObject(){
        console.log('22323');
        getFields({ selectedObject : this.objectName})
        .then(result => {
            console.log('result:: '+ JSON.stringify(result));
            result.forEach(element => {
                let option = {
                    label : element,
                    value : element
                }
                this.options = [...this.options, option];
            });
        })
        .catch(error => {
            console.log('Error: '+ error);
        })
    }

    handleFieldSelection(event){
        this.selectedFields = event.target.value;
    }

    handleGetRecords(){
        console.log('in handle get records');
        console.log('selected fields:: '+ this.selectedFields);
        console.log('objeNAme:: '+ this.objectName);
        if(this.selectedFields != '' && this.selectedFields != undefined){
            this.template.querySelector("c-dynamic-obje-three").handleRecords(this.selectedFields, this.objectName);
        }
    }
    
    
}