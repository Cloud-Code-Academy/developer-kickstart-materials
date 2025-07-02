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
        
        // BAD: Multiple responsibilities mixed together
        for (Contact c : Trigger.new) {
            // Set default values
            if (String.isBlank(c.FirstName)) {
                c.FirstName = 'Guest';
            }
            
            if (c.LeadSource == null) {
                c.LeadSource = 'Web';
            }
            
            // Generate email if missing
            if (String.isBlank(c.Email) && String.isNotBlank(c.FirstName) && String.isNotBlank(c.LastName)) {
                c.Email = c.FirstName.toLowerCase() + '.' + c.LastName.toLowerCase() + '@demo.com';
            }
            
            // Validate birthdate
            if (c.Birthdate != null && c.Birthdate > Date.today()) {
                c.addError('Birthdate cannot be in the future');
            }
            
            // BAD: SOQL in loop - will hit governor limits with bulk data
            if (c.AccountId != null) {
                List<Account> accounts = [SELECT Type FROM Account WHERE Id = :c.AccountId];
                if (!accounts.isEmpty() && accounts[0].Type == 'Customer') {
                    c.Department = 'VIP Customer';
                }
            }
            
            // Format phone number
            if (String.isNotBlank(c.Phone)) {
                String cleaned = c.Phone.replaceAll('[^0-9]', '');
                if (cleaned.length() == 10) {
                    c.Phone = '(' + cleaned.substring(0, 3) + ') ' + 
                             cleaned.substring(3, 6) + '-' + 
                             cleaned.substring(6);
                }
            }
        }
    }
    
    // Before Update Logic
    if (Trigger.isBefore && Trigger.isUpdate) {
        System.debug('Processing before update...');
        
        // BAD: Duplicate logic - same validation as insert
        for (Contact c : Trigger.new) {
            Contact oldContact = Trigger.oldMap.get(c.Id);
            
            // Track email changes in description
            if (c.Email != oldContact.Email) {
                c.Description = 'Email changed on ' + System.now();
            }
            
            // Track phone changes in description
            if (c.Phone != oldContact.Phone) {
                c.Description = 'Phone changed on ' + System.now();
            }
            
            // BAD: Duplicate validation logic (should be reused)
            if (c.Birthdate != null && c.Birthdate > Date.today()) {
                c.addError('Birthdate cannot be in the future');
            }
            
            // VIP validation (using Title field)
            if (String.isNotBlank(c.Title) && c.Title.containsIgnoreCase('VIP') && c.Email != oldContact.Email) {
                c.addError('Cannot change email for VIP contacts');
            }
            
            // BAD: SOQL in loop again - same query as before insert!
            if (c.AccountId != null && c.AccountId != oldContact.AccountId) {
                List<Account> accounts = [SELECT Type FROM Account WHERE Id = :c.AccountId];
                if (!accounts.isEmpty() && accounts[0].Type == 'Customer') {
                    c.Department = 'VIP Customer';
                } else {
                    c.Department = 'Standard';
                }
            }
        }
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