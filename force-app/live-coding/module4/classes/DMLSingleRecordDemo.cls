/**
 * @description Demonstrates single record DML operations
 * @author Cloud Code Academy
 */
public with sharing class DMLSingleRecordDemo {
    
    /**
     * @description Demonstrates inserting a single record
     * @return The ID of the inserted record
     */
    public static Id insertSingleRecord() {
        // Create a new Contact record
        Contact newContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Doe',
            Email = 'jane.doe@example.com'
        );
        
        // Display the Contact before insert
        System.debug('Before insert: ' + newContact);
        
        // Insert the Contact
        insert newContact;
        
        // Display the Contact after insert - note the ID is now populated
        System.debug('After insert: ' + newContact);
        
        return newContact.Id;
    }
    
    /**
     * @description Demonstrates updating a single record
     * @param contactId The ID of the Contact to update
     */
    public static void updateSingleRecord(Id contactId) {
        // Method 1: Query the record first, then update
        Contact contactToUpdate = [SELECT Id, FirstName, LastName FROM Contact WHERE Id = :contactId LIMIT 1];
        contactToUpdate.LastName = 'Smith';
        
        // Update the record
        update contactToUpdate;
        System.debug('Updated contact using query: ' + contactToUpdate);
        
        // Method 2: Update a record using only its ID without querying
        Contact directUpdate = new Contact(
            Id = contactId,
            Title = 'Director',
            Department = 'Marketing'
        );
        
        update directUpdate;
        System.debug('Updated contact directly: ' + directUpdate);
    }
    
    /**
     * @description Demonstrates deleting a single record
     * @param contactId The ID of the Contact to delete
     */
    public static void deleteSingleRecord(Id contactId) {
        // Create a Contact instance with just the ID
        Contact contactToDelete = new Contact(Id = contactId);
        
        // Delete the Contact
        delete contactToDelete;
        
        // Verify deletion by trying to query
        List<Contact> remainingContacts = [SELECT Id FROM Contact WHERE Id = :contactId];
        System.debug('Contacts found after deletion: ' + remainingContacts.size());
    }
    
    /**
     * @description Demonstrates creating records with different field values
     */
    public static void createRecordsWithFields() {
        // Method 1: Create then set fields individually
        Account acc1 = new Account();
        acc1.Name = 'Test Account 1';
        acc1.Description = 'Created with individual field assignments';
        acc1.Industry = 'Technology';
        
        // Method 2: Set fields in constructor
        Account acc2 = new Account(
            Name = 'Test Account 2',
            Description = 'Created with constructor parameters',
            Industry = 'Healthcare'
        );
        
        // Insert both accounts
        List<Account> accounts = new List<Account>{acc1, acc2};
        insert accounts;
        
        System.debug('Inserted accounts: ' + accounts);
    }
} 