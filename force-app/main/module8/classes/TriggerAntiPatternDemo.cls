/**
 * TriggerAntiPatternDemo - Lesson 8: Advanced Trigger Best Practices
 * 
 * This class demonstrates WHAT NOT TO DO - anti-patterns in trigger development.
 * The instructor can use this to show problems with unstructured trigger logic.
 * 
 * ANTI-PATTERNS DEMONSTRATED:
 * 1. Business logic directly in trigger
 * 2. No separation of concerns
 * 3. Difficult to test
 * 4. Not reusable
 * 5. Hard to maintain
 * 
 * @author Cloud Code Academy
 * @since 2025
 */
public with sharing class TriggerAntiPatternDemo {
    
    /**
     * This method shows how triggers often start - with logic directly in the trigger.
     * INSTRUCTOR NOTE: Use this to demonstrate why this approach doesn't scale.
     */
    public static void demonstrateAntiPattern() {
        System.debug('=== ANTI-PATTERN DEMONSTRATION ===');
        System.debug('The following shows what NOT to do in triggers:');
        System.debug('1. Logic in trigger body');
        System.debug('2. No handler class');
        System.debug('3. Mixed responsibilities');
        System.debug('4. Difficult to unit test');
        
        // Show example of logic that would typically be in a trigger
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 5];
        
        // Anti-pattern: Direct manipulation without handler
        for (Contact c : contacts) {
            if (String.isBlank(c.FirstName)) {
                c.FirstName = 'Default';
            }
            if (String.isBlank(c.Email)) {
                c.Email = c.FirstName + '.' + c.LastName + '@example.com';
            }
        }
        
        System.debug('Modified contacts: ' + contacts);
    }
    
    /**
     * Demonstrates multiple anti-patterns that commonly appear in triggers
     */
    public static void demonstrateCommonMistakes() {
        System.debug('=== COMMON TRIGGER MISTAKES ===');
        
        // Anti-pattern 1: SOQL in loops
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10];
        for (Account acc : accounts) {
            // BAD: SOQL in loop
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
            System.debug('Account ' + acc.Name + ' has ' + contacts.size() + ' contacts');
        }
        
        // Anti-pattern 2: DML in loops
        List<Contact> contactsToUpdate = [SELECT Id, Title FROM Contact LIMIT 10];
        for (Contact c : contactsToUpdate) {
            c.Title = 'Updated';
            // BAD: DML in loop
            // update c; // Commented out to prevent actual DML
            System.debug('Would update contact: ' + c.Id);
        }
        
        // Anti-pattern 3: No bulkification
        System.debug('Imagine processing 200+ records with the above patterns!');
    }
    
    /**
     * Shows problems with testing triggers that have direct logic
     */
    public static void demonstrateTestingChallenges() {
        System.debug('=== TESTING CHALLENGES WITH ANTI-PATTERNS ===');
        System.debug('Problems with testing triggers that contain logic:');
        System.debug('1. Cannot test logic in isolation');
        System.debug('2. Must always perform DML to test');
        System.debug('3. Cannot mock or stub dependencies');
        System.debug('4. Difficult to test edge cases');
        System.debug('5. Test coverage becomes complex');
    }
} 