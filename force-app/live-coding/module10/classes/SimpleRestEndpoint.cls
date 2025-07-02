/**
 * SimpleRestEndpoint - A beginner-friendly REST API endpoint
 * 
 * This class shows how to expose Salesforce data to external systems
 * using REST web services. External apps can call these endpoints.
 * 
 * URL Pattern: /services/apexrest/simpleAPI/*
 * 
 * Key Concepts:
 * - @RestResource: Makes this class available as a REST endpoint
 * - @HttpGet, @HttpPost, @HttpDelete: Define which HTTP methods to handle
 * - global: Required visibility for REST endpoints
 */
@RestResource(urlMapping='/simpleAPI/*')
global class SimpleRestEndpoint {
    
    /**
     * GET Method - Retrieve data from Salesforce
     * Example: GET /services/apexrest/simpleAPI/
     * Returns: List of contacts (maximum 10 for simplicity)
     */
    @HttpGet
    global static List<Contact> getContacts() {
        // Simple query to get contacts
        // In real projects, add WHERE clauses for security
        return [SELECT Id, FirstName, LastName, Email 
                FROM Contact 
                LIMIT 10];
    }
    
    /**
     * POST Method - Create new data in Salesforce
     * Example: POST /services/apexrest/simpleAPI/
     * Body: {"firstName": "John", "lastName": "Doe", "email": "john@example.com"}
     * Returns: Success or error message
     */
    @HttpPost
    global static String createContact(String firstName, String lastName, String email) {
        // Always use try-catch for DML operations
        try {
            // Create a new contact
            Contact newContact = new Contact();
            newContact.FirstName = firstName;
            newContact.LastName = lastName;
            newContact.Email = email;
            
            // Insert the contact
            insert newContact;
            
            // Return success message with the new record ID
            return 'Success! Contact created with ID: ' + newContact.Id;
            
        } catch (Exception e) {
            // Return error message if something goes wrong
            return 'Error creating contact: ' + e.getMessage();
        }
    }
    
    /**
     * DELETE Method - Remove data from Salesforce
     * Example: DELETE /services/apexrest/simpleAPI/003xx000004TMM2
     * The contact ID is extracted from the URL
     * Returns: Success or error message
     */
    @HttpDelete
    global static String deleteContact() {
        // Get the full URL from the request
        RestRequest request = RestContext.request;
        String fullUrl = request.requestURI;
        
        // Extract the contact ID from the URL (after the last /)
        // Example: /services/apexrest/simpleAPI/003xx000004TMM2
        String contactId = fullUrl.substring(fullUrl.lastIndexOf('/') + 1);
        
        try {
            // Find the contact to delete
            Contact contactToDelete = [SELECT Id FROM Contact WHERE Id = :contactId LIMIT 1];
            
            // Delete the contact
            delete contactToDelete;
            
            return 'Success! Contact deleted.';
            
        } catch (Exception e) {
            // Return error if contact not found or delete fails
            return 'Error deleting contact: ' + e.getMessage();
        }
    }
} 