import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class LwcDemo extends LightningElement {
  // Auto-provided on Record Pages
  @api recordId;       // e.g., 001... when viewing an Account
  @api objectApiName;  // e.g., Account

  // Design-time props (configurable in App Builder)
  @api title = 'LWC Lesson (Lite)';
  @api defaultMode = 'view'; // 'view' | 'edit'
  @api layout = 'Compact';   // 'Compact' | 'Full'
  @api columns = 2;          // 1-4 columns

  // Local state
  formMode = 'view';

  // UI API: object metadata (label, record types, etc.)
  @wire(getObjectInfo, { objectApiName: '$objectApiName' })
  objectInfo;

  connectedCallback() {
    // initialize mode from design property
    this.formMode = (this.defaultMode || 'view').toLowerCase() === 'edit' ? 'edit' : 'view';
  }

  // Derived values for template
  get objectLabel() {
    return this.objectInfo?.data?.label || this.objectApiName || '';
  }

  get computedTitle() {
    return this.title || 'LWC Lesson (Lite)';
  }

  get layoutType() {
    // lightning-record-form expects 'Compact' or 'Full'
    const v = (this.layout || 'Compact').toLowerCase();
    return v === 'full' ? 'Full' : 'Compact';
  }

  get viewVariant() {
    return this.formMode === 'view' ? 'brand' : 'neutral';
  }
  get editVariant() {
    return this.formMode === 'edit' ? 'brand' : 'neutral';
  }

  // Event handlers
  switchToView = () => { this.formMode = 'view'; };
  switchToEdit = () => { this.formMode = 'edit'; };

  handleSubmit(event) {
    // Example: intercept submit if you want to validate
    // event.preventDefault();
    // const fields = event.detail.fields; // modify fields if needed
    // this.template.querySelector('lightning-record-form').submit(fields);
  }

  handleSuccess(event) {
    const recId = event.detail.id || this.recordId;
    this.formMode = 'view';
    this.dispatchEvent(new ShowToastEvent({
      title: 'Saved',
      message: `Record ${recId} was saved successfully`,
      variant: 'success'
    }));
  }

  handleError(event) {
    const msg = event.detail?.message || 'There was a problem saving the record.';
    this.dispatchEvent(new ShowToastEvent({
      title: 'Error',
      message: msg,
      variant: 'error'
    }));
  }
}