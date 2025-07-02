/**
 * SimpleCalloutMock - Mock class for testing HTTP callouts
 * 
 * Why do we need mocks?
 * - Salesforce doesn't allow real HTTP callouts in test methods
 * - Mocks let us simulate external API responses
 * - We can test both success and failure scenarios
 * 
 * This class implements the HttpCalloutMock interface
 */
@isTest
public class SimpleCalloutMock implements HttpCalloutMock {
    
    // Variables to control the mock behavior
    private Integer statusCode;
    private String responseBody;
    private Map<String, String> responseHeaders;
    
    /**
     * Constructor - Set up the mock response
     * 
     * @param statusCode - HTTP status code (200, 404, 500, etc.)
     * @param responseBody - The body of the response
     */
    public SimpleCalloutMock(Integer statusCode, String responseBody) {
        this.statusCode = statusCode;
        this.responseBody = responseBody;
        this.responseHeaders = new Map<String, String>();
        this.responseHeaders.put('Content-Type', 'application/json');
    }
    
    /**
     * Required method from HttpCalloutMock interface
     * This method is called automatically when HTTP callout is made in test
     * 
     * @param request - The HTTP request being made
     * @return HttpResponse - Our mock response
     */
    public HttpResponse respond(HttpRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        
        // Set the status code
        response.setStatusCode(statusCode);
        
        // Set the body
        response.setBody(responseBody);
        
        // Set headers
        for (String key : responseHeaders.keySet()) {
            response.setHeader(key, responseHeaders.get(key));
        }
        
        // You can also inspect the request if needed
        System.debug('Mock received request to: ' + request.getEndpoint());
        System.debug('Request method: ' + request.getMethod());
        
        return response;
    }
    
    /**
     * Helper method to add custom headers
     */
    public void addHeader(String key, String value) {
        this.responseHeaders.put(key, value);
    }
}

/**
 * Additional mock class for testing specific scenarios
 * This one simulates a joke API response
 */
@isTest
public class JokeApiMock implements HttpCalloutMock {
    
    public HttpResponse respond(HttpRequest request) {
        // Create response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        
        // Create a fake joke response
        Map<String, Object> jokeData = new Map<String, Object>();
        jokeData.put('id', 123);
        jokeData.put('type', 'general');
        jokeData.put('setup', 'Why do programmers prefer dark mode?');
        jokeData.put('punchline', 'Because light attracts bugs!');
        
        // Convert to JSON
        String jsonBody = JSON.serialize(jokeData);
        response.setBody(jsonBody);
        
        return response;
    }
}

/**
 * Mock for testing error scenarios
 */
@isTest  
public class ErrorMock implements HttpCalloutMock {
    
    public HttpResponse respond(HttpRequest request) {
        // Simulate a server error
        HttpResponse response = new HttpResponse();
        response.setStatusCode(500);
        response.setBody('Internal Server Error');
        response.setHeader('Content-Type', 'text/plain');
        
        return response;
    }
} 