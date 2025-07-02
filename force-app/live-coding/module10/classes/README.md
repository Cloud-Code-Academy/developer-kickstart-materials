# Module 10: Integration Examples for Beginners

Welcome to the integration module! This folder contains simple, beginner-friendly examples of Salesforce integrations.

## 📚 What You'll Learn

1. **REST Endpoints** - How to expose Salesforce data to external systems
2. **HTTP Callouts** - How to call external APIs from Salesforce
3. **Testing Integrations** - How to test with mock responses
4. **Best Practices** - Error handling, security, and debugging tips

## 📁 Files in This Module

### Core Classes

-   **SimpleRestEndpoint.cls** - Shows how to create REST APIs in Salesforce
-   **SimpleExternalCallout.cls** - Shows how to call external APIs
-   **SimpleCalloutMock.cls** - Mock classes for testing
-   **SimpleIntegrationTest.cls** - Complete test examples

### Helper Class

-   **IntegrationDemoHelper.cls** - Tips, patterns, and debugging help

## 🚀 Getting Started

### Step 1: Deploy the Classes

Deploy all the `.cls` files and their `.cls-meta.xml` files to your org.

### Step 2: Test REST Endpoints

1. Open [Workbench](https://workbench.developerforce.com)
2. Login to your Salesforce org
3. Go to **Utilities > REST Explorer**
4. Try these endpoints:

**GET Request:**

```
/services/apexrest/simpleAPI/
```

**POST Request:**

```
/services/apexrest/simpleAPI/

Body:
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com"
}
```

**DELETE Request:**

```
/services/apexrest/simpleAPI/{contactId}
```

### Step 3: Test External Callouts

1. Go to **Setup > Security > Remote Site Settings**
2. Click **New Remote Site**
3. Add these settings:

    - Remote Site Name: `JokeAPI`
    - Remote Site URL: `https://official-joke-api.appspot.com`
    - Active: ✓

4. Open Developer Console
5. Go to **Debug > Open Execute Anonymous Window**
6. Run:

```apex
SimpleExternalCallout.getRandomJoke();
```

7. Check the debug logs for the joke!

### Step 4: Run Tests

1. In Developer Console, go to **Test > Run All**
2. Or run specific test class: `SimpleIntegrationTest`
3. You should see 100% code coverage!

## 💡 Key Concepts Explained

### REST Endpoints

-   `@RestResource` - Makes a class available as REST API
-   `@HttpGet`, `@HttpPost`, `@HttpDelete` - Define HTTP methods
-   `global` - Required visibility for REST classes

### HTTP Callouts

-   `HttpRequest` - Builds the request
-   `Http` - Sends the request
-   `HttpResponse` - Contains the response
-   `@future(callout=true)` - Required for callouts from triggers

### Testing

-   `Test.setMock()` - Sets up mock responses
-   `HttpCalloutMock` - Interface for creating mocks
-   Real callouts are not allowed in tests!

## 🐛 Common Issues & Solutions

### "Unauthorized endpoint" Error

**Solution:** Add the URL to Remote Site Settings

### "Callout not allowed" Error

**Solution:** Use `@future(callout=true)` method

### "Read timed out" Error

**Solution:** Increase timeout: `request.setTimeout(120000);`

### Can't Test in Execute Anonymous

**Solution:** Callouts work in Execute Anonymous, but not in test methods

## 📖 Practice Exercises

1. **Modify the REST endpoint** to work with Accounts instead of Contacts
2. **Call a different API** - Try https://api.github.com/users/{username}
3. **Add error handling** - What happens if the contact doesn't exist?
4. **Create a batch class** that makes callouts (hint: implements Database.AllowsCallouts)

## 🔒 Security Reminders

-   **Never hardcode API keys** in your code
-   **Always validate** data from external sources
-   **Use Named Credentials** for production APIs
-   **Check permissions** before exposing data

## 📚 Additional Resources

-   [Apex REST Documentation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_rest.htm)
-   [HTTP Callouts Documentation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_callouts.htm)
-   [Testing HTTP Callouts](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing.htm)

## 🎯 Next Steps

After mastering these examples:

1. Learn about Named Credentials
2. Explore Platform Events for real-time integration
3. Study OAuth authentication flows
4. Consider middleware solutions like MuleSoft

Happy coding! 🚀
