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

### Materials Needed

-   Prepared developer org with sample data (contacts, accounts)
-   Pre-written starter code files (shared with students before class)
-   Slides covering key concepts
-   Demo environment accessible to instructor

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
-   **Demonstration (10 minutes)**
    -   Live code a future method to address mixed DML scenario
    -   Show proper syntax for `@future(callout=true)` annotation
    -   Execute the code and review logs to show asynchronous execution
    -   Highlight error cases to watch for

#### 4. Batch Apex (20 minutes)

-   **Concept Explanation (5 minutes)**

    -   Explain `Database.Batchable` interface
    -   Cover the three required methods: start, execute, finish
    -   Discuss batch size considerations (default 200, max 200)
    -   Highlight use cases for large data volumes (50,000+ records)

-   **Demonstration (15 minutes)**
    -   Live code a batch class to process inactive contacts
    -   Implement all three required methods
    -   Show how to execute the batch from Anonymous Apex
    -   Demonstrate monitoring batch jobs in Setup > Apex Jobs
    -   Discuss batch size optimization strategies

#### 5. Queueable Apex (20 minutes)

-   **Concept Explanation (5 minutes)**

    -   Explain `Queueable` interface
    -   Compare to Batch Apex and Future methods
    -   Highlight key benefits: job chaining, complex data structures
    -   Discuss appropriate use cases for smaller, sequential operations

-   **Demonstration (15 minutes)**
    -   Live code a queueable class to process records sequentially
    -   Implement job chaining with `System.enqueueJob`
    -   Show how to limit chain depth to avoid hitting limits
    -   Execute and monitor the queueable job

#### 6. Scheduled Apex (10 minutes)

-   **Concept Explanation (3 minutes)**

    -   Explain `Schedulable` interface
    -   Discuss cron expressions and scheduling options
    -   Cover time zone considerations

-   **Demonstration (7 minutes)**
    -   Create a scheduler class to run batch jobs
    -   Demonstrate scheduling via code and UI
    -   Show how to view and manage scheduled jobs

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
