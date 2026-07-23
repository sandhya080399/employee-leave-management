trigger LeaveRequestTrigger on Leave_Request__c (before insert, after update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        LeaveRequestTriggerHandler.handleBeforeInsert(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        LeaveRequestTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}