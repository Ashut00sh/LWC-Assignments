import { LightningElement,track,api } from 'lwc';
import getRecordsData from '@salesforce/apex/ObjectController.getRecordsData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class RecordsConfiguration  extends NavigationMixin(LightningElement) {

    @track objectName;
    @track selectedFields;
    @track reocordsData;
    @track columns = [];
    @track isShowRecords = false;
    @track  actions = [
        { label: 'Edit', name: 'Edit' },
        { label: 'Delete', name: 'delete' },
    ];

    @api async handleRecords(objectName,selectedFields){
           this.objectName = objectName;
           this.selectedFields  = selectedFields;
           this.handleDynamicColumns();
           await this.getRecords();
    }

renderCallback(){
    console.log('RUshiii');
}

    handleDynamicColumns(){
        this.columns = [];
        this.selectedFields.forEach(field => {
            const column = {
                label: field, 
                fieldName: field,
                type : 'text' 
            }
            this.columns = [...this.columns , column];
        });

        this.columns = this.columns.concat( {
            type: 'action',
            typeAttributes: { rowActions: this.actions },
        },)
    }

    //used to get records of object.
    getRecords(){
        return new Promise((resolve, reject) => {
            getRecordsData({ selectedObject : this.objectName, selectedFields : this.selectedFields})
              .then(result => {
                   this.reocordsData = result;
                   this.isShowRecords = true;
                   resolve(result);
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

      handleRowAction(event){
        if(event.detail.action.label == 'Edit'){
            const config = {
                type: "standard__recordPage",
                attributes: {
                  recordId: event.detail.row.Id,
                  objectApiName: this.objectName,
                  actionName: "edit"
                }
              };
              this[NavigationMixin.Navigate](config);
        }else{
            const evt = new ShowToastEvent({
                title: 'Warning',
                message: 'You have to write logic for this.',
                variant: 'warning',
                mode: 'dismissable'
              });
              this.dispatchEvent(evt);
        }
      }
    

}