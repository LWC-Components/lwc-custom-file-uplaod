/* eslint-disable no-console */
import { LightningElement, api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import uploadDocument from '@salesforce/apex/FileUploaderController.uploadDocument';
// eslint-disable-next-line no-unused-vars
import { RecordFieldDataType } from 'lightning/uiRecordApi';

export default class FileUploader extends LightningElement {
    // eslint-disable-next-line no-undef
    @api recordId;



    handleUpload(event) { 
        const file = event.target.files[0];
        let fileContents;
        let fileReader = new FileReader();
        let self = this;
        fileReader.onload = function () {
            fileContents = fileReader.result;
            const base64Mark = 'base64,';
            const dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadFile(file.name, fileContents );
            };
        fileReader.readAsDataURL(file);
    }

    uploadFile(file, fileContents) {   
        uploadDocument({ files: file, versionData: fileContents ,parent_id: this.recordId})
        .then(result => {
            console.log(result);
            //this.upLoaded = true;
            return refreshApex(this.wiredDocumentsResult);
        })
        .catch(error => {
            console.log(error);
        });
    }
}