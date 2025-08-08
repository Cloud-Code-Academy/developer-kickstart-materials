# Lesson 4 – Instructor Guide: Database Manipulation Language (DML) in Apex  
**Duration:** ~1h 30m  
Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

---

## Lesson Summary
In this lesson, students learn to create, update, delete, and restore Salesforce records programmatically using **Apex DML statements**.  
We’ll cover the five core operations (`INSERT`, `UPDATE`, `UPSERT`, `DELETE`, `UNDELETE`), explore bulk operations, discuss governor limits, and handle exceptions gracefully.  
All examples are **org-safe** and can be run in a fresh Developer Edition org without creating custom fields or objects.

---

## Learning Objectives
By the end of this session, students will be able to:
- Explain the five core DML operations in Apex.
- Write Apex to manipulate records both individually and in bulk.
- Avoid DML inside loops through **bulkification patterns**.
- Use `Database` methods for partial success.
- Understand `UPSERT` behavior without custom external IDs.
- Apply error handling with `try/catch` and inspect debug logs for troubleshooting.

---

## Lesson Outline (1h 30m)

### 1. Welcome & Context (5 min)
**Purpose:** Establish DML’s role in the Salesforce platform.
- DML = Database Manipulation Language; Apex’s way to create, modify, and remove records.
- Comparable to SQL’s `INSERT`, `UPDATE`, `DELETE`, but runs in Salesforce’s multi-tenant environment with governor limits.
- Real-world use: triggers, scheduled jobs, integrations, data migration.

**Live Demo Cue:**  
Open **Developer Console** → **Debug → Open Execute Anonymous Window**.  
This is where we’ll run today’s examples.

---

### 2. INSERT (10 min)
**Concept:** Add new records to Salesforce.

**Demo – Single Record:**
```apex
Account acc = new Account(Name = 'Acme Corporation');
insert acc;
```
- Run in Execute Anonymous.
- Show new Account in UI.

**Variation:** Use object initialization vs. setting fields afterward:
```apex
Account acc = new Account();
acc.Name = 'Beta Industries';
insert acc;
```

**Common Student Challenge:** Forgetting required fields (e.g., `LastName` for Contact).

---

### 3. Bulk INSERT (10 min)
**Why Bulk Matters:**
- Governor limit: **150 DML statements** per transaction.
- Bulk DML handles many records at once.

**Demo – Bulk INSERT:**
```apex
List<Contact> contactsToInsert = new List<Contact>{
    new Contact(FirstName='Jane', LastName='Doe'),
    new Contact(FirstName='John', LastName='Smith')
};
insert contactsToInsert;
```

**Anti-Pattern Example (Don’t Do This):**
```apex
for (Contact c : contactsToInsert) {
    insert c; // BAD: one DML per record
}
```

---

### 4. UPDATE & Bulkification (15 min)
**Concept:** Modify existing records.

**Demo – Bulk UPDATE:**
```apex
List<Account> accList = [SELECT Id, Name FROM Account LIMIT 5];
for (Account a : accList) {
    a.Name += ' - Updated';
}
update accList; // Bulk update outside loop
```
**Live Check:** Query Accounts again to show updated names.

**Pitfall:** DML inside loops wastes statements and can hit limits.

---

### 5. Error Handling with try/catch (10 min)
**Why:** Prevent runtime crashes and log useful error info.

**Demo – Exception Handling:**
```apex
Account acc = new Account(); // Missing Name
try {
    insert acc;
} catch (DmlException e) {
    System.debug('Error: ' + e.getMessage());
}
```

**Instructor Tip:** Run this and open **Debug Logs** to show the captured message.

---

### 6. Partial Success with Database Methods (15 min)
**When to use:**  
- Bulk operations where you want valid records to save even if some fail.

**Demo – `Database.insert()` with `allOrNone=false`:**
```apex
List<Account> accounts = new List<Account>{
    new Account(Name='Valid Account'),
    new Account() // Missing Name
};

Database.SaveResult[] results = Database.insert(accounts, false);
for (Database.SaveResult sr : results) {
    if (sr.isSuccess()) {
        System.debug('Inserted Id: ' + sr.getId());
    } else {
        System.debug('Error: ' + sr.getErrors()[0].getMessage());
    }
}
```
**Check Understanding:** Ask why the valid record saved but the invalid didn’t.

---

### 7. UPSERT Without Custom External IDs (10 min)
**Key Concept:**  
- With an `Id` → updates the record.
- Without an `Id` → inserts the record.

**Demo:**
```apex
Account acc1 = new Account(Name = 'Acme Corporation');
insert acc1;

acc1.Name = 'Acme Corp - Updated';
upsert acc1; // Matches by Id
```
**Prompt:** “What happens if we remove `acc1.Id` before the upsert?”

---

### 8. DELETE & UNDELETE (10 min)
**Concept:**  
- `DELETE` moves records to the Recycle Bin.
- `UNDELETE` restores them.

**Demo:**
```apex
List<Account> accountsToDelete = [SELECT Id FROM Account LIMIT 2];
delete accountsToDelete;
undelete accountsToDelete;
```

**Pitfall:** Students may expect DELETE to be permanent immediately.

---

### 9. Hands-On Challenge (10 min)
**Student Task:**
1. Insert 3 Accounts.  
2. Update them in bulk.  
3. Upsert them to change names again.  
4. Delete them.  
5. Restore them with `UNDELETE`.  

**Instructor Cue:**  
- Monitor for DML inside loops.  
- Have students print debug logs after each operation.

---

### 10. Wrap-Up & Q&A (5 min)
- Recap:
  - 5 core DML operations.
  - Bulkification prevents governor limit errors.
  - Use `Database` methods for partial success.
- Encourage testing in scratch orgs and sandboxes before production.

---

## Common Student Challenges
- Forgetting required fields.
- Performing DML inside loops.
- Misunderstanding UPSERT behavior.
- Expecting DELETE to be permanent.

---

## Instructor Notes
- Pair each CLI or Apex example with a UI click-path when possible.
- Show a **governor limit error** once to make it memorable.
- Always use Accounts and Contacts for examples to keep them org-safe.
- Pause after each code demo for students to replicate and run it.

---

## Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com