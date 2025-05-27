/**
 * @description Demonstrates working with parent-child relationships in DML operations
 * @author Cloud Code Academy
 */
public with sharing class DMLRecordRelationshipsDemo {
    
    /**
     * @description Creates parent and child records using relationships
     * @return Map of created record IDs by type
     */
    public static Map<String, List<Id>> createRelatedRecords() {
        Map<String, List<Id>> createdIds = new Map<String, List<Id>>{
            'accounts' => new List<Id>(),
            'contacts' => new List<Id>(),
            'opportunities' => new List<Id>()
        };
        
        // First create and insert parent record
        Account parentAccount = new Account(
            Name = 'Parent Account',
            Industry = 'Technology',
            Description = 'Parent record for relationship demo'
        );
        insert parentAccount;
        createdIds.get('accounts').add(parentAccount.Id);
        
        System.debug('Created parent account: ' + parentAccount.Id);
        
        // Create child contacts referencing the parent account
        List<Contact> childContacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            Contact childContact = new Contact(
                FirstName = 'Contact',
                LastName = 'Child ' + i,
                Email = 'contact' + i + '@example.com',
                AccountId = parentAccount.Id  // Using the ID to create relationship
            );
            childContacts.add(childContact);
        }
        
        // Insert the child records
        insert childContacts;
        
        // Collect the child IDs
        for (Contact c : childContacts) {
            createdIds.get('contacts').add(c.Id);
        }
        
        System.debug('Created ' + childContacts.size() + ' child contacts');
        
        // Create related opportunities
        List<Opportunity> relatedOpps = new List<Opportunity>();
        for (Integer i = 0; i < 2; i++) {
            Opportunity opp = new Opportunity(
                Name = 'Opportunity ' + i,
                AccountId = parentAccount.Id,  // Link to the parent account
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = 10000 * (i + 1)
            );
            relatedOpps.add(opp);
        }
        
        // Insert the opportunities
        insert relatedOpps;
        
        // Collect the opportunity IDs
        for (Opportunity opp : relatedOpps) {
            createdIds.get('opportunities').add(opp.Id);
        }
        
        System.debug('Created ' + relatedOpps.size() + ' related opportunities');
        
        return createdIds;
    }
    
    /**
     * @description Updates parent and child records
     * @param accountId The parent Account ID
     */
    public static void updateRelatedRecords(Id accountId) {
        // Update the parent account
        Account parentAccount = new Account(
            Id = accountId,
            Description = 'Updated parent description'
        );
        update parentAccount;
        
        // Query child records
        List<Contact> childContacts = [SELECT Id, Title FROM Contact WHERE AccountId = :accountId];
        
        // Update the child records
        for (Contact c : childContacts) {
            c.Title = 'Updated Title';
        }
        
        // Single DML to update all contacts
        update childContacts;
        
        System.debug('Updated parent account and ' + childContacts.size() + ' child contacts');
    }
    
    /**
     * @description Demonstrates reparenting - moving child records to a different parent
     * @param accountId Current parent Account ID
     * @return ID of the new parent Account
     */
    public static Id reparentChildRecords(Id accountId) {
        // Create a new parent account
        Account newParentAccount = new Account(
            Name = 'New Parent Account',
            Industry = 'Healthcare'
        );
        insert newParentAccount;
        
        // Query child contacts to reparent
        List<Contact> contactsToReparent = [SELECT Id FROM Contact WHERE AccountId = :accountId];
        
        // Update the AccountId to point to the new parent
        for (Contact c : contactsToReparent) {
            c.AccountId = newParentAccount.Id;
        }
        
        // Update all contacts in a single DML statement
        update contactsToReparent;
        
        System.debug('Reparented ' + contactsToReparent.size() + ' contacts to new account: ' + newParentAccount.Id);
        
        return newParentAccount.Id;
    }
    
    /**
     * @description Demonstrates deleting parent and observing impact on children
     * @param accountId The Account ID to delete
     */
    public static void deleteParentRecord(Id accountId) {
        // First, query to see how many child records exist
        Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :accountId];
        Integer oppCount = [SELECT COUNT() FROM Opportunity WHERE AccountId = :accountId];
        
        System.debug('Before deletion - Account has: ' + contactCount + ' contacts and ' + oppCount + ' opportunities');
        
        // Delete the parent account
        delete new Account(Id = accountId);
        
        // Check what happened to the children
        try {
            // This will likely throw an exception if cascade delete occurred
            Integer remainingContacts = [SELECT COUNT() FROM Contact WHERE AccountId = :accountId];
            System.debug('Contacts remaining: ' + remainingContacts);
        } catch (Exception e) {
            System.debug('Error querying contacts: ' + e.getMessage());
        }
        
        System.debug('Parent account deleted. Check what happened to child records based on relationship behavior.');
    }
}