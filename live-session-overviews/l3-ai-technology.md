# Lesson 3 – Instructor Guide: Leveraging AI & GPT in Salesforce Development

## Lesson Summary
This session explores **practical applications of AI and GPT technologies** for Salesforce developers, including how to integrate them into a workflow without becoming over-reliant.  
Students will learn the benefits and limitations of AI tools, common use cases in Salesforce development, and ethical considerations when working with AI-generated code.  
The focus is on **real-world scenarios** — from code generation and refactoring to documentation and user assistance — while maintaining critical thinking and coding best practices.

---

## Learning Objectives
By the end of this session, students will be able to:

- Describe current AI and GPT capabilities relevant to Salesforce development.
- Identify appropriate use cases for AI tools such as **code refactoring**, **unit test generation**, and **documentation assistance**.
- Recognize the risks and limitations of relying on AI for code generation.
- Apply strategies to integrate AI effectively into a development workflow without sacrificing understanding or quality.
- Explore Salesforce’s AI offerings, including **Einstein for Developers** and **Agentforce**.

---

## Lesson Outline (1h 30m Total)

### 1. Welcome & Session Overview (5 min)
- Introduce today’s focus on AI and GPT technology in development.
- Acknowledge the fast-paced evolution of AI tools over the last 1–2 years.
- Briefly recap Salesforce’s AI journey:
  - Early **Einstein** features.
  - **Einstein for Developers**.
  - **Agentforce** and current innovations.

---

### 2. The Role of AI in Modern Development (10 min)
- AI as an **accelerator**, not a replacement:
  - Speed up repetitive coding tasks.
  - Automate low-value but necessary work.
- **Common Pitfall:** Using AI as a crutch instead of building problem-solving skills.

---

### 3. Common AI Use Cases for Developers (15 min)

#### **Code Generation**
- Quickly scaffold boilerplate code for Apex classes, Lightning Web Components, or SOQL queries.
- Example prompt to AI:  
  *"Write an Apex method to query open Cases created in the last 30 days and return their Subject fields."*

#### **Code Refactoring**
- Improve readability, maintainability, or performance of existing code.
- Especially valuable in large, unfamiliar codebases.

#### **Unit Test Generation**
- Have AI generate starter test methods to achieve coverage.
- **Instructor Example:** Provide an AI with a simple Apex class and ask for a test class, then review and improve it together.

#### **Documentation & Commenting**
- Use AI to create docstrings, method summaries, or README content.
- Always verify output for accuracy and context.

---

### 4. Limitations & Risks (10 min)
- **Context Awareness Limitations:**
  - AI cannot fully understand your org’s codebase or business logic.
  - Risk of introducing subtle bugs.
- **Overreliance Risks:**
  - Students may skip understanding why code works.
  - Generated code may not follow best practices.
- **Data Privacy:**
  - Avoid pasting proprietary or sensitive customer data into third-party AI tools.

---

### 5. Salesforce-Specific AI Tools (15 min)
- **Einstein for Developers:**
  - Integrated into VS Code with Salesforce Extensions.
  - Can generate Apex, SOQL, and tests from natural language prompts.
  - **Click-Path:**  
    1. Open VS Code.  
    2. **Ctrl+Shift+P** (Windows) or **Cmd+Shift+P** (Mac) → Type `Einstein: Generate Code` (feature name may vary).  
    3. Enter natural language prompt.  
    4. Review and insert generated code.

- **Agentforce:**
  - Low-code AI agent for Salesforce workflows.
  - Can automate data entry, summarization, and case routing.

---

### 6. Integrating AI into a Salesforce Workflow (15 min)
- **Best Practices:**
  - Start with your own solution, then compare to AI output.
  - Treat AI suggestions as **drafts** — always review and adapt.
  - Use AI for exploration and brainstorming, not final answers.
- **Real-World Scenario:**
  - Developer uses AI to draft a bulkified Apex method, then manually adds exception handling and logging.

---

### 7. Hands-On Demonstration (15 min)
- Provide a small Apex requirement.
- Demonstrate:
  1. Writing code manually.
  2. Asking AI to generate a version.
  3. Comparing and merging the best parts of both.
- Highlight the verification process for AI-generated code.

---

### 8. Q&A & Wrap-Up (5 min)
- Encourage mindful AI use — balance efficiency with skill development.
- Remind students that AI will be part of future assignments and projects.

---

## Key Points for Instructors
- Set clear expectations: AI is a **tool** to assist, not replace developer thinking.
- Always review AI-generated code live to model good verification practices.
- Showcase both Salesforce-native AI tools and general-purpose ones like ChatGPT or GitHub Copilot.
- Keep demonstrations simple and focused — avoid overwhelming with too many AI tools at once.

---

### Copyright
Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.  

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited.  
This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.  

For licensing inquiries or permissions, contact: **admin@cloudcodeacademy.com**