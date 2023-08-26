import { LightningElement, track } from 'lwc';
import getAllObjects from '@salesforce/apex/ObjectData.getAllObjects';
import getAllFieldsOfObject from '@salesforce/apex/ObjectData.getAllFieldsOfObject';
import getRecordsOfSelectedFields from '@salesforce/apex/ObjectData.getRecordsOfSelectedFields';
import { NavigationMixin } from 'lightning/navigation';


export default class DynamicObjectTab extends NavigationMixin(LightningElement) {
    @track Options = [];
    @track objectList = [];
    @track customObjectList = [];
    @track standardObjectList = [];
    @track allObjectList = [];
    @track fieldList = [];
    @track objectTypeList = [
        {label:'All', value:'all'},
        {label:'Custom', value:'custom'},
        {label:'Standard', value:'standard'},
    ];
    @track  actions = [
        { label: 'Edit', name: 'Edit' },
        { label: 'Delete', name: 'delete' },
    ];
    objectName = '';
    @track fieldsToDisplay = [];
    @track filterData;
    columns = [];
    showcolumns = [];
    recordsValue = '';
    selectedFields = [];
    visibleShowRecords = false;
    isShowRecords = false;
    isShowFields = false;
    connectedCallback(){
        //call apex method to get all the object Names
        getAllObjects()
        .then(response =>{
            console.log('resp: '+JSON.stringify(response));
            //this.allObjectList = JSON.stringify(response);
            for(let key in response){
                if(key.endsWith('__c')){
                    this.customObjectList.push({ label: key, value: key});
                }else if(!key.endsWith('__c')){
                    this.standardObjectList.push({ label : key, value: key});
                }
                this.allObjectList.push({ label: key, value: key})
            }
            console.log('allObjeList: '+ JSON.stringify(this.allObjectList));
        })
        .catch(error =>{
            console.log('Error Occured: '+ error);
        })

    }
    // show the object names according to there type
    handleChange(event){
        this.fieldList = [];
        this.visibleShowRecords = false;
        this.isShowRecords = false;
        this.isShowFields = false;
        console.log('event value: '+event.target.value);
        if(event.target.value == 'all'){
            this.objectList = this.allObjectList;
        }else if(event.target.value == 'custom'){
            this.objectList = this.customObjectList;
        }else if(event.target.value == 'standard'){
            this.objectList = this.standardObjectList;
        }
        console.log('objeclitst: '+ JSON.stringify(this.objectList));
    }
    // when object is selected
    onObjectChange(event){
        this.isShowFields = true;
        console.log('objName: '+event.target.value);
        this.objectName = event.target.value;
        console.log('objname1: '+ this.objectName);
        this.fieldList = [];
        // call apex method to get realted fields of that object
        getAllFieldsOfObject({strObjectName : this.objectName})
        .then(response =>{
            console.log('response: '+JSON.stringify(response));
            for(let key in response){
                this.fieldList.push({label : key, value: key});
            }
            console.log('fieldlist: '+JSON.stringify(this.fieldList));
        })
        .catch(error =>{
            console.log('Error Occured: '+error);
        })
    }
    // get the all fileds selected from check box
    handleSelectedFields(event){
        this.recordsValue = event.target.value;
        this.selectedFields = event.target.value;
        this.visibleShowRecords = true;
    }
    // to show the all records for selected fields
    handleClick(){
        this.isShowRecords = true;
        // call apex method to get records while passing the object name and related fields

        getRecordsOfSelectedFields({fieldsName : JSON.stringify(this.recordsValue), objName : this.objectName})
        .then(result =>{
            this.columns =   this.selectedFields;
            this.columns = [];
            // for(let i=0; i<this.selectedFields.lenght; i++){
            //     if(field === 'Phone'){
            //         this.column.push({
            //             label:  this.selectedFields[i], 
            //             fieldName:  this.selectedFields[i],
            //             type : 'text',
            //             cellAttributes:{
            //                 class:{
            //                     fieldName:'color'
            //                 }
            //             },   
            //         })
            //     }else{
            //         this.column.push({
            //             label:  this.selectedFields[i], 
            //             fieldName:  this.selectedFields[i],
            //             type : 'text'
            //         })
            //     }
            // }
            this.selectedFields.forEach(field => {
            const column = {
                label: field, 
                fieldName: field,
                type : 'text',
                cellAttributes:{
                    class:{
                        fieldName:'color'
                    }
                }, 
            }
            this.columns = [...this.columns , column];
        });
            this.columns = this.columns.concat( {
                type: 'action',
                typeAttributes: { rowActions: this.actions }
               
            },)
            this.filterData = result;
            this.filterData.forEach(element => {
                console.log('element: '+JSON.stringify(element));
                console.log('Phone is'+element.Phone);
                if(element != null && element.Phone != undefined ){
                // return {...element,   
                //         "element.color":"slds-text-color_success",
                //     }
                // }
                element.color = 'slds-text-color_success';
                }
            });
            console.log('Dsd',JSON.stringify(this.filterData));
            
        })
        .catch(error =>{
            console.log('Error Occured: '+error);
        })
    }

    //Add row action
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
        }
    }
}