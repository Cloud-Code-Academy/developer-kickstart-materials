# Lesson 12 – Instructor Guide: Introduction to Lightning Web Components (LWCs)

## Learning Objectives
By the end of this session, students will be able to:
- Explain what **Lightning Web Components (LWCs)** are and how they fit into the Salesforce platform.
- Understand the differences between LWCs, Aura components, and Visualforce.
- Create, deploy, and preview a basic LWC.
- Use the standard LWC file structure and key files (`.html`, `.js`, `.js-meta.xml`).
- Display Salesforce data in an LWC using `@wire` and Apex methods.
- Understand how LWCs are packaged and deployed for use on Lightning pages.

---

## Lesson Outline (1h 30m Total)

### 1. Welcome & Context (5 min)
- Recap previous Apex lessons and connect to today’s topic: building **UI with LWCs**.
- Clarify that LWCs are modern, standards-based web components leveraging core web technologies (HTML, CSS, JavaScript).

---

### 2. What Are LWCs? (10 min)
- Built on **Web Components** standards.
- Benefits:
  - Faster performance.
  - Better encapsulation.
  - Reusability across pages.
- Compare briefly:
  - **LWC vs Aura**: performance and syntax differences.
  - **LWC vs Visualforce**: client-side rendering vs server-side rendering.

---

### 3. LWC Project Structure (10 min)
- Each LWC lives in its own folder under `force-app/main/default/lwc/`.
- Key files:
  - `componentName.html` — template markup.
  - `componentName.js` — JavaScript controller.
  - `componentName.js-meta.xml` — metadata/configuration.
- Show an example folder structure in VS Code.

---

### 4. Live Demo – Creating a Basic LWC (25 min)

**Files for Reference (do not copy/paste):**
 - `force-app\live-coding\module12\lwc\lwcDemo\lwcDemo.html` – The primary LWC used in this lesson. It demonstrates working with a Lightning record form, reacting to design-time properties, and wiring object metadata via Lightning UI API.
 - `force-app\live-coding\module12\lwc\lwcDemo\lwcDemo.js` – The JavaScript controller for `lwcDemo` showing how to expose properties, handle events, and derive computed values.
 - `force-app\live-coding\module12\lwc\lwcDemo\lwcDemo.js-meta.xml` – The metadata file configuring visibility and targets for the `lwcDemo` component.
 - Additional LWCs for optional exploration:
   - `force-app\live-coding\module12\lwc\sayHello\\` – A simple component that greets the user and demonstrates reactive properties.
   - `force-app\live-coding\module12\lwc\accountContacts\\` and `force-app\live-coding\module12\lwc\accountContactRow\\` – Components that display Accounts and their Contacts using an Apex controller.
   - `force-app\live-coding\module12\lwc\nearbyCustomers\\` and `force-app\live-coding\module12\lwc\nearbyCustomersImproved\\` – Example components for mapping nearby customers using geolocation data.
 - Apex controllers:
   - `force-app\live-coding\module12\classes\AccountContactsController.cls` – Server-side controller that queries Accounts and Contacts for the `accountContacts` component.
   - `force-app\live-coding\module12\classes\NearbyCustomerController.cls` – Server-side controller used by the `nearbyCustomers` components to fetch location data.

> **Note:** The `lwcDemo` component is the main focus of this lesson. The other LWCs and Apex classes listed above are included for additional practice or to extend the lesson if time permits.

**Step 1 – Create LWC**
- **From VS Code:**
  1. Ctrl+Shift+P / Cmd+Shift+P → `SFDX: Create Lightning Web Component`.
  2. Name: `lwcDemo`.
  3. Choose `force-app/main/default/lwc` as location.
- **From Salesforce CLI:**
  ```bash
  sfdx force:lightning:component:create --type lwc --componentname lwcDemo --outputdir force-app/main/default/lwc
  ```

**Step 2 – Add HTML**
```html
<template>
    <h1>Hello, {name}!</h1>
</template>
```

**Step 3 – Add JavaScript**
```javascript
import { LightningElement, track } from 'lwc';

export default class LwcDemo extends LightningElement {
    name = 'Salesforce';
}
```

**Step 4 – Configure Metadata**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>59.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__AppPage</target>
        <target>lightning__RecordPage</target>
        <target>lightning__HomePage</target>
    </targets>
</LightningComponentBundle>
```

**Step 5 – Deploy & Preview**
- Deploy to org: Right-click component folder → **SFDX: Deploy Source to Org**.
- Add to Lightning App Builder page:
  1. In Salesforce, go to Setup → Lightning App Builder.
  2. Open a page → Drag `lwcDemo` onto the canvas → Save & Activate.

---

### 5. Passing Data into LWCs (10 min)
- Use **public properties** with `@api` decorator to pass values from parent components or Lightning App Builder.
- Example:
```javascript
import { LightningElement, api } from 'lwc';
export default class LwcDemo extends LightningElement {
    @api name;
}
```

---

### 6. Using Apex in LWCs (15 min)
- Import Apex method:
```javascript
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
```
- Use `@wire` to fetch data:
```javascript
@wire(getAccounts) accounts;
```
- Show results in HTML template with iteration.

---

### 7. Best Practices for LWCs (10 min)
- Keep components focused on one purpose.
- Use reactive properties and decorators (`@api`, `@track`, `@wire`) appropriately.
- Handle errors gracefully.
- Avoid hardcoding record IDs.

---

### 8. Wrap-Up & Q&A (5 min)
- Recap:
  - LWC basics and structure.
  - Creating, deploying, and previewing an LWC.
  - Passing data and integrating with Apex.
- Address student questions.

---

### Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com
