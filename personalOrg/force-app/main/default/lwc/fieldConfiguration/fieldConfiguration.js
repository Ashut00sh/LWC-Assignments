import { LightningElement ,track ,api} from 'lwc';
import getFields from '@salesforce/apex/ObjectController.getFields';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FieldConfiguration extends LightningElement {

    @track options = [];
    @track value;
    @track objectName;
    @track isShowFields = false;
    @track selectedFields;


    @api async handleFields(objectName){
        this.selectedFields = [];
        this.options = [];
        this.isShowFields = false;
        this.objectName = objectName;
        await this.getFieldsOfObject();
    }

  //used to get all fields from from specific object.
  getFieldsOfObject(){
    return new Promise((resolve, reject) => {
        getFields({selectedObject : this.objectName})
          .then(result => {
            result.forEach(element => {
                let option = {
                    label : element,
                    value : element
                };
                this.options = [...this.options, option];
                this.isShowFields = true;
            });
          })
          .catch(error => {
            reject(null);
              this.dispatchEvent(new ShowToastEvent({
                  title: 'Error',
                  message: error.body.message,
              variant: 'error'}));
          window.console.log("error ===> " + JSON.stringify(error));
          })
      });     
  }

  handleFieldSelection(event){
      this.selectedFields  = [];
      this.selectedFields  = event.target.value;
  }

  handleGetRecords(){
    if(this.selectedFields != undefined && this.selectedFields != ''){
        this.template.querySelector("c-records-configuration").handleRecords(this.objectName,this.selectedFields);
    }else{
      const evt = new ShowToastEvent({
        title: 'Warning',
        message: 'Please select atleast one fields.',
        variant: 'warning',
        mode: 'dismissable'
      });
      this.dispatchEvent(evt);
    }
  }
}