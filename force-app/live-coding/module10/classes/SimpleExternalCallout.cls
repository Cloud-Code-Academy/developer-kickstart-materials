/**
 * SimpleExternalCallout - A beginner-friendly HTTP callout example
 * 
 * This class shows how to call external APIs from Salesforce.
 * We'll use a free public API that doesn't require authentication.
 * 
 * Key Concepts:
 * - HttpRequest: Builds the request to send
 * - Http: Sends the request
 * - HttpResponse: Contains the response from the external system
 * - @future(callout=true): Required for making callouts from triggers
 * - Remote Site Settings: Must be configured in Setup
 */
public class SimpleExternalCallout {
    
    /**
     * Example 1: Simple GET request to fetch data
     * This method calls a free API to get a random joke
     * 
     * Before running: Add https://official-joke-api.appspot.com to Remote Site Settings
     */
    public static void getRandomJoke() {
        // Step 1: Create the request
        HttpRequest request = new HttpRequest();
        
        // Step 2: Set the endpoint (URL of the API)
        request.setEndpoint('https://official-joke-api.appspot.com/random_joke');
        
        // Step 3: Set the HTTP method (GET, POST, etc.)
        request.setMethod('GET');
        
        // Step 4: Set timeout (max 120 seconds in Salesforce)
        request.setTimeout(60000); // 60 seconds
        
        try {
            // Step 5: Send the request and get response
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            // Step 6: Check if request was successful
            if (response.getStatusCode() == 200) {
                // Success! Parse the response
                String responseBody = response.getBody();
                System.debug('Joke received: ' + responseBody);
                
                // Parse JSON response
                Map<String, Object> jokeData = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                String setup = (String) jokeData.get('setup');
                String punchline = (String) jokeData.get('punchline');
                
                System.debug('Setup: ' + setup);
                System.debug('Punchline: ' + punchline);
            } else {
                // Something went wrong
                System.debug('Error: HTTP ' + response.getStatusCode());
                System.debug('Error message: ' + response.getBody());
            }
            
        } catch (Exception e) {
            // Handle any errors (network issues, timeouts, etc.)
            System.debug('Callout failed: ' + e.getMessage());
        }
    }
    
    /**
     * Example 2: POST request with data
     * This simulates sending data to an external system
     * Uses @future for asynchronous execution (required from triggers)
     * 
     * @param contactId - The ID of a contact to send
     */
    @future(callout=true)
    public static void sendContactToExternalSystem(Id contactId) {
        // Get contact data
        Contact contactToSend = [SELECT Id, FirstName, LastName, Email 
                                FROM Contact 
                                WHERE Id = :contactId 
                                LIMIT 1];
        
        // Create the request
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://httpbin.org/post'); // Free test API
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(60000);
        
        // Create JSON body
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('firstName', contactToSend.FirstName);
        requestBody.put('lastName', contactToSend.LastName);
        requestBody.put('email', contactToSend.Email);
        requestBody.put('salesforceId', contactToSend.Id);
        
        // Convert to JSON string and set as body
        String jsonBody = JSON.serialize(requestBody);
        request.setBody(jsonBody);
        
        try {
            // Send the request
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            // Check response
            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                System.debug('Contact sent successfully!');
                System.debug('Response: ' + response.getBody());
            } else {
                System.debug('Failed to send contact. Status: ' + response.getStatusCode());
            }
            
        } catch (Exception e) {
            System.debug('Error sending contact: ' + e.getMessage());
            // In production, you might want to log this error or notify someone
        }
    }
    
    /**
     * Example 3: Handling authentication with API keys
     * Many APIs require authentication via headers
     */
    public static void callAuthenticatedAPI() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.example.com/data');
        request.setMethod('GET');
        
        // Add authentication header (API key example)
        // In production, store API keys in Custom Settings or Custom Metadata
        request.setHeader('Authorization', 'Bearer YOUR_API_KEY_HERE');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(60000);
        
        try {
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            // Process response...
            System.debug('Response: ' + response.getBody());
            
        } catch (Exception e) {
            System.debug('API call failed: ' + e.getMessage());
        }
    }
} 