# Lesson 3 – Instructor Guide: Applied AI in Salesforce Development & Objects, Classes, Methods

## Lesson Summary
This session introduces **AI-assisted development in Salesforce** alongside **core object-oriented programming concepts in Apex**.  
Students will first explore how AI tools can be integrated into their workflow, then shift into foundational coding practice with objects, classes, and methods.  
By the end, students will understand both the potential and limitations of AI tools and the essential OOP skills needed to build scalable Salesforce applications.  

---

## Learning Objectives
By the end of this session, students will be able to:

- Describe appropriate AI-assisted use cases in Salesforce development.  
- Recognize the risks and limitations of AI-generated code.  
- Define and create **classes** in Apex.  
- Instantiate and work with **objects**.  
- Write and call **methods**, including passing parameters and returning values.  
- Explain how these fundamentals support scalable Salesforce development.  

---

## Lesson Outline (1h 30m Total)

### Part A: Applied AI in Salesforce Development (30 min)

#### 1. Welcome & Session Overview (5 min)
- Introduce today’s dual focus: AI-assisted development and Apex OOP foundations.  
- Acknowledge the rapid evolution of AI tools.  

---

#### 2. Role of AI in Development (10 min)
- AI as an **accelerator**, not a replacement.  
- Example uses: scaffolding boilerplate, generating test classes, drafting documentation.  
- Common pitfall: overreliance without understanding.  

---

#### 3. Salesforce AI Tools (10 min)
- **Einstein for Developers:** Natural language → Apex/SOQL/test code.  
- **Agentforce:** Low-code AI agents for workflows.  
- Demonstration: generate a starter class with AI, then refine manually.  

---

#### 4. Best Practices & Risks (5 min)
- Always review AI output.  
- Never paste sensitive data into third-party AI tools.  
- Treat AI-generated code as a draft, not a final solution.  

---

### Part B: Objects, Classes & Methods in Apex (60 min)

#### 1. Introduction to Classes (15 min)
- Define a **class** as a blueprint for objects.  
- Demonstrate structure with properties (variables) and methods.  

```apex
public class Car {
    public String make;
    public String model;
    public Integer year;

    public String getDescription() {
        return year + ' ' + make + ' ' + model;
    }
}
```

---

#### 2. Creating and Using Objects (20 min)
- Instantiate an object from a class.  
- Assign values to fields.  
- Call methods on the object.  

```apex
Car myCar = new Car();
myCar.make = 'Tesla';
myCar.model = 'Model 3';
myCar.year = 2024;

System.debug(myCar.getDescription()); // "2024 Tesla Model 3"
```

- Relate to Salesforce: every `Account`, `Contact`, or custom object record is an **instance**.  

---

#### 3. Methods in Depth (20 min)
- Define methods with parameters and return types.  
- Show method overloading (same method name, different parameters).  
- Explain scope: `public`, `private`, `global`.  

```apex
public class MathUtil {
    public static Integer add(Integer a, Integer b) {
        return a + b;
    }

    public static Decimal average(List<Decimal> numbers) {
        Decimal total = 0;
        for (Decimal n : numbers) {
            total += n;
        }
        return total / numbers.size();
    }
}

// Usage
System.debug(MathUtil.add(5, 7)); // 12
System.debug(MathUtil.average(new List<Decimal>{10, 20, 30})); // 20
```

---

#### 4. Q&A & Wrap-Up (5 min)
- Reinforce OOP concepts (classes, objects, methods).  
- Position AI as a complementary tool that builds on these fundamentals.  

---

## Key Points for Instructors
- Use AI examples as a hook, but dedicate most time to **hands-on OOP coding**.  
- Keep demonstrations simple, relatable, and Salesforce-relevant.  
- Emphasize that OOP knowledge is essential for triggers, controllers, and enterprise-scale projects.  
- Show how AI can speed up repetitive tasks but not replace deep understanding of Apex.  

---

## Copyright
Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.  

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited.  
This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.  

For licensing inquiries or permissions, contact: **admin@cloudcodeacademy.com**
