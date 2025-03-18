/**
 * FUTURE METHOD EXAMPLE
 * 
 * This example demonstrates:
 * - Basic @future method syntax
 * - Handling mixed DML operations
 * - Making callouts asynchronously
 * - Working within parameter restrictions
 */
public class ContactUtility {
    
    /**
     * Creates a Contact and then asynchronously creates a User for that Contact
     * to avoid mixed DML errors (Contact is standard object, User is setup object)
     */
    public static void createContactAndUser(String firstName, String lastName, String email, String profileId) {
        // Create the contact synchronously
        Contact newContact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email
        );
        insert newContact;
        
        // Call future method to create the user asynchronously
        createUserFromContact(newContact.Id, email, firstName, lastName, profileId);
        
        System.debug('Contact created synchronously. User will be created asynchronously.');
    }
    
    /**
     * @future method to create a User record for a Contact
     * Note: Parameters must be primitive types (no sObjects)
     */
    @future
    private static void createUserFromContact(Id contactId, String email, String firstName, String lastName, String profileId) {
        // Query for the contact again (can't pass sObject to future method)
        Contact cont = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId LIMIT 1];
        
        // Create username (must be unique)
        String username = email + '.' + System.currentTimeMillis() + '@example.com';
        
        try {
            // Create the user
            User newUser = new User(
                ContactId = contactId,
                Username = username,
                Email = email,
                FirstName = firstName,
                LastName = lastName,
                ProfileId = profileId,
                Alias = firstName.left(1) + lastName.left(4),
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles'
            );
            
            insert newUser;
            System.debug('User created successfully for contact: ' + contactId);
        } catch (Exception e) {
            System.debug('Error creating user: ' + e.getMessage());
            // In a real application, you would want to implement proper error handling
            // such as logging the error or creating a task for admin review
        }
    }
    
    /**
     * Example of a future method used for making callouts to external systems
     * The callout=true parameter is required for making HTTP callouts
     */
    @future(callout=true)
    public static void sendNotificationToExternalSystem(String recordId, String message) {
        // Prepare callout
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/notifications');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        
        // Create JSON payload
        Map<String, Object> payload = new Map<String, Object>{
            'recordId' => recordId,
            'message' => message,
            'timestamp' => System.now().getTime()
        };
        req.setBody(JSON.serialize(payload));
        
        try {
            // Make the callout
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            // Process response
            if (res.getStatusCode() == 200) {
                System.debug('Notification sent successfully');
            } else {
                System.debug('Error sending notification: ' + res.getStatus());
                System.debug('Response body: ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception during callout: ' + e.getMessage());
        }
    }
}