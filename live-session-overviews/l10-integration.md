# Live Coding Workshop: Apex Integrations

## Instructor Guide

### Workshop Overview

This 90-minute workshop introduces students to Apex integrations in Salesforce, covering both inbound and outbound integration patterns. Students will learn the fundamentals of REST APIs, HTTP callouts, and exposing Salesforce endpoints for external systems. The session emphasizes practical implementation with real-world examples and proper error handling.

### Learning Objectives

By the end of this session, students will be able to:

-   Explain the difference between REST and SOAP APIs
-   Implement HTTP callouts to external REST APIs
-   Create and expose custom REST endpoints in Salesforce
-   Handle different HTTP methods (GET, POST, DELETE)
-   Implement proper error handling and timeout management
-   Set up remote site settings for external integrations
-   Use mock callouts for testing integration code

### Session Outline (90 minutes)

#### 1. Welcome and Integration Overview (10 minutes)

-   Welcome students and outline the session objectives
-   Define APIs and integration concepts
-   Explain the importance of integrations in modern business
-   Introduce REST vs SOAP API differences
-   Highlight that REST is the most common modern integration pattern

#### 2. Exposing Salesforce Endpoints (25 minutes)

**Concept Explanation (5 minutes)**

-   Explain `@RestResource` annotation and global class requirements
-   Cover HTTP method decorators: `@HttpGet`, `@HttpPost`, `@HttpDelete`
-   Discuss URL mapping with wildcards for dynamic parameters
-   Review security considerations and access control

**Demonstration (20 minutes)**

-   Live code a REST endpoint class to manage contacts
-   Implement GET method to retrieve contact data
-   Create POST method to insert new contacts with try-catch error handling
-   Build DELETE method showing parameter extraction from URL
-   Test endpoints using Workbench REST Explorer

```apex
@RestResource(urlMapping='/testAPI/*')
global class RestEndpoint {

    @HttpGet
    global static List<Contact> getContacts() {
        return [SELECT Id, Name, Account.Name FROM Contact LIMIT 50];
    }

    @HttpPost
    global static String createContact(String lastName, String email) {
        try {
            Contact newContact = new Contact();
            newContact.LastName = lastName;
            newContact.Email = email;
            insert newContact;
            return 'Contact created with ID: ' + newContact.Id;
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }

    @HttpDelete
    global static String deleteContact() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);

        try {
            Contact contactToDelete = [SELECT Id FROM Contact WHERE Id = :contactId];
            delete contactToDelete;
            return 'Contact successfully deleted';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}
```

#### 3. Making External HTTP Callouts (35 minutes)

**Concept Explanation (10 minutes)**

-   Explain HTTP request/response cycle
-   Cover the three key Salesforce classes: `HttpRequest`, `Http`, `HttpResponse`
-   Discuss HTTP methods (GET, POST, PUT, DELETE)
-   Review common headers and authentication patterns
-   Explain the need for remote site settings

**Demonstration (25 minutes)**

-   Live code an external API integration using a public API
-   Build HTTP request with proper endpoint, method, and headers
-   Implement request sending and response handling
-   Add status code checking for success/failure scenarios
-   Show how to parse JSON responses
-   Demonstrate remote site settings configuration
-   Add timeout settings and callout exception handling

```apex
public class PaymentGatewayCallout {

    @future(callout=true)
    public static void getBillingAccount(String billingAccountId) {
        // Build the request
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.paymentgateway.com/billing-account/' + billingAccountId);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(120000); // 2 minutes max

        try {
            // Send the request
            HttpResponse response = new Http().send(request);

            // Check if request was successful
            if (response.getStatusCode() < 200 || response.getStatusCode() > 299) {
                System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getBody());
                return;
            }

            // Parse successful response
            String responseBody = response.getBody();
            System.debug('Success: ' + responseBody);

        } catch (CalloutException e) {
            System.debug('Callout failed: ' + e.getMessage());
            throw e; // Re-throw for visibility
        }
    }
}
```

#### 4. Advanced Topics and Best Practices (15 minutes)

**JSON Parsing and Request Bodies (5 minutes)**

-   Demonstrate creating JSON request bodies using maps
-   Show `JSON.serialize()` and `JSON.deserialize()` methods
-   Explain when to use typed vs untyped deserialization

**Error Handling Strategies (5 minutes)**

-   Review different types of failures: network, authentication, business logic
-   Discuss when to use try-catch blocks meaningfully
-   Explain the "fail loudly" principle for debugging
-   Cover timeout considerations and Governor limits

**Testing Integration Code (5 minutes)**

-   Introduce mock callouts for unit testing
-   Show basic `HttpCalloutMock` implementation
-   Explain why external callouts can't be made in test methods
-   Demonstrate the importance of testing both success and failure scenarios

```apex
@isTest
public class PaymentGatewayMockCallout implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{"status": "success"}');
        response.setHeader('Content-Type', 'application/json');
        return response;
    }
}

@isTest
private static void testSuccessfulCallout() {
    Test.setMock(HttpCalloutMock.class, new PaymentGatewayMockCallout());

    Test.startTest();
    PaymentGatewayCallout.getBillingAccount('test123');
    Test.stopTest();

    // Assert expected behavior
}
```

#### 5. Q&A and Wrap-up (5 minutes)

-   Address student questions about integration concepts
-   Preview homework assignment requirements
-   Provide additional resources for learning integrations
-   Remind students about the integration architect certification path

### Instructor Tips

**Before Class Preparation:**

-   Set up a developer org with test contact data
-   Verify access to a reliable public API for demonstrations
-   Test all code examples to ensure they work
-   Prepare backup examples in case the chosen API has issues
-   Review current Salesforce integration documentation

**During Demonstration:**

-   Emphasize that API quality varies widely in the real world
-   Show students how to troubleshoot when APIs don't work as documented
-   Explain each HTTP concept as you implement it
-   Use debug logs extensively to show what's happening
-   Be prepared for API failures and use them as teaching moments

**Common Student Challenges:**

-   Understanding the difference between inbound and outbound integrations
-   Remembering to set up remote site settings
-   Grasping asynchronous execution with `@future(callout=true)`
-   Parsing complex JSON responses
-   Understanding when to catch exceptions vs. let them propagate

**Key Points to Emphasize:**

-   Integrations are everywhere in modern business applications
-   REST APIs are the most common integration pattern today
-   Always check API documentation, but be prepared for inaccuracies
-   Error handling is crucial since external systems are unreliable
-   Security considerations are paramount when exposing endpoints
-   Asynchronous processing often pairs well with integrations
-   Testing requires mock callouts since real external calls aren't allowed

**Real-World Context:**

-   Most companies use multiple systems that need to communicate
-   Payment processing, email services, and data synchronization are common use cases
-   API quality varies significantly between vendors
-   Authentication patterns range from simple API keys to complex OAuth flows
-   Performance and timeout considerations become critical at scale

### Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com
