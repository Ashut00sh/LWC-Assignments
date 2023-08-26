import { LightningElement, wire,track } from 'lwc';
import getOpportunityMap from '@salesforce/apex/OppDataController.getOpportunityMap';

const COLUMNS = [
    { label: 'Opportunity Id', fieldName: 'OppId', type: 'url', 
    typeAttributes: { label: { fieldName: 'Id' }, target: '_blank' }
    },
    { label: 'Opportunity Name', fieldName: 'Name', type: 'text' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency' },
    { label: 'Close Date', fieldName: 'CloseDate', type: 'date' }
];

export default class OpportunityDataTable extends LightningElement {
    opportunityMap = [];
    columns = COLUMNS;
    showAccount = 'show';
    @track isvisible = false;
    mapKeySet = [];
    oppIdsArray = [];
    renderedCallback(){
        console.log('in rendered callback::');
    }
    connectedCallback(){
        console.log(' in connected call back::');
    }

    disconnectedCallback(){
        console.log('in disconnected callback::');
    }
    errorCallback(){
        console.log('in error callback::');
    }
    @wire(getOpportunityMap)
    wiredOpportunityMap({ error, data }) {
        console.log('in wire method::');
        if (data) {
            const jsonObj=JSON.parse(data);
            console.log('jsonObj:: '+JSON.stringify(jsonObj));
            let jsonArray = [];
            for(let key of jsonObj){
                console.log('keys::! '+JSON.stringify(Object.keys(key)));
                jsonArray = key.opportunities;
                this.mapKeySet.push(key.week);
                console.log('mapkeys::'+JSON.stringify(this.mapKeySet));
                for (let i = 0; i < jsonArray.length; i++) {
                    jsonArray[i].OppId = '/'+jsonArray[i].Id;
                }
            }
            console.log('oppIdset:: '+JSON.stringify(this.oppIdsArray));
            console.log('jsonObj:: '+ JSON.stringify(jsonArray));
            this.opportunityMap = jsonObj;
            console.log('oppData:: '+JSON.stringify(this.opportunityMap));
        } else if (error) {
            console.error(error);
        }

    }
     //hide functionality
     handleClick(event){
        console.log('in hanldleclick');
        let label = event.target.label;
        let array = [];
        array = this.opportunityMap;
        this.opportunityMap = [];
        
        for(const oppData of array){
            console.log('oppdataweek:: '+JSON.stringify(oppData));
            console.log('oppdataweek:: '+JSON.stringify(oppData.isVisible));
            if(oppData.week == label && oppData.isVisible == false){
                console.log('In if');
                oppData.isvisible = true;
            }else  if(oppData.week == label && oppData.isVisible == true){
                console.log('In if');
                oppData.isvisible = false;
            }
            else{
                oppData.isvisible = false;
            }
           this.opportunityMap.push(oppData);
        }
    }

    
}