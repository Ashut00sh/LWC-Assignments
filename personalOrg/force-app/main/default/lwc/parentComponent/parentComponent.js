import { LightningElement, track, wire} from 'lwc';
import getAccountRecords from '@salesforce/apex/WireDemoClass.getAccountRec'

export default class ParentComponent extends LightningElement {
    //array of object 
    columns = [
        {label:'Name',fieldName:'Name'},
        {label:'Record Id', fieldName:'Id'},
    ];
    @track columns = this.columns;
    @track data = [];
    @track fullName = {firstName:"", lastName:""};
    //function 1
    handleClick(){
        this.template.querySelector("c-child-component").changeStrNameFun();
    }
    //function 2
    handleChange(event){
        const field = event.target.name;
        //alert('Field: '+ field);
        if (field === 'firstNam') {
            this.fullName.firstName = event.target.value;
        }else if(field === 'lastNam'){
            this.fullName.lastName = event.target.value;
        }
    }
    //function 3
    @wire(getAccountRecords)
    accountRecord({data, error}){
        if(data){
            console.log('return data: '+ data);
            this.data = data;
        }else if(error){
            console.log('Error: '+error);
        }
    }

}