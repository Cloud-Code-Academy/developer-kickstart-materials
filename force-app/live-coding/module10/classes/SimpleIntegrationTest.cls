/**
 * SimpleIntegrationTest - Test class for integration examples
 * 
 * This test class demonstrates:
 * - Testing REST endpoints
 * - Testing HTTP callouts with mocks
 * - Best practices for integration testing
 * 
 * Remember: Always use Assert class (not System.assert)
 * Always use Test.startTest() and Test.stopTest()
 */
@isTest
private class SimpleIntegrationTest {
    
    /**
     * Setup method - Creates test data
     * This runs before each test method
     */
    @TestSetup
    static void setupTestData() {
        // Create test contacts
        List<Contact> testContacts = new List<Contact>();
        
        for (Integer i = 0; i < 3; i++) {
            Contact c = new Contact(
                FirstName = 'Test',
                LastName = 'Contact ' + i,
                Email = 'test' + i + '@example.com'
            );
            testContacts.add(c);
        }
        
        insert testContacts;
    }
    
    /**
     * Test 1: Test REST endpoint GET method
     */
    @isTest
    static void testGetContacts() {
        // Set up REST request context
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/simpleAPI/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        Test.startTest();
        // Call the REST endpoint
        List<Contact> result = SimpleRestEndpoint.getContacts();
        Test.stopTest();
        
        // Verify results
        Assert.isNotNull(result, 'Result should not be null');
        Assert.isTrue(result.size() > 0, 'Should return at least one contact');
        Assert.isTrue(result.size() <= 10, 'Should not return more than 10 contacts');
    }
    
    /**
     * Test 2: Test REST endpoint POST method - Success scenario
     */
    @isTest
    static void testCreateContactSuccess() {
        // Set up REST request
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/simpleAPI/';
        request.httpMethod = 'POST';
        RestContext.request = request;
        
        Test.startTest();
        // Call the POST method
        String result = SimpleRestEndpoint.createContact('John', 'Doe', 'john@test.com');
        Test.stopTest();
        
        // Verify success
        Assert.isTrue(result.contains('Success!'), 'Should return success message');
        
        // Verify contact was created
        List<Contact> newContacts = [SELECT Id, FirstName, LastName, Email 
                                    FROM Contact 
                                    WHERE Email = 'john@test.com'];
        Assert.areEqual(1, newContacts.size(), 'Should create exactly one contact');
        Assert.areEqual('John', newContacts[0].FirstName, 'First name should match');
        Assert.areEqual('Doe', newContacts[0].LastName, 'Last name should match');
    }
    
    /**
     * Test 3: Test REST endpoint DELETE method
     */
    @isTest
    static void testDeleteContact() {
        // Get a test contact
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        // Set up REST request with contact ID in URL
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/simpleAPI/' + testContact.Id;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        
        Test.startTest();
        // Call the DELETE method
        String result = SimpleRestEndpoint.deleteContact();
        Test.stopTest();
        
        // Verify success message
        Assert.isTrue(result.contains('Success!'), 'Should return success message');
        
        // Verify contact was deleted
        List<Contact> deletedContacts = [SELECT Id FROM Contact WHERE Id = :testContact.Id];
        Assert.areEqual(0, deletedContacts.size(), 'Contact should be deleted');
    }
    
    /**
     * Test 4: Test external callout - Success scenario
     * Uses mock to simulate API response
     */
    @isTest
    static void testGetRandomJokeSuccess() {
        // Set up the mock
        Test.setMock(HttpCalloutMock.class, new JokeApiMock());
        
        Test.startTest();
        // Call the method that makes the callout
        SimpleExternalCallout.getRandomJoke();
        Test.stopTest();
        
        // Since this method only does System.debug, we can't assert much
        // In real scenarios, you'd return values or update records to verify
        // This test mainly ensures no exceptions are thrown
        Assert.isTrue(true, 'Method should complete without errors');
    }
    
    /**
     * Test 5: Test external callout - Error scenario
     */
    @isTest
    static void testGetRandomJokeError() {
        // Set up error mock
        Test.setMock(HttpCalloutMock.class, new ErrorMock());
        
        Test.startTest();
        // Call the method - should handle error gracefully
        SimpleExternalCallout.getRandomJoke();
        Test.stopTest();
        
        // Verify no unhandled exceptions
        Assert.isTrue(true, 'Method should handle errors gracefully');
    }
    
    /**
     * Test 6: Test @future callout method
     * Tests sending contact data to external system
     */
    @isTest
    static void testSendContactToExternalSystem() {
        // Get test contact
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        // Set up mock for successful response
        SimpleCalloutMock mock = new SimpleCalloutMock(200, '{"status": "received"}');
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        // Call the @future method
        SimpleExternalCallout.sendContactToExternalSystem(testContact.Id);
        Test.stopTest();
        
        // Future methods execute after Test.stopTest()
        // In real scenarios, you might update the contact with sync status
        // and verify that here
        Assert.isTrue(true, 'Future method should complete successfully');
    }
    
    /**
     * Test 7: Test callout with custom mock
     * Shows how to use the flexible SimpleCalloutMock
     */
    @isTest
    static void testCalloutWithCustomMock() {
        // Create custom response
        Map<String, Object> responseData = new Map<String, Object>();
        responseData.put('status', 'success');
        responseData.put('data', new List<String>{'item1', 'item2'});
        
        String jsonResponse = JSON.serialize(responseData);
        
        // Set up mock with custom response
        SimpleCalloutMock mock = new SimpleCalloutMock(200, jsonResponse);
        mock.addHeader('X-Custom-Header', 'TestValue');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        // Make a callout (using the authenticated API example)
        SimpleExternalCallout.callAuthenticatedAPI();
        Test.stopTest();
        
        // Verify execution completes
        Assert.isTrue(true, 'Callout should complete with custom mock');
    }
} 