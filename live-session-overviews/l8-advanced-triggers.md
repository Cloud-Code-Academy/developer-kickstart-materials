# Lesson 8 - Instructor Guide: Advanced Trigger Best Practices

## Lesson Summary

This lesson moves students beyond basic trigger syntax to explore **how to write scalable, maintainable, and testable trigger logic**. Students will learn why trigger frameworks are necessary, how to implement them, and how to avoid anti-patterns like putting business logic directly in trigger bodies. The session focuses on understanding **single-responsibility design, handler classes, and framework structure** with real-world demonstrations and hands-on practice.

---

**Files for Reference (do not copy/paste):**  
- `force-app\live-coding\module8\triggers\ContactTriggerBad.trigger` – Monolithic trigger demonstrating anti‑patterns such as logic in triggers, SOQL/DML in loops and lack of bulkification.  
- `force-app\live-coding\module8\triggers\ContactTriggerSimple.trigger` – Thin trigger that routes to a handler class following the single‑responsibility pattern.  
- `force-app\live-coding\module8\classes\TriggerAntiPatternDemo.cls` – Apex class used to discuss common trigger anti‑patterns.  
- `force-app\live-coding\module8\classes\SimpleTriggerHandler.cls` – Basic trigger handler showing how to separate business logic from the trigger.  
- `force-app\live-coding\module8\classes\TriggerFramework.cls` – Reusable trigger framework that provides a base class and recursion prevention.  
- `force-app\live-coding\module8\classes\AccountTriggerHandler.cls` – Concrete handler class built on the framework used in demonstration of best practices.  
- `force-app\live-coding\module8\classes\SimpleTriggerHandlerTest.cls` – Unit test class for the handler pattern that can be referenced when discussing testing strategies.  

## Learning Objectives

By the end of this lesson, students will be able to:

-   Explain the problems with unstructured triggers in large organizations
-   Describe the benefits of using a trigger framework
-   Implement a basic trigger framework with handler classes
-   Avoid logic in trigger bodies and adhere to single-responsibility principles
-   Write unit tests for trigger handlers
-   Apply bulkification principles within trigger frameworks

---

## Lesson Outline (90 minutes)

### 1. Welcome and Review (5 minutes)

-   Welcome students and set expectations for the advanced trigger session
-   Briefly revisit the core purposes of triggers:
    -   Enforce business rules that can't be handled by validation rules
    -   Automate behavior on record changes
    -   Maintain data integrity across related records
-   Ask students: "What challenges might arise as organizations scale with many triggers?"

### 2. The Problem: Unstructured Triggers (10 minutes)

-   **Demonstration (7 minutes)** - Show a monolithic trigger with logic directly in the body:

```apex
trigger ContactTrigger on Contact (before insert, before update, after insert) {
    // Before Insert Logic
    if (Trigger.isBefore && Trigger.isInsert) {
        for (Contact c : Trigger.new) {
            if (String.isBlank(c.FirstName)) {
                c.FirstName = 'Default';
            }
            if (String.isBlank(c.Email)) {
                c.Email = c.FirstName + '.' + c.LastName + '@company.com';
            }
        }
    }

    // Before Update Logic
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Contact c : Trigger.new) {
            Contact oldContact = Trigger.oldMap.get(c.Id);
            if (c.Email != oldContact.Email) {
                c.Email_Changed_Date__c = System.now();
            }
        }
    }

    // After Insert Logic
    if (Trigger.isAfter && Trigger.isInsert) {
        List<Task> tasksToCreate = new List<Task>();
        for (Contact c : Trigger.new) {
            tasksToCreate.add(new Task(
                Subject = 'Follow up with new contact',
                WhoId = c.Id,
                ActivityDate = System.today().addDays(7)
            ));
        }
        insert tasksToCreate;
    }
}
```

-   **Discussion (3 minutes)** - Identify problems with this approach:

    -   Hard to test individual pieces of logic
    -   Difficult to reuse logic across different triggers
    -   Easy to duplicate code when similar logic is needed elsewhere
    -   No separation of concerns
    -   Becomes unmaintainable as complexity grows

-   **Key Teaching Point:** Avoid putting business logic directly in the trigger itself

### 3. Solution: Trigger Handler Pattern (15 minutes)

-   **Concept Explanation (5 minutes)**

    -   Introduce the concept of a **Trigger Handler** class
    -   Explain the separation of concerns:
        -   Trigger file: only routes to appropriate handler methods
        -   Handler class: contains all business logic
    -   Benefits of this pattern

-   **Demonstration (10 minutes)** - Refactor the previous example using a handler pattern:

```apex
trigger ContactTrigger on Contact (before insert, before update, after insert) {
    ContactTriggerHandler handler = new ContactTriggerHandler();

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.beforeInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            handler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.afterInsert(Trigger.new);
        }
    }
}

public class ContactTriggerHandler {

    public void beforeInsert(List<Contact> newContacts) {
        setDefaultValues(newContacts);
        generateDefaultEmails(newContacts);
    }

    public void beforeUpdate(List<Contact> newContacts, Map<Id, Contact> oldContactMap) {
        trackEmailChanges(newContacts, oldContactMap);
    }

    public void afterInsert(List<Contact> newContacts) {
        createFollowUpTasks(newContacts);
    }

    private void setDefaultValues(List<Contact> contacts) {
        for (Contact c : contacts) {
            if (String.isBlank(c.FirstName)) {
                c.FirstName = 'Default';
            }
        }
    }

    private void generateDefaultEmails(List<Contact> contacts) {
        for (Contact c : contacts) {
            if (String.isBlank(c.Email)) {
                c.Email = c.FirstName + '.' + c.LastName + '@company.com';
            }
        }
    }

    private void trackEmailChanges(List<Contact> newContacts, Map<Id, Contact> oldContactMap) {
        for (Contact c : newContacts) {
            Contact oldContact = oldContactMap.get(c.Id);
            if (c.Email != oldContact.Email) {
                c.Email_Changed_Date__c = System.now();
            }
        }
    }

    private void createFollowUpTasks(List<Contact> contacts) {
        List<Task> tasksToCreate = new List<Task>();
        for (Contact c : contacts) {
            tasksToCreate.add(new Task(
                Subject = 'Follow up with new contact',
                WhoId = c.Id,
                ActivityDate = System.today().addDays(7)
            ));
        }
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
}
```

-   Walk through the improved structure and control flow
-   Highlight the benefits:
    -   Each method has a single responsibility
    -   Logic can be tested in isolation
    -   Code is more readable and maintainable
    -   Easy to debug specific functionality

### 4. Building a Reusable Framework (20 minutes)

-   **Concept Explanation (5 minutes)**

    -   Discuss the value of standardized trigger frameworks
    -   Mention common open-source patterns (Kevin Poorman, Nebula, FFLib)
    -   Introduce the concept of a base handler class

-   **Demonstration (15 minutes)** - Create a reusable trigger framework:

```apex
public abstract class TriggerHandler {

    // Override these methods in your specific handlers
    public virtual void beforeInsert(List<SObject> newList) {}
    public virtual void beforeUpdate(List<SObject> newList, Map<Id, SObject> oldMap) {}
    public virtual void beforeDelete(Map<Id, SObject> oldMap) {}
    public virtual void afterInsert(List<SObject> newList) {}
    public virtual void afterUpdate(List<SObject> newList, Map<Id, SObject> oldMap) {}
    public virtual void afterDelete(Map<Id, SObject> oldMap) {}
    public virtual void afterUndelete(List<SObject> newList) {}

    // Main execution method
    public void execute() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) beforeInsert(Trigger.new);
            if (Trigger.isUpdate) beforeUpdate(Trigger.new, Trigger.oldMap);
            if (Trigger.isDelete) beforeDelete(Trigger.oldMap);
        }

        if (Trigger.isAfter) {
            if (Trigger.isInsert) afterInsert(Trigger.new);
            if (Trigger.isUpdate) afterUpdate(Trigger.new, Trigger.oldMap);
            if (Trigger.isDelete) afterDelete(Trigger.oldMap);
            if (Trigger.isUndelete) afterUndelete(Trigger.new);
        }
    }
}
```

-   Implement a specific handler using the framework:

```apex
public class AccountTriggerHandler extends TriggerHandler {

    public override void beforeInsert(List<SObject> newList) {
        List<Account> accounts = (List<Account>) newList;
        setDefaultValues(accounts);
    }

    public override void beforeUpdate(List<SObject> newList, Map<Id, SObject> oldMap) {
        List<Account> accounts = (List<Account>) newList;
        Map<Id, Account> oldAccountMap = (Map<Id, Account>) oldMap;
        validateBusinessRules(accounts, oldAccountMap);
    }

    private void setDefaultValues(List<Account> accounts) {
        for (Account acc : accounts) {
            if (String.isBlank(acc.Description)) {
                acc.Description = 'Account created on ' + System.today();
            }
        }
    }

    private void validateBusinessRules(List<Account> accounts, Map<Id, Account> oldAccountMap) {
        for (Account acc : accounts) {
            Account oldAccount = oldAccountMap.get(acc.Id);
            // Add validation logic here
        }
    }
}
```

-   Show the simplified trigger implementation:

```apex
trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    new AccountTriggerHandler().execute();
}
```

### 5. Unit Testing Trigger Handlers (15 minutes)

-   **Concept Explanation (3 minutes)**

    -   Explain how the handler pattern simplifies testing
    -   Discuss testing strategies for trigger logic

-   **Demonstration (12 minutes)** - Create comprehensive test classes:

```apex
@isTest
public class ContactTriggerHandlerTest {

    @testSetup
    static void setupTestData() {
        // Create test data that will be used across multiple test methods
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            testContacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact' + i
            ));
        }
        insert testContacts;
    }

    @isTest
    static void testBeforeInsert_SetsDefaultValues() {
        Test.startTest();

        // Create contacts without FirstName to test default value setting
        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(LastName = 'TestNoFirstName'));

        insert testContacts;

        Test.stopTest();

        // Verify default values were set
        Contact result = [SELECT FirstName FROM Contact WHERE LastName = 'TestNoFirstName'];
        Assert.areEqual('Default', result.FirstName, 'Default FirstName should be set');
    }

    @isTest
    static void testBeforeInsert_GeneratesEmails() {
        Test.startTest();

        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe'
        );
        insert testContact;

        Test.stopTest();

        Contact result = [SELECT Email FROM Contact WHERE Id = :testContact.Id];
        Assert.areEqual('John.Doe@company.com', result.Email, 'Email should be generated correctly');
    }

    @isTest
    static void testAfterInsert_CreatesFollowUpTasks() {
        Test.startTest();

        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Smith'
        );
        insert testContact;

        Test.stopTest();

        List<Task> createdTasks = [SELECT Subject, WhoId FROM Task WHERE WhoId = :testContact.Id];
        Assert.areEqual(1, createdTasks.size(), 'One follow-up task should be created');
        Assert.areEqual('Follow up with new contact', createdTasks[0].Subject, 'Task subject should match expected value');
    }

    @isTest
    static void testBulkInsert_HandlesMultipleRecords() {
        Test.startTest();

        List<Contact> bulkContacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            bulkContacts.add(new Contact(
                FirstName = 'Bulk',
                LastName = 'Contact' + i
            ));
        }

        insert bulkContacts;

        Test.stopTest();

        List<Task> createdTasks = [SELECT Id FROM Task WHERE Subject = 'Follow up with new contact'];
        Assert.areEqual(200, createdTasks.size(), 'Tasks should be created for all contacts');
    }
}
```

-   Key testing principles to emphasize:
    -   Always use `Test.startTest()` and `Test.stopTest()`
    -   Test both single record and bulk operations
    -   Use descriptive test method names
    -   Include meaningful assertion messages
    -   Test edge cases and error conditions

### 6. Best Practices and Common Pitfalls (10 minutes)

-   **Best Practices:**

    -   Avoid DML or SOQL inside loops (re-emphasized from earlier lessons)
    -   Use bulkification patterns in all trigger logic
    -   Implement proper error handling
    -   Keep methods focused on single responsibilities
    -   Use meaningful method and variable names

-   **Common Pitfalls to Avoid:**

    -   Putting complex business logic directly in triggers
    -   Not handling bulk operations properly
    -   Creating recursive trigger scenarios without proper guards
    -   Ignoring governor limits in trigger context
    -   Not testing trigger logic thoroughly

-   **Framework Considerations:**
    -   Consider using static variables to prevent recursive execution
    -   Implement proper logging for debugging
    -   Plan for future extensibility
    -   Document your framework patterns for team consistency

### 7. Student Practice Activity (10 minutes)

**Activity: Refactor a Monolithic Trigger**

Provide students with a poorly structured trigger and have them:

1. Identify the different pieces of business logic
2. Create a handler class with appropriate methods
3. Refactor the trigger to use the handler pattern
4. Write at least one test method for their handler

**Sample Trigger for Refactoring:**

```apex
trigger OpportunityTrigger on Opportunity (before update, after update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Opportunity opp : Trigger.new) {
            if (opp.StageName == 'Closed Won' && opp.Amount == null) {
                opp.addError('Amount is required for Closed Won opportunities');
            }
        }
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Account> accountsToUpdate = new List<Account>();
        Set<Id> accountIds = new Set<Id>();

        for (Opportunity opp : Trigger.new) {
            if (opp.StageName == 'Closed Won' && Trigger.oldMap.get(opp.Id).StageName != 'Closed Won') {
                accountIds.add(opp.AccountId);
            }
        }

        for (Account acc : [SELECT Id, Description FROM Account WHERE Id IN :accountIds]) {
            acc.Description = 'Has closed deals';
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
```

### 8. Q&A and Wrap-up (5 minutes)

-   Address student questions about trigger frameworks
-   Preview upcoming lessons on asynchronous Apex
-   Provide resources for further learning about trigger best practices

---

## Instructor Tips

-   **Before Class Preparation:**

    -   Prepare examples of both good and bad trigger implementations
    -   Test all code examples in your org before class
    -   Have backup examples ready if live coding encounters issues
    -   Consider creating a simple trigger framework template for students

-   **During Demonstration:**

    -   Explain the reasoning behind each refactoring step
    -   Regularly check for understanding with quick questions
    -   Use debug logs to show trigger execution flow
    -   Highlight how the handler pattern improves code organization

-   **Common Student Challenges:**

    -   Understanding when to use different trigger events
    -   Grasping the concept of separation of concerns
    -   Writing effective test classes for trigger logic
    -   Implementing proper bulkification in trigger handlers

-   **Key Points to Emphasize:**
    -   Trigger frameworks are essential for maintainable code
    -   Single responsibility principle applies to trigger methods
    -   Testing becomes much easier with proper handler structure
    -   Bulkification is still critical within trigger frameworks
    -   Good trigger design prevents many common Salesforce development issues

---

## Real-world Applications

-   **Enterprise Scenarios:** Large organizations with multiple developers working on the same objects
-   **Integration Patterns:** Triggers that need to call external systems or perform complex data synchronization
-   **Compliance Requirements:** Audit trails and data validation that must be consistently applied
-   **Performance Optimization:** Handling high-volume data operations efficiently

---

### Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com
