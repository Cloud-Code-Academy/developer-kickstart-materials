public with sharing class ContactTriggerHandler {
    public static void handleBeforeInsert(List<Contact> newContacts) {
        for (Contact c : newContacts) {
            // Set default values
            if (String.isBlank(c.FirstName)) {
                c.FirstName = 'Guest';
            }
        }
    }

    public static void handleBeforeUpdate(List<Contact> newContacts, Map<Id, Contact> oldMapContact) {

         for (Contact c : newContacts) {
            Contact oldContact = oldMapContact.get(c.Id);
            String firstName = c.FirstName;
            
            // Track email changes in description
            if (c.Email != oldContact.Email) {
                c.Description = 'Email changed on ' + System.now();
            }
        }
    }
}


/*
 * 
 * 
 * 
 *  if (Trigger.isBefore && Trigger.isInsert) {
        System.debug('Processing before insert...');
        List<Contact> newContact = Trigger.new;
        
        // BAD: Multiple responsibilities mixed together
        for (Contact c : newContact) {
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
    }*/