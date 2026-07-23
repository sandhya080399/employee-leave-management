public with sharing class LeaveRequestController {

    @AuraEnabled(cacheable=true)
    public static Leave_Balance__c getMyBalance() {
        return [
            SELECT Total_Days__c, Days_Used__c, Days_Remaining__c
            FROM Leave_Balance__c
            WHERE Employee__c = :UserInfo.getUserId()
            LIMIT 1
        ];
    }

    @AuraEnabled
    public static void submitLeaveRequest(Date startDate, Date endDate, String reason) {
        Leave_Request__c lr = new Leave_Request__c(
            Employee__c = UserInfo.getUserId(),
            Start_Date__c = startDate,
            End_Date__c = endDate,
            Reason__c = reason,
            Status__c = 'Pending'
        );
        insert lr;
    }
}