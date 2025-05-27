Based on both transcripts and your updated instructions, here is the **final revised Lesson 4 Instructor Guide**. This version is **strictly focused on DML**, **excludes any async concepts** (like `@future`), and incorporates DML-related teaching moments from both caption files.

---

# Lesson 4 Instructor Guide: Working with DML in Apex

## Lesson Summary

This lesson introduces students to the core concept of **DML (Data Manipulation Language)** in Apex. Students will practice performing `insert`, `update`, and `delete` operations in Apex code using both single-record and bulk patterns. The focus is on writing correct, governor-limit-friendly DML, understanding how transactions work, and troubleshooting common issues such as runtime errors during DML.

---

## Learning Objectives

By the end of this lesson, students will be able to:

-   Perform basic DML operations in Apex (`insert`, `update`, `delete`)
-   Work with DML on both single records and collections (bulk-safe patterns)
-   Understand what happens during a transaction and how failures behave
-   Use `Database.insert()` and `Database.update()` methods to capture partial success/failure
-   Begin reading and interpreting system debug logs related to DML operations
-   Understand the relationship between records, IDs, and DML operations

---

## Lesson Outline (DML-Focused)

### 1. Intro to DML in Apex (5 min)

-   Define DML: Data Manipulation Language
-   Introduce the 5 basic DML statements used in Apex:

    -   `insert`
    -   `update`
    -   `delete`
    -   `upsert` (brief mention)
    -   `undelete` (brief mention)

### 2. Writing DML for Single Records (10 min)

-   Code demo: insert a Contact record

```apex
Contact c = new Contact(FirstName='Jane', LastName='Doe', Email='jane@example.com');
insert c;
```

-   Show how to use debug logs to verify the insertion
-   Update the same record

```apex
c.LastName = 'Smith';
update c;
```

-   Key teaching moment from transcript: Emphasize **reading debug logs** line-by-line to confirm DML occurred successfully.
-   Show how the ID field automatically gets populated after insert

```apex
System.debug('Before insert: ' + c);
insert c;
System.debug('After insert: ' + c); // Now has an ID!
```

---

### 3. Creating Records with Field Values (10 min)

-   Demonstrate different ways to create and set record field values:

```apex
// Method 1: Create then set fields individually
Account acc1 = new Account();
acc1.Name = 'Test Account 1';
acc1.Description = 'Created with individual field assignments';

// Method 2: Set fields in constructor
Account acc2 = new Account(
    Name = 'Test Account 2',
    Description = 'Created with constructor parameters'
);

// Both approaches are valid and commonly used
```

-   Explain how to use relationships when creating child records:

```apex
// First create and insert parent record
Account parentAccount = new Account(Name = 'Parent Account');
insert parentAccount;

// Then create child record with lookup relationship
Contact childContact = new Contact(
    FirstName = 'John',
    LastName = 'Doe',
    AccountId = parentAccount.Id  // Using the ID to create relationship
);
insert childContact;
```

-   Key point: You need the parent record's ID before you can establish a relationship

---

### 4. Writing Bulk-Safe DML (15 min)

-   Explain why we avoid DML in loops
-   Demo: create a list of 5 Contacts and insert them together

```apex
List<Contact> contacts = new List<Contact>();
for (Integer i = 0; i < 5; i++) {
    contacts.add(new Contact(FirstName='User', LastName='Test' + i));
}
insert contacts;
```

-   Ask students: "How many DML statements did we just use?"

-   Emphasize:

    -   One DML statement can handle multiple records
    -   This helps stay within governor limits (limit of 150 DML statements)
    -   DML operations are time-consuming for the system, so batching is more efficient

-   Anti-pattern to avoid:

```apex
// BAD PRACTICE - Will hit governor limits with large data sets
for (Contact c : contactsList) {
    update c; // DON'T put DML inside loops!
}

// GOOD PRACTICE
List<Contact> contactsToUpdate = new List<Contact>();
for (Contact c : contactsList) {
    c.Title = 'Updated Title';
    contactsToUpdate.add(c);
}
update contactsToUpdate; // Single DML statement outside the loop
```

---

### 5. Working with Record IDs (15 min)

-   Explain how IDs are central to DML operations
-   Demonstrate that IDs are automatically populated after insert:

```apex
Account newAccount = new Account(Name = 'New Account');
System.debug('Before insert: ' + newAccount.Id); // null
insert newAccount;
System.debug('After insert: ' + newAccount.Id); // Now has a value
```

-   Show how to update a record using only its ID and the fields you want to change:

```apex
// If you only have the ID and want to update specific fields:
Account accountToUpdate = new Account(
    Id = accountId,  // Must include the ID
    Description = 'Updated description'  // Only specify fields you want to change
);
update accountToUpdate;
```

-   Key teaching point: You don't need to query a record before updating it if you know its ID and the fields you want to modify
-   Emphasize that when updating, only the fields specified in your code will be changed; other fields remain untouched

---

### 6. Using the Database Class (15 min)

-   Introduce `Database.insert()` and `Database.update()` as alternatives to DML keywords
-   Compare the syntax differences:

```apex
// Standard DML syntax
insert myList;

// Database class syntax
Database.insert(myList);
```

-   Explain why these are used for **partial success handling**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name='Valid Account'),
    new Account() // Missing required Name field — will fail
};
// Second parameter "false" allows partial success
Database.SaveResult[] results = Database.insert(accounts, false);
```

-   Show how to loop over `SaveResult` and log success/failure:

```apex
for (Database.SaveResult sr : results) {
    if (sr.isSuccess()) {
        System.debug('Inserted record ID: ' + sr.getId());
    } else {
        System.debug('Error: ' + sr.getErrors()[0].getMessage());
    }
}
```

-   Transcript tie-in: Pause to let students **read logs and interpret results themselves** — a common stuck point.

---

### 7. Transaction Behavior (10 min)

-   Explain that all DML in a method runs as a **single transaction**
-   Show what happens when an error occurs (e.g. one invalid record causes the whole `insert` to fail)
-   Demonstrate the difference in transaction handling:

```apex
// All-or-nothing approach (standard DML)
try {
    insert accountsList;  // If one fails, they all fail
} catch (DmlException e) {
    System.debug('Error occurred: ' + e.getMessage());
}

// Partial success approach
Database.SaveResult[] results = Database.insert(accountsList, false);
// Some records might succeed even if others fail
```

-   Key Insight from transcript:
    -   Students got confused between compile-time vs runtime issues
    -   Re-run DML with one record intentionally invalid
    -   Let students observe the error in the logs

---

### 8. DML Performance Optimization (10 min)

-   Discuss best practices for optimizing DML performance:

    -   Batch related records in a single DML statement when possible
    -   Use the appropriate collections (List, Map) to organize records before DML
    -   Consider the order of DML operations (parent records before child records)
    -   Be cautious with large data volumes
    -   Avoid "mega lists" of mixed object types - organize by object type for clarity and performance

-   Key teaching point from transcript:
    -   DML operations are very time-consuming
    -   Minimizing DML statements improves user experience and prevents timeouts
    -   However, don't over-optimize at the expense of code readability

---

### 9. Student Coding Practice (20 min)

**Activity 1:**

-   Create 5 Account records in a list
-   Use `insert` to save them
-   Then use a loop to update their descriptions

**Activity 2:**

-   Use `Database.insert(list, false)` on purpose with one invalid record
-   Capture `SaveResult` and log the errors

**Activity 3 (Advanced):**

-   Create a parent record and multiple child records in a relationship
-   Practice updating the child records by ID without re-querying them

---

## Instructor Notes

-   Encourage frequent use of `System.debug()` to trace values before and after DML
-   Have students **predict what will happen** before running each block of code
-   Make space for students to re-run code after modifying it — logs are the primary learning tool
-   If someone hits a governor limit (e.g. too many DMLs), pause and explain why
-   Avoid any reference to asynchronous Apex — they'll learn that later
-   Emphasize the central role of IDs in DML operations - they're the key to how Salesforce tracks and relates records

---

## Common Student Challenges (Observed in Transcript)

-   Confusing what causes DML errors (e.g. validation rules vs required fields)
-   Not reading debug logs carefully
-   Looping over records without realizing they're triggering too many DML statements
-   Forgetting to add `List<>` wrappers before inserting multiple records
-   Not understanding when it's necessary to query records vs. when you can just use the ID
-   Failing to recognize that Database class methods provide more detailed error information

---

## Real-world Examples

-   Data migration scenarios: importing customer data into Salesforce
-   Integration patterns: processing API responses and creating/updating records
-   Automation logic: making multiple related changes in a single transaction
-   Error handling: providing meaningful feedback to users when DML operations fail

---

### Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com
