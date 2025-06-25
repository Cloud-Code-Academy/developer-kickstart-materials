/**
 * AccountTriggerHandler - Lesson 8: Advanced Trigger Best Practices
 * 
 * This class extends TriggerFramework to handle Account triggers.
 * It demonstrates how to implement a concrete handler using the framework.
 * 
 * FEATURES DEMONSTRATED:
 * 1. Extending the framework
 * 2. Implementing specific trigger events
 * 3. Proper bulkification
 * 4. Separation of concerns
 * 5. Testable methods
 * 
 * @author Cloud Code Academy
 * @since 2025
 */
public with sharing class AccountTriggerHandler extends TriggerFramework {
    
    // Class variables for storing data between methods
    private List<Account> newAccounts;
    private Map<Id, Account> oldAccountMap;
    private Map<Id, Account> newAccountMap;
    
    /**
     * Constructor - Initialize class variables
     */
    public AccountTriggerHandler() {
        this.newAccounts = (List<Account>) Trigger.new;
        this.oldAccountMap = (Map<Id, Account>) Trigger.oldMap;
        this.newAccountMap = (Map<Id, Account>) Trigger.newMap;
    }
    
    /**
     * Before Insert Handler
     */
    protected override void beforeInsert() {
        System.debug('AccountTriggerHandler.beforeInsert()');
        
        // Set default values
        setDefaultValues();
        
        // Validate data
        validateAccountData();
        
        // Format fields
        formatAccountFields();
    }
    
    /**
     * Before Update Handler
     */
    protected override void beforeUpdate() {
        System.debug('AccountTriggerHandler.beforeUpdate()');
        
        // Track field changes
        trackFieldChanges();
        
        // Validate updates
        validateAccountUpdates();
        
        // Update dependent fields
        updateDependentFields();
    }
    
    /**
     * After Insert Handler
     */
    protected override void afterInsert() {
        System.debug('AccountTriggerHandler.afterInsert()');
        
        // Create related records
        createDefaultContacts();
        
        // Send notifications
        sendNewAccountNotifications();
    }
    
    /**
     * After Update Handler
     */
    protected override void afterUpdate() {
        System.debug('AccountTriggerHandler.afterUpdate()');
        
        // Sync child records
        syncRelatedContacts();
        
        // Handle status changes
        handleStatusChanges();
    }
    
    // ========== PRIVATE HELPER METHODS ==========
    
    /**
     * Set default values for new accounts
     */
    private void setDefaultValues() {
        for (Account acc : newAccounts) {
            // Set default type if not specified
            if (String.isBlank(acc.Type)) {
                acc.Type = 'Prospect';
            }
            
            // Set default industry if not specified
            if (String.isBlank(acc.Industry)) {
                acc.Industry = 'Other';
            }
            
            // Set description with creation date
            if (String.isBlank(acc.Description)) {
                acc.Description = 'Account created on ' + System.today();
            }
        }
    }
    
    /**
     * Validate account data before insert
     */
    private void validateAccountData() {
        for (Account acc : newAccounts) {
            // Validate required custom fields
            if (String.isBlank(acc.AccountNumber) && acc.Type == 'Customer') {
                acc.addError('Account Number is required for Customer accounts');
            }
            
            // Validate business rules
            if (acc.AnnualRevenue != null && acc.AnnualRevenue < 0) {
                acc.addError('Annual Revenue cannot be negative');
            }
        }
    }
    
    /**
     * Format account fields consistently
     */
    private void formatAccountFields() {
        for (Account acc : newAccounts) {
            // Standardize website format
            if (String.isNotBlank(acc.Website) && !acc.Website.startsWithIgnoreCase('http')) {
                acc.Website = 'https://' + acc.Website;
            }
            
            // Format phone numbers
            if (String.isNotBlank(acc.Phone)) {
                acc.Phone = formatPhoneNumber(acc.Phone);
            }
        }
    }
    
    /**
     * Track field changes during update
     */
    private void trackFieldChanges() {
        for (Account acc : newAccounts) {
            Account oldAccount = oldAccountMap.get(acc.Id);
            
            // Track rating changes in description
            if (acc.Rating != oldAccount.Rating) {
                acc.Description = 'Rating changed from ' + oldAccount.Rating + ' to ' + acc.Rating + ' on ' + System.today();
            }
            
            // Track ownership changes in description
            if (acc.OwnerId != oldAccount.OwnerId) {
                if (String.isBlank(acc.Description)) {
                    acc.Description = 'Owner changed on ' + System.today();
                }
            }
        }
    }
    
    /**
     * Validate account updates
     */
    private void validateAccountUpdates() {
        for (Account acc : newAccounts) {
            Account oldAccount = oldAccountMap.get(acc.Id);
            
            // Prevent downgrade of customer type
            if (oldAccount.Type == 'Customer' && acc.Type == 'Prospect') {
                acc.addError('Cannot downgrade Customer accounts to Prospect');
            }
            
            // Validate type transitions
            if (oldAccount.Type == 'Customer' && acc.Type != 'Customer') {
                acc.addError('Cannot change type from Customer to another type');
            }
        }
    }
    
    /**
     * Update fields that depend on other field changes
     */
    private void updateDependentFields() {
        for (Account acc : newAccounts) {
            // Update rating based on annual revenue
            if (acc.AnnualRevenue != null) {
                if (acc.AnnualRevenue >= 1000000) {
                    acc.Rating = 'Hot';
                } else if (acc.AnnualRevenue >= 500000) {
                    acc.Rating = 'Warm';
                } else if (acc.AnnualRevenue >= 100000) {
                    acc.Rating = 'Cold';
                } else {
                    acc.Rating = null;
                }
            }
        }
    }
    
    /**
     * Create default contact for new accounts
     */
    private void createDefaultContacts() {
        List<Contact> contactsToCreate = new List<Contact>();
        
        for (Account acc : newAccounts) {
            // Only create default contact for certain types
            if (acc.Type == 'Customer' || acc.Type == 'Partner') {
                Contact defaultContact = new Contact(
                    FirstName = 'Primary',
                    LastName = 'Contact',
                    AccountId = acc.Id,
                    Email = 'primary@' + (String.isNotBlank(acc.Website) ? 
                           acc.Website.replace('https://', '').replace('http://', '') : 
                           'example.com')
                );
                contactsToCreate.add(defaultContact);
            }
        }
        
        if (!contactsToCreate.isEmpty()) {
            insert contactsToCreate;
            System.debug('Created ' + contactsToCreate.size() + ' default contacts');
        }
    }
    
    /**
     * Send notifications for new accounts
     */
    private void sendNewAccountNotifications() {
        // In a real implementation, this might send emails or chatter posts
        List<Task> tasksToCreate = new List<Task>();
        
        for (Account acc : newAccounts) {
            if (acc.Type == 'Customer') {
                Task welcomeTask = new Task(
                    Subject = 'Welcome new customer: ' + acc.Name,
                    WhatId = acc.Id,
                    OwnerId = acc.OwnerId,
                    ActivityDate = Date.today().addDays(1),
                    Priority = 'High',
                    Status = 'Not Started'
                );
                tasksToCreate.add(welcomeTask);
            }
        }
        
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
    
    /**
     * Sync data to related contacts after account update
     */
    private void syncRelatedContacts() {
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Account> accountsWithAddressChanges = new Map<Id, Account>();
        
        // Check for address changes
        for (Account acc : newAccounts) {
            Account oldAccount = oldAccountMap.get(acc.Id);
            
            if (acc.BillingStreet != oldAccount.BillingStreet ||
                acc.BillingCity != oldAccount.BillingCity ||
                acc.BillingState != oldAccount.BillingState ||
                acc.BillingPostalCode != oldAccount.BillingPostalCode ||
                acc.BillingCountry != oldAccount.BillingCountry) {
                
                accountsWithAddressChanges.put(acc.Id, acc);
                accountIds.add(acc.Id);
            }
        }
        
        // Update related contacts if addresses changed
        if (!accountIds.isEmpty()) {
            List<Contact> contactsToUpdate = [
                SELECT Id, AccountId, MailingStreet, MailingCity, 
                       MailingState, MailingPostalCode, MailingCountry
                FROM Contact
                WHERE AccountId IN :accountIds
                LIMIT 1
            ];
            
            for (Contact con : contactsToUpdate) {
                Account acc = accountsWithAddressChanges.get(con.AccountId);
                con.MailingStreet = acc.BillingStreet;
                con.MailingCity = acc.BillingCity;
                con.MailingState = acc.BillingState;
                con.MailingPostalCode = acc.BillingPostalCode;
                con.MailingCountry = acc.BillingCountry;
            }
            
            if (!contactsToUpdate.isEmpty()) {
                update contactsToUpdate;
                System.debug('Updated addresses for ' + contactsToUpdate.size() + ' contacts');
            }
        }
    }
    
    /**
     * Handle account status changes
     */
    private void handleStatusChanges() {
        List<Case> casesToCreate = new List<Case>();
        
        for (Account acc : newAccounts) {
            Account oldAccount = oldAccountMap.get(acc.Id);
            
            // Create case when account rating changes to Cold
            if (oldAccount.Rating != 'Cold' && acc.Rating == 'Cold') {
                Case inactiveCase = new Case(
                    Subject = 'Account Deactivated: ' + acc.Name,
                    AccountId = acc.Id,
                    Priority = 'High',
                    Status = 'New',
                    Type = 'Account Management',
                    Description = 'This account has been deactivated. Please review and take appropriate action.'
                );
                casesToCreate.add(inactiveCase);
            }
        }
        
        if (!casesToCreate.isEmpty()) {
            insert casesToCreate;
        }
    }
    
    /**
     * Helper method to format phone numbers
     */
    private String formatPhoneNumber(String phone) {
        // Remove all non-numeric characters
        String cleaned = phone.replaceAll('[^0-9]', '');
        
        // Format as (XXX) XXX-XXXX if US number
        if (cleaned.length() == 10) {
            return '(' + cleaned.substring(0, 3) + ') ' + 
                   cleaned.substring(3, 6) + '-' + 
                   cleaned.substring(6);
        }
        
        return phone; // Return original if not 10 digits
    }
} 