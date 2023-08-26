import { LightningElement } from 'lwc';
import imageToUpload from '@salesforce/resourceUrl/imageToUpload';

export default class CarauselDemo extends LightningElement {
    source = imageToUpload +'/imageToUpload/h1.jpg';
}