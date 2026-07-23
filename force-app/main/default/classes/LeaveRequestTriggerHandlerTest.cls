@isTest
private class LeaveRequestTriggerHandlerTest {

    @isTest
    static void testNumberOfDaysCalculatedOnInsert() {
        Leave_Request__c lr = new Leave_Request__c(
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(4)
        );

        Test.startTest();
        insert lr;
        Test.stopTest();

        Leave_Request__c result = [SELECT Number_of_Days__c FROM Leave_Request__c WHERE Id = :lr.Id];
        System.assertEquals(5, result.Number_of_Days__c, 'Expected 5 inclusive days');
    }

    @isTest
    static void testBalanceDeductedWhenApproved() {
        Leave_Balance__c bal = new Leave_Balance__c(
            Employee__c = UserInfo.getUserId(),
            Total_Days__c = 20,
            Days_Used__c = 0
        );
        insert bal;

        Leave_Request__c lr = new Leave_Request__c(
            Employee__c = UserInfo.getUserId(),
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(2),
            Status__c = 'Pending'
        );
        insert lr;

        lr.Status__c = 'Approved';
        Test.startTest();
        update lr;
        Test.stopTest();

        Leave_Balance__c updatedBal = [SELECT Days_Used__c FROM Leave_Balance__c WHERE Id = :bal.Id];
        System.assertEquals(3, updatedBal.Days_Used__c, 'Expected 3 days deducted from balance');
    }
}