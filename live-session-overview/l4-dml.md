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

---

### 3. Writing Bulk-Safe DML (15 min)

-   Explain why we avoid DML in loops
-   Demo: create a list of 5 Contacts and insert them together

```apex
List<Contact> contacts = new List<Contact>();
for (Integer i = 0; i < 5; i++) {
    contacts.add(new Contact(FirstName='User', LastName='Test' + i));
}
insert contacts;
```

-   Ask students: “How many DML statements did we just use?”

-   Emphasize:

    -   One DML statement can handle multiple records
    -   This helps stay within governor limits

---

### 4. Using the Database Class (15 min)

-   Introduce `Database.insert()` and `Database.update()`
-   Explain why these are used for **partial success handling**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name='Valid Account'),
    new Account() // Missing required Name field — will fail
};
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

### 5. Transaction Behavior (10 min)

-   Explain that all DML in a method runs as a **single transaction**
-   Show what happens when an error occurs (e.g. one invalid record causes the whole `insert` to fail)
-   Key Insight from transcript:

    -   Students got confused between compile-time vs runtime issues
    -   Re-run DML with one record intentionally invalid
    -   Let students observe the error in the logs

---

### 6. Student Coding Practice (20 min)

**Activity 1:**

-   Create 5 Account records in a list
-   Use `insert` to save them
-   Then use a loop to update their descriptions

**Activity 2:**

-   Use `Database.insert(list, false)` on purpose with one invalid record
-   Capture `SaveResult` and log the errors

---

## Instructor Notes

-   Encourage frequent use of `System.debug()` to trace values before and after DML
-   Have students **predict what will happen** before running each block of code
-   Make space for students to re-run code after modifying it — logs are the primary learning tool
-   If someone hits a governor limit (e.g. too many DMLs), pause and explain why
-   Avoid any reference to asynchronous Apex — they’ll learn that later

---

## Common Student Challenges (Observed in Transcript)

-   Confusing what causes DML errors (e.g. validation rules vs required fields)
-   Not reading debug logs carefully
-   Looping over records without realizing they're triggering too many DML statements
-   Forgetting to add `List<>` wrappers before inserting multiple records

---

### Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com
