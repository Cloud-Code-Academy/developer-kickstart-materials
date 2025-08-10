# Lesson 5 – Instructor Guide: SOQL & Basic Data Retrieval in Apex

## Learning Objectives
By the end of this session, students will be able to:
- Understand the purpose and syntax of **Salesforce Object Query Language (SOQL)**.
- Write and execute simple SOQL queries in both the **Developer Console** and **VS Code**.
- Store SOQL query results in variables and iterate over collections.
- Apply WHERE clauses to filter records.
- Safely debug and inspect query results.
- Recognize common pitfalls in SOQL query execution.

---

## Lesson Outline (1h 30m Total)

**Files for Reference (do not copy/paste):**  
- `force-app\live-coding\module5\soqlDemo.apex` – Anonymous Apex script demonstrating basic SOQL queries and iteration over result sets used in this lesson.  
- `force-app\live-coding\module5\classes\SoqlDemo.cls` – Supporting Apex class with methods to retrieve Accounts and Contacts for demonstration purposes.  

### 1. Welcome & Context (5 min)
- Briefly recap previous lesson’s Apex basics.
- Introduce today’s focus: **retrieving data from Salesforce with SOQL**.
- Explain why SOQL is essential for Apex developers.

---

### 2. SOQL Fundamentals (10 min)
- Define **SOQL** and contrast it with SQL.
- Explain how SOQL interacts with Salesforce objects.
- Discuss when SOQL is used in Apex (trigger context, batch jobs, reporting logic).
- Syntax overview:
  ```apex
  SELECT Name, Id FROM Account
  ```

---

### 3. Running SOQL in the Developer Console (10 min)
- Click-path:  
  `Avatar Menu → Developer Console → Query Editor`
- Demonstrate entering:
  ```sql
  SELECT Name, Id FROM Account
  ```
- Show **Execute** button and how results appear in tabular form.
- Discuss **limiting results** with `LIMIT` keyword.

---

### 4. Running SOQL in Anonymous Apex via Developer Console (10 min)
- Click-path:  
  `Avatar Menu → Developer Console → Debug → Open Execute Anonymous Window`
- Example:
  ```apex
  List<Account> accs = [SELECT Name, Id FROM Account LIMIT 5];
  System.debug(accs);
  ```
- Show Debug Log and how to expand results.
- Discuss the difference between running raw SOQL and embedding it in Apex.

---

### 5. Running SOQL in VS Code (10 min)
- Command Palette:  
  **Ctrl+Shift+P** (Windows) / **Cmd+Shift+P** (Mac) → `SFDX: Execute Anonymous Apex with Currently Selected Text`
- Run:
  ```apex
  List<Account> accs = [SELECT Name FROM Account LIMIT 5];
  System.debug(accs);
  ```
- Show deployment confirmation and Debug Log retrieval.
- Mention that SOQL can also be executed via the Salesforce CLI:
  ```bash
  sfdx force:data:soql:query -q "SELECT Name FROM Account LIMIT 5"
  ```

---

### 6. Filtering with WHERE Clauses (10 min)
- Explain boolean expressions in SOQL.
- Example:
  ```apex
  List<Account> namedAcme = [SELECT Name FROM Account WHERE Name = 'Acme'];
  System.debug(namedAcme);
  ```
- Show operators: `=`, `!=`, `LIKE`, `IN`.
- Common pitfall: forgetting quotes for string values.

---

### 7. Iterating Over Query Results (10 min)
- Use `for` loops to process query results.
  ```apex
  List<Account> accs = [SELECT Name FROM Account LIMIT 5];
  for (Account a : accs) {
      System.debug('Account Name: ' + a.Name);
  }
  ```
- Show how to combine with collections for further logic.

---

### 8. Live Coding – Multiple Queries & Collections (15 min)
- Demonstrate running multiple queries for different objects (e.g., `Contact`, `Opportunity`).
- Store results in `List` variables.
- Use `Map<Id, Account>` to store by ID for fast lookups:
  ```apex
  Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, Name FROM Account]);
  System.debug(accMap);
  ```

---

### 9. Common Pitfalls & Best Practices (5 min)
- Avoid unbounded queries in production code.
- Use `LIMIT` during testing to reduce log clutter.
- Always check for empty results before iterating.

---

### 10. Q&A & Wrap-Up (5 min)
- Review key takeaways: SOQL basics, WHERE clauses, running in Dev Console & VS Code.
- Encourage students to practice by querying different standard objects in their dev org.

---

## Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com
