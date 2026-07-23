# Employee Leave Management System (Salesforce)

A Salesforce app that lets employees submit leave requests, with automated
balance tracking and manager approval.

## Features
- Custom objects: Leave_Request__c, Leave_Balance__c
- Validation Rule preventing invalid date ranges
- Record-Triggered Flow for approval email notifications
- Apex trigger (handler pattern) that deducts approved leave from balance,
  fully bulkified and covered by unit tests
- Lightning Web Component for employees to submit requests and view balance
  in real time
- Reports and Dashboard for visibility into request status

## Tech used
Apex, Lightning Web Components, Flow, SOQL, Salesforce CLI

## What I learned
Bulkification and governor limits, trigger context variables, the
difference between @wire and imperative Apex calls in LWC, and
Salesforce's "clicks before code" philosophy for deciding between
declarative and programmatic solutions.