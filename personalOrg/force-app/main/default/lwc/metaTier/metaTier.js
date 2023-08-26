import { LightningElement } from 'lwc';

export default class MetaTier extends LightningElement {
    isShowFields = true;
    columns = [
        {label:'Machine Name', value:'machineName'},
        {label:'Application Name', value:'applicationName'},
        {label:'Environ Type', value:'environmentTye'},
        {label:'oneZero Hosted', value:'onezerohosted'},
        {label:'External IP', value:'externalIp'},
        {label:'Plateform Services Level', value:'platformServiceLevel'},
    ];
}