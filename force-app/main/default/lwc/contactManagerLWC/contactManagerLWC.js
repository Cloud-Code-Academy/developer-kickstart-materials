import { LightningElement, track, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import saveContact from '@salesforce/apex/ContactController.saveContact';

export default class ContactManager extends LightningElement {
    @track contact = {};
    @track contacts = [];

    connectedCallback() {
        this.loadContacts();
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        this.contact[field] = event.target.value;
    }

    saveContact() {
        saveContact({ contact: this.contact })
            .then(() => {
                this.contact = {}; // Reset form
                this.loadContacts(); // Reload contacts
            })
            .catch(error => {
                console.error('Error saving contact:', error);
            });
    }

    loadContacts() {
        getContacts()
            .then(result => {
                this.contacts = result;
            })
            .catch(error => {
                console.error('Error fetching contacts:', error);
            });
    }
}
