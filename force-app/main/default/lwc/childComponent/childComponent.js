import { LightningElement, api } from 'lwc';

export default class ChildComponent extends LightningElement {
    @api strName = 'str Name from child component';
    @api changeStrNameFun(){
        this.strName = 'The the strName from child compo function:) ';
    }
}