import { LightningElement ,track,api} from 'lwc';
import getObjList from '@salesforce/apex/ObjectController.getObjList';
import { NavigationMixin } from 'lightning/navigation';


export default class ObjectConfiguration extends NavigationMixin(LightningElement) {

  @track objectValue;
  @track options = [];
  @track objectName;
  @track showObjectFields = false;

  async connectedCallback(){
       await this.getAllObjects();
  }


  //used to get all objects from SF org.
  getAllObjects(){
    return new Promise((resolve, reject) => {
        getObjList()
          .then(result => {
            result.forEach(element => {
                let option = {
                    label : element,
                    value : element
                };
                this.options = [...this.options, option];
            });
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

  handleCreateNewRecord(){
    this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
          objectApiName: this.objectName,
          actionName: 'new'
      }
  });
  }

  async handleObjectChange(event){
        this.showObjectFields = false;
        this.objectName = event.target.value;
        if(this.objectName != '' || this.objectName != undefined){
            this.showObjectFields = true;
            this.template.querySelector("c-field-configuration").handleFields(this.objectName);
        }
    }

}