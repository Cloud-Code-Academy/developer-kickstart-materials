/**
 * ContactTriggerBad - Lesson 8: Advanced Trigger Best Practices
 * 
 * THIS IS A BAD EXAMPLE - DO NOT USE IN PRODUCTION!
 * 
 * This trigger demonstrates all the anti-patterns we want to avoid:
 * 1. All business logic directly in trigger
 * 2. No separation of concerns
 * 3. Mixed responsibilities
 * 4. SOQL in loops
 * 5. DML in loops (commented out to prevent issues)
 * 6. No bulkification
 * 7. Hard to test
 * 8. Hard to maintain
 * 9. Duplicate code
 * 10. No error handling
 * 
 * INSTRUCTOR NOTE: Use this as the starting point to refactor into proper handler pattern
 * 
 * @author Cloud Code Academy
 * @since 2025
 */
trigger ContactTriggerBad on Contact (before insert, before update, after insert, after update) {
    
    // BAD: All logic directly in trigger - no separation of concerns
    
    // Before Insert Logic
    if (Trigger.isBefore && Trigger.isInsert) {
        System.debug('Processing before insert...');
        List<Contact> newContacts = Trigger.new;
        
        ContactTriggerHandler.handleBeforeInsert(newContacts);
       
    }
    
    // Before Update Logic
    if (Trigger.isBefore && Trigger.isUpdate) {

        ContactTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    
    // After Insert Logic
    if (Trigger.isAfter && Trigger.isInsert) {
        System.debug('Processing after insert...');
        
        // BAD: No bulkification - creating lists inside loop
        for (Contact c : Trigger.new) {
            
            // Create welcome task for each contact individually
            List<Task> tasksToCreate = new List<Task>();
            Task welcomeTask = new Task(
                Subject = 'Welcome ' + c.FirstName + ' ' + c.LastName,
                WhoId = c.Id,
                ActivityDate = Date.today().addDays(1),
                Priority = 'Normal',
                Status = 'Not Started'
            );
            tasksToCreate.add(welcomeTask);
            
            // BAD: DML in loop - will hit governor limits
            // insert tasksToCreate; // Commented out to prevent issues in demo
            System.debug('Would insert task: ' + welcomeTask.Subject);
            
            // BAD: More SOQL in loops
            if (c.AccountId != null) {
                List<Contact> otherContacts = [SELECT Id FROM Contact WHERE AccountId = :c.AccountId AND Id != :c.Id];
                System.debug('Account has ' + otherContacts.size() + ' other contacts');
                
                // BAD: Nested loops with SOQL
                for (Contact otherContact : otherContacts) {
                    List<Task> existingTasks = [SELECT Id FROM Task WHERE WhoId = :otherContact.Id];
                    System.debug('Contact ' + otherContact.Id + ' has ' + existingTasks.size() + ' tasks');
                }
            }
        }
    }
    
    // After Update Logic
    if (Trigger.isAfter && Trigger.isUpdate) {
        System.debug('Processing after update...');
        
        // BAD: Complex logic mixed with data processing
        for (Contact c : Trigger.new) {
            Contact oldContact = Trigger.oldMap.get(c.Id);
            
            // Update account when contact email changes
            if (c.Email != oldContact.Email && c.AccountId != null) {
                
                // BAD: SOQL in loop
                List<Account> accountsToUpdate = [SELECT Id, Description FROM Account WHERE Id = :c.AccountId];
                
                if (!accountsToUpdate.isEmpty()) {
                    Account acc = accountsToUpdate[0];
                    acc.Description = 'Contact updated on ' + System.today();
                    
                    // BAD: DML in loop
                    // update acc; // Commented out to prevent issues
                    System.debug('Would update account: ' + acc.Id);
                }
            }
            
            // Send notification for lead source changes
            if (c.LeadSource != oldContact.LeadSource && c.LeadSource == 'Other') {
                
                // BAD: More SOQL in loop
                List<User> owners = [SELECT Email FROM User WHERE Id = :c.OwnerId];
                if (!owners.isEmpty()) {
                    System.debug('Would send email to: ' + owners[0].Email);
                    
                    // In real code, this would be email sending logic
                    // BAD: No error handling for email failures
                }
            }
        }
        
        // BAD: Separate loop doing similar work - should be combined
        for (Contact c : Trigger.new) {
            Contact oldContact = Trigger.oldMap.get(c.Id);
            
            if (c.AccountId != oldContact.AccountId) {
                System.debug('Contact moved to different account');
                
                // BAD: Yet another SOQL in loop
                if (c.AccountId != null) {
                    List<Account> newAccounts = [SELECT Name FROM Account WHERE Id = :c.AccountId];
                    if (!newAccounts.isEmpty()) {
                        System.debug('Moved to account: ' + newAccounts[0].Name);
                    }
                }
                
                if (oldContact.AccountId != null) {
                    List<Account> oldAccounts = [SELECT Name FROM Account WHERE Id = :oldContact.AccountId];
                    if (!oldAccounts.isEmpty()) {
                        System.debug('Moved from account: ' + oldAccounts[0].Name);
                    }
                }
            }
        }
    }
    
    // BAD: No error handling anywhere
    // BAD: No way to bypass trigger for data loads
    // BAD: No recursion prevention
    // BAD: Mixed indentation and formatting
    // BAD: No documentation of business rules
    // BAD: Hard-coded values everywhere
} 