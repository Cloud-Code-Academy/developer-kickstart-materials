# Live Coding Workshop: Asynchronous Apex

## Instructor Guide

### Workshop Overview

This 90-minute workshop introduces students to Asynchronous Apex in Salesforce, covering the four main types: Future Methods, Batch Apex, Queueable Apex, and Scheduled Apex. Students will learn when and why to use asynchronous processing and gain hands-on experience implementing each type.

### Learning Objectives

By the end of this session, students will be able to:

-   Explain the differences between synchronous and asynchronous processing
-   Identify appropriate use cases for each type of asynchronous Apex
-   Implement future methods with proper annotations
-   Create batch Apex classes with start, execute, and finish methods
-   Develop queueable Apex classes with job chaining
-   Schedule Apex jobs using both code and the Salesforce UI

### Session Outline (90 minutes)

#### 1. Welcome and Introduction (5 minutes)

-   Welcome students and set expectations for the session
-   Briefly review previous concepts that relate to asynchronous processing
-   Outline the four types of asynchronous Apex to be covered

#### 2. Asynchronous Apex Overview (10 minutes)

-   Define synchronous vs. asynchronous processing
-   Explain benefits of asynchronous processing:
    -   Separate governor limits
    -   Higher limits for certain operations
    -   Ability to handle larger data volumes
    -   Background processing
-   Discuss limitations:
    -   Delayed execution
    -   More complex error handling
    -   Monitoring challenges

#### 3. Future Methods (15 minutes)

-   **Concept Explanation (5 minutes)**
    -   Explain `@future` annotation and its purpose
    -   Cover restrictions: cannot accept sObjects or non-primitive data types
    -   Highlight common use cases: web service callouts, mixed DML operations
    -   Review governor limits: 250,000 invocations in 24 hours or 200 × licenses
-   **Demonstration (10 minutes)** - Live code a future method to address mixed DML scenario - Show proper syntax for `@future(callout=true)` annotation - Execute the code and review logs to show asynchronous execution - Highlight error cases to watch for

```apex
public class FutureExample {
    // Standard future method
    @future
    public static void processSomethingLater(String recordId) {
        // Code that runs asynchronously
        System.debug('Processing record: ' + recordId);
    }

    // Future method for callouts
    @future(callout=true)
    public static void makeCalloutLater(String endpoint, String payload) {
        // Make HTTP callout
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setBody(payload);
        // Complete callout code here
    }
}
```

#### 4. Batch Apex (20 minutes)

-   **Concept Explanation (5 minutes)**

    -   Explain `Database.Batchable` interface
    -   Cover the three required methods: start, execute, finish
    -   Discuss batch size considerations (default 200, max 200)
    -   Highlight use cases for large data volumes (50,000+ records)

-   **Demonstration (15 minutes)** - Live code a batch class to process inactive contacts - Implement all three required methods - Show how to execute the batch from Anonymous Apex - Demonstrate monitoring batch jobs in Setup > Apex Jobs - Discuss batch size optimization strategies

```apex
public class SimpleAccountBatch implements Database.Batchable<SObject> {

    // Start method - define records to process
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name FROM Account WHERE LastModifiedDate < LAST_N_DAYS:90');
    }

    // Execute method - process each batch
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        for(Account acc : scope) {
            acc.Description = 'Updated by batch on ' + System.today();
        }
        update scope;
    }

    // Finish method - post-processing
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch job completed!');
    }
}

// Execute with: Database.executeBatch(new SimpleAccountBatch(), 200);
```

#### 5. Queueable Apex (20 minutes)

-   **Concept Explanation (5 minutes)**

    -   Explain `Queueable` interface
    -   Compare to Batch Apex and Future methods
    -   Highlight key benefits: job chaining, complex data structures
    -   Discuss appropriate use cases for smaller, sequential operations

-   **Demonstration (15 minutes)** - Live code a queueable class to process records sequentially - Implement job chaining with `System.enqueueJob` - Show how to limit chain depth to avoid hitting limits - Execute and monitor the queueable job

```apex
public class SimpleQueueable implements Queueable {

    private List<Account> accounts;

    // Constructor accepts data to process
    public SimpleQueueable(List<Account> accts) {
        this.accounts = accts;
    }

    // Execute method runs when job processes
    public void execute(QueueableContext context) {
        for(Account acc : accounts) {
            acc.Description = 'Processed by Queueable: ' + System.now();
        }
        update accounts;

        // Chain another job if needed
        if(accounts.size() >= 10) {
            // Query for more accounts to process
            List<Account> moreAccounts = [SELECT Id FROM Account WHERE LastModifiedDate < LAST_N_DAYS:30 LIMIT 10];
            if(!moreAccounts.isEmpty()) {
                System.enqueueJob(new SimpleQueueable(moreAccounts));
            }
        }
    }
}

// Execute with: System.enqueueJob(new SimpleQueueable([SELECT Id FROM Account LIMIT 10]));
```

#### 6. Scheduled Apex (10 minutes)

-   **Concept Explanation (3 minutes)**

    -   Explain `Schedulable` interface
    -   Discuss cron expressions and scheduling options
    -   Cover time zone considerations

-   **Demonstration (7 minutes)** - Create a scheduler class to run batch jobs - Demonstrate scheduling via code and UI - Show how to view and manage scheduled jobs

```apex
public class SimpleScheduledJob implements Schedulable {

    public void execute(SchedulableContext sc) {
        // This could call a batch job
        Database.executeBatch(new SimpleAccountBatch());

        // Or perform some other processing
        Account[] accountsToUpdate = [SELECT Id FROM Account WHERE CreatedDate = TODAY];
        // Process accounts here
    }
}

// Schedule with:
// String cronExp = '0 0 0 ? * MON-FRI *'; // Midnight on weekdays
// System.schedule('Daily Scheduled Job', cronExp, new SimpleScheduledJob());
```

#### 7. Comparative Analysis and Best Practices (5 minutes)

-   Review when to use each asynchronous approach
-   Discuss governor limits and monitoring considerations
-   Share best practices for error handling in asynchronous contexts
-   Provide tips for debugging asynchronous processes

#### 8. Q&A and Homework Review (5 minutes)

-   Address student questions
-   Preview the homework assignment
-   Provide resources for further learning

### Instructor Tips

-   **Before Class Preparation:**

    -   Ensure your org has sufficient test data for demonstrations
    -   Test all code examples before class to avoid runtime issues
    -   Prepare simplified examples of each asynchronous type
    -   Consider having backup code available if live coding encounters problems

-   **During Demonstration:**

    -   Explain code as you write it, focusing on key syntax and concepts
    -   Regularly check for understanding with quick questions
    -   Use debug logs to show asynchronous execution in action
    -   Highlight common errors and how to troubleshoot them

-   **Common Student Challenges:**

    -   Mixed DML errors in future methods
    -   Understanding batch execution flow
    -   Monitoring and debugging asynchronous processes
    -   Grasping job chaining in queueable Apex

-   **Key Points to Emphasize:**
    -   Asynchronous Apex is essential for handling large data volumes
    -   Each type has specific use cases and limitations
    -   Understanding governor limits is crucial for effective implementation
    -   Error handling is more complex with asynchronous processes
    -   Testing asynchronous code requires specific approaches

```

```

```

```
