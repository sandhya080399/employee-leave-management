import { LightningElement, wire } from 'lwc';
import getMyBalance from '@salesforce/apex/LeaveRequestController.getMyBalance';
import submitLeaveRequest from '@salesforce/apex/LeaveRequestController.submitLeaveRequest';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LeaveRequestForm extends LightningElement {
    startDate;
    endDate;
    reason;

    @wire(getMyBalance)
    balance;

    handleStartDateChange(event) {
        this.startDate = event.target.value;
    }
    handleEndDateChange(event) {
        this.endDate = event.target.value;
    }
    handleReasonChange(event) {
        this.reason = event.target.value;
    }

    handleSubmit() {
        submitLeaveRequest({ startDate: this.startDate, endDate: this.endDate, reason: this.reason })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({ title: 'Success', message: 'Leave request submitted', variant: 'success' })
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({ title: 'Error', message: error.body.message, variant: 'error' })
                );
            });
    }
}