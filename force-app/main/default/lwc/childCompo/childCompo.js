import { LightningElement,api } from 'lwc';

export default class ChildCompo extends LightningElement {
    @api counter = 0;

    @api addMaxCounter(){
        this.counter += 100;
    }
}