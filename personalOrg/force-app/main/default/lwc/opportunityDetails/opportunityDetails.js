import { LightningElement, wire,track } from 'lwc';
import getOpportunitiesByWeek from '@salesforce/apex/OpportunityController.getOpportunitiesByWeek';

const COLUMNS = [
    {
        label: 'Opportunity Id',
        fieldName: 'Id',
        type: 'url',
        typeAttributes: { label: { fieldName: 'Id' }, target: '_blank' }
    },
    { label: 'Opportunity Name', fieldName: 'Name', type: 'text' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency' },
    { label: 'Close Date', fieldName: 'CloseDate', type: 'date' }
];

export default class OpportunityDetails extends LightningElement {
    columns = COLUMNS;
    @track opportunityMap = [];
    @wire(getOpportunitiesByWeek)
    wiredOpportunityMap({ error, data }) {
        if (data) {
            console.log('Data',JSON.stringify(data));
            for (var key in data) {
                console.log('dataKey:: '+JSON.stringify(data[key]));
                console.log('dataKey:: '+JSON.stringify(data[key].length));
                for (let i = 0; i < data[key].length; i++) {
                    let oppId = data[key][i].Id;
                    console.log('oppId:: '+oppId);
                    oppId = '/' + data[key][i].Id;
                  }
                
                // const opportunitiesList = Object.values(data);
                // this.opportunitiesList = data.map(opportunity => ({
                //     ...opportunity,
                //     Id: `/${opportunity.Id}`
                // }));
                //dsconsole.log('opplist:: '+this.opportunitiesList);
                //this.opportunityMap.push({ key: key, value:oppId});
                //data[key][0].Id = oppId;
                //let oppObj = Object.asssign({}, data);
                //console.log('oppObj:: '+oppObj);
                //data[key][0].Name = '/' + data[key][0].Id;
                //data[key][0].Id = `/${data[key][0].Id}`;
                //this.opportunityMap.push({key: key, value: this.opportunitiesList});
                
                this.opportunityMap.push({ key: key, value: data[key] });
                console.log('key', key, data[key]);
            }
            // const opportunitiesList = Object.values(data);
            // this.opportunityMap = opportunitiesList.reduce((acc, opportunities) => {
            //     return acc.concat(opportunities.map(opportunity => ({
            //         ...opportunity,
            //         Id: `/${opportunity.Id}`
            //     })));
            // }, []);
        }else if (error) {
            console.error(error);
        }
    }
}
