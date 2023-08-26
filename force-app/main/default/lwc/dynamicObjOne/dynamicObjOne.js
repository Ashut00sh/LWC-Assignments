import { LightningElement, track } from 'lwc';
import getAllObjectsNames from '@salesforce/apex/ObjectData.getAllObjectsNames'
import { NavigationMixin } from 'lightning/navigation';

export default class DynamicObjOne extends NavigationMixin(LightningElement) {
    @track selectOptions = [];
    selectedObject = '';
    connectedCallback(){
        this.getAllObjects();
    }

    getAllObjects(){
        getAllObjectsNames()
        .then(result => {
           // console.log('result:: ',JSON.stringify(result));
            result.forEach(element => {
                let option = {
                    label : element,
                    value : element
                };
                this.selectOptions = [...this.selectOptions, option];
            });
            //this.selectOptions = JSON.stringify(result);
        })
        .catch(error => {
            console.log('Error: '+error);
        })
    
    }
    handleObjectChange(event){
        this.selectedObject = event.target.value;
        if (this.selectedObject != undefined &&  this.selectedObject != ''){
            console.log('selectedObjeName:: '+this.selectedObject);
            this.template.querySelector("c-dynamic-obj-two").handleFields(this.selectedObject);
        }
    }
}