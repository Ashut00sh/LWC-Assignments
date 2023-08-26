import { LightningElement, api } from 'lwc';
import updatAccRecord from '@salesforce/apex/CraeateRecord.updatAccRecord'
export default class UpdateRecWithApex extends LightningElement {
    @api recordId;
    accountname;
    accountnumber;
    website;
    handelNameChange(event){
        this.accountname = event.target.value;
        console.log('accountname: '+this.accountname);
    }

    handelNumberChange(event){
        this.accountnumber = event.target.value;
        console.log('accountnumber: '+this.accountnumber);
    }

    handelWebsiteChange(event){
        this.website = event.target.value;
        console.log('website: '+this.website);
    }

    updateAccRec(){
        updatAccRecord({accountId : this.recordId, accName :  this.accountname, accNum : this.accountnumber, accWebsite : this.accWebsite})
        .then(response => {
            console.log('response: '+ JSON.stringify(response));
        })
    }
}