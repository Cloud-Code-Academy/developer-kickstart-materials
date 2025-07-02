/**
 * SimpleTriggerHandler - Lesson 8: Advanced Trigger Best Practices
 * 
 * This class demonstrates a basic trigger handler pattern.
 * It shows how to separate business logic from the trigger itself.
 * 
 * BEST PRACTICES DEMONSTRATED:
 * 1. Handler class contains all business logic
 * 2. Trigger only routes to handler methods
 * 3. Methods are testable in isolation
 * 4. Single responsibility principle
 * 5. Bulkification built-in
 * 
 * @author Cloud Code Academy
 * @since 2025
 */
public with sharing class SimpleTriggerHandler {


    public static Boolean stopTrigger = null;
    public String triggerName = null;
    
    /**
     * Handle before insert trigger event
     * @param newContacts List of new Contact records being inserted
     */
    public void handleBeforeInsert(List<Contact> newContacts) {
        if (stopTrigger == true) {
            System.debug('we did not run the trigger');
        } else {
            System.debug('=== SIMPLE HANDLER: Before Insert ===');
            System.debug(stopTrigger);
            // Delegate to specific methods for each piece of logic
            setDefaultValues(newContacts);
            generateEmailAddresses(newContacts);
            validateBusinessRules(newContacts);
        }
        
    }
    
    /**
     * Handle before update trigger event
     * @param newContacts List of Contact records with new values
     * @param oldContactMap Map of Contact records with old values
     */
    public void handleBeforeUpdate(List<Contact> newContacts, Map<Id, Contact> oldContactMap) {
        System.debug('=== SIMPLE HANDLER: Before Update ===');
        
        // Track changes
        trackFieldChanges(newContacts, oldContactMap);
        validateUpdateRules(newContacts, oldContactMap);
    }
    
    /**
     * Handle after insert trigger event
     * @param newContacts List of Contact records that were inserted
     */
    public void handleAfterInsert(List<Contact> newContacts) {
        System.debug('=== SIMPLE HANDLER: After Insert ===');
        
        // Perform post-insert operations
        createRelatedRecords(newContacts);
        sendWelcomeNotifications(newContacts);
    }
    
    /**
     * Handle after update trigger event
     * @param newContacts List of Contact records with new values
     * @param oldContactMap Map of Contact records with old values
     */
    public void handleAfterUpdate(List<Contact> newContacts, Map<Id, Contact> oldContactMap) {
        System.debug('=== SIMPLE HANDLER: After Update ===');
        
        // Perform post-update operations
        syncRelatedRecords(newContacts, oldContactMap);
    }
    
    // ========== PRIVATE HELPER METHODS ==========
    
    /**
     * Set default values for new contacts
     */
    private void setDefaultValues(List<Contact> contacts) {
        for (Contact c : contacts) {
            if (String.isBlank(c.FirstName)) {
                c.FirstName = 'Guest';
            }
            if (c.LeadSource == null) {
                c.LeadSource = 'Web';
            }
        }
        System.debug('Set default values for ' + contacts.size() + ' contacts');
    }
    
    /**
     * Generate email addresses based on name
     */
    private void generateEmailAddresses(List<Contact> contacts) {
        for (Contact c : contacts) {
            if (String.isBlank(c.Email) && String.isNotBlank(c.FirstName) && String.isNotBlank(c.LastName)) {
                c.Email = c.FirstName.toLowerCase() + '.' + c.LastName.toLowerCase() + '@demo.com';
            }
        }
        System.debug('Generated email addresses');
    }
    
    /**
     * Validate business rules before insert
     */
    private void validateBusinessRules(List<Contact> contacts) {
        for (Contact c : contacts) {
            if (c.Birthdate != null && c.Birthdate > Date.today()) {
                c.addError('Birthdate cannot be in the future');
            }
        }
        System.debug('Validated business rules');
    }
    
    /**
     * Track field changes during update
     */
    private void trackFieldChanges(List<Contact> newContacts, Map<Id, Contact> oldContactMap) {
        for (Contact c : newContacts) {
            Contact oldContact = oldContactMap.get(c.Id);
            
            if (c.Email != oldContact.Email) {
                c.Description = 'Email changed on ' + System.now();
                System.debug('Email changed for contact: ' + c.Id);
            }
            
            if (c.Phone != oldContact.Phone) {
                c.Description = 'Phone changed on ' + System.now();
                System.debug('Phone changed for contact: ' + c.Id);
            }
        }
    }
    
    /**
     * Validate update-specific rules
     */
    private void validateUpdateRules(List<Contact> newContacts, Map<Id, Contact> oldContactMap) {
        for (Contact c : newContacts) {
            Contact oldContact = oldContactMap.get(c.Id);
            
            // Example: Prevent email changes for contacts with 'VIP' in title
            if (String.isNotBlank(c.Title) && c.Title.containsIgnoreCase('VIP') && c.Email != oldContact.Email) {
                c.addError('Cannot change email for VIP contacts');
            }
        }
        System.debug('Validated update rules');
    }
    
    /**
     * Create related records after insert
     */
    private void createRelatedRecords(List<Contact> contacts) {
        List<Task> tasksToCreate = new List<Task>();
        
        for (Contact c : contacts) {
            // Create a welcome task for each new contact
            Task welcomeTask = new Task(
                Subject = 'Welcome ' + c.FirstName + ' ' + c.LastName,
                WhoId = c.Id,
                ActivityDate = Date.today().addDays(1),
                Priority = 'Normal',
                Status = 'Not Started'
            );
            tasksToCreate.add(welcomeTask);
        }
        
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
            System.debug('Created ' + tasksToCreate.size() + ' welcome tasks');
        }
    }
    
    /**
     * Send notifications for new contacts
     */
    private void sendWelcomeNotifications(List<Contact> contacts) {
        // In a real implementation, this might send emails or platform events
        System.debug('Would send welcome notifications for ' + contacts.size() + ' contacts');
    }
    
    /**
     * Sync changes to related records
     */
    private void syncRelatedRecords(List<Contact> newContacts, Map<Id, Contact> oldContactMap) {
        Set<Id> accountIds = new Set<Id>();
        
        // Collect accounts that need updating
        for (Contact c : newContacts) {
            Contact oldContact = oldContactMap.get(c.Id);
            
            if (c.AccountId != null && c.Email != oldContact.Email) {
                accountIds.add(c.AccountId);
            }
        }
        
        if (!accountIds.isEmpty()) {
            // Update account last activity date
            List<Account> accountsToUpdate = [
                SELECT Id, Description 
                FROM Account 
                WHERE Id IN :accountIds
            ];
            
            for (Account acc : accountsToUpdate) {
                acc.Description = 'Contact updated on ' + System.today();
            }
            
            update accountsToUpdate;
            System.debug('Updated ' + accountsToUpdate.size() + ' related accounts');
        }
    }
} 