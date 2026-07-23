public with sharing class LeaveRequestTriggerHandler {

    public static void handleBeforeInsert(List<Leave_Request__c> newRequests) {
        for (Leave_Request__c lr : newRequests) {
            if (lr.Start_Date__c != null && lr.End_Date__c != null) {
                lr.Number_of_Days__c = lr.Start_Date__c.daysBetween(lr.End_Date__c) + 1;
            }
        }
    }

    public static void handleAfterUpdate(List<Leave_Request__c> newRequests, Map<Id, Leave_Request__c> oldMap) {
        Set<Id> employeeIds = new Set<Id>();
        List<Leave_Request__c> newlyApproved = new List<Leave_Request__c>();

        for (Leave_Request__c lr : newRequests) {
            Leave_Request__c oldLr = oldMap.get(lr.Id);
            if (lr.Status__c == 'Approved' && oldLr.Status__c != 'Approved') {
                newlyApproved.add(lr);
                employeeIds.add(lr.Employee__c);
            }
        }

        if (newlyApproved.isEmpty()) {
            return;
        }

        Map<Id, Leave_Balance__c> balanceByEmployee = new Map<Id, Leave_Balance__c>();
        for (Leave_Balance__c bal : [
            SELECT Id, Employee__c, Days_Used__c
            FROM Leave_Balance__c
            WHERE Employee__c IN :employeeIds
        ]) {
            balanceByEmployee.put(bal.Employee__c, bal);
        }

        List<Leave_Balance__c> balancesToUpdate = new List<Leave_Balance__c>();
        for (Leave_Request__c lr : newlyApproved) {
            Leave_Balance__c bal = balanceByEmployee.get(lr.Employee__c);
            if (bal != null) {
                bal.Days_Used__c += lr.Number_of_Days__c;
                balancesToUpdate.add(bal);
            }
        }

        if (!balancesToUpdate.isEmpty()) {
            update balancesToUpdate;
        }
    }
}