/**
 * SimpleTriggerHandlerTest - Lesson 8: Advanced Trigger Best Practices
 * 
 * This test class demonstrates how to properly test trigger handlers.
 * It shows best practices for trigger testing including bulk operations.
 * 
 * TEST PRACTICES DEMONSTRATED:
 * 1. Test single record operations
 * 2. Test bulk operations
 * 3. Test positive and negative scenarios
 * 4. Use Test.startTest() and Test.stopTest()
 * 5. Use Assert class with meaningful messages
 * 
 * @author Cloud Code Academy
 * @since 2025
 */
@isTest
public class SimpleTriggerHandlerTest {
    
    /**
     * Test data setup method
     */
    @testSetup
    static void setupTestData() {
        // Create test accounts for contact tests
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(
                Name = 'Test Account ' + i,
                Type = 'Prospect'
            ));
        }
        insert testAccounts;
    }
    
    /**
     * Test before insert handler - single record
     */
    @isTest
    static void testBeforeInsert_SingleRecord() {
        // Given: A contact without FirstName
        Contact testContact = new Contact(
            LastName = 'TestLastName'
        );
        
        // When: Insert the contact
        Test.startTest();
        insert testContact;
        Test.stopTest();
        
        // Then: Default values should be set
        Contact result = [SELECT FirstName, Email, LeadSource FROM Contact WHERE Id = :testContact.Id];
        Assert.areEqual('Guest', result.FirstName, 'Default FirstName should be set to Guest');
        Assert.areEqual('guest.testlastname@demo.com', result.Email, 'Email should be generated');
        Assert.areEqual('Web', result.LeadSource, 'Default LeadSource should be Web');
    }
    
    /**
     * Test before insert handler - bulk records
     */
    @isTest
    static void testBeforeInsert_BulkRecords() {
        // Given: 200 contacts without FirstName
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            testContacts.add(new Contact(
                LastName = 'BulkTest' + i
            ));
        }
        
        // When: Insert contacts in bulk
        Test.startTest();
        insert testContacts;
        Test.stopTest();
        
        // Then: All contacts should have default values
        List<Contact> results = [SELECT FirstName, Email FROM Contact WHERE LastName LIKE 'BulkTest%'];
        Assert.areEqual(200, results.size(), 'Should have inserted 200 contacts');
        
        for (Contact c : results) {
            Assert.areEqual('Guest', c.FirstName, 'Each contact should have default FirstName');
            Assert.isNotNull(c.Email, 'Each contact should have generated email');
        }
    }
    
    /**
     * Test business rule validation
     */
    @isTest
    static void testBeforeInsert_ValidationRule() {
        // Given: A contact with future birthdate
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Future',
            Birthdate = Date.today().addDays(1)
        );
        
        // When: Try to insert the contact
        Test.startTest();
        try {
            insert testContact;
            Assert.fail('Should have thrown validation error for future birthdate');
        } catch (DmlException e) {
            // Then: Should get validation error
            Assert.isTrue(e.getMessage().contains('Birthdate cannot be in the future'), 
                         'Should have correct error message');
        }
        Test.stopTest();
    }
    
    /**
     * Test before update handler - field tracking
     */
    @isTest
    static void testBeforeUpdate_FieldTracking() {
        // Given: An existing contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Update',
            Email = 'test@example.com'
        );
        insert testContact;
        
        // When: Update the email
        Test.startTest();
        testContact.Email = 'newemail@example.com';
        update testContact;
        Test.stopTest();
        
        // Then: Email change should be tracked in description
        Contact result = [SELECT Description FROM Contact WHERE Id = :testContact.Id];
        Assert.isNotNull(result.Description, 'Description should be set when email changes');
        Assert.isTrue(result.Description.contains('Email changed'), 
                     'Description should indicate email was changed');
    }
    
    /**
     * Test after insert handler - related record creation
     */
    @isTest
    static void testAfterInsert_CreateRelatedRecords() {
        // Given: New contacts
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            testContacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact' + i
            ));
        }
        
        // When: Insert contacts
        Test.startTest();
        insert testContacts;
        Test.stopTest();
        
        // Then: Welcome tasks should be created
        List<Task> createdTasks = [
            SELECT Subject, WhoId 
            FROM Task 
            WHERE WhoId IN :testContacts
        ];
        Assert.areEqual(10, createdTasks.size(), 'Should create one task per contact');
        
        for (Task t : createdTasks) {
            Assert.isTrue(t.Subject.startsWith('Welcome'), 'Task subject should start with Welcome');
        }
    }
    
    /**
     * Test after update handler - sync related records
     */
    @isTest
    static void testAfterUpdate_SyncRelatedRecords() {
        // Given: Account and contact
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Sync',
            AccountId = testAccount.Id,
            Email = 'original@example.com'
        );
        insert testContact;
        
        // When: Update contact email
        Test.startTest();
        testContact.Email = 'updated@example.com';
        update testContact;
        Test.stopTest();
        
        // Then: Account should be updated
        Account updatedAccount = [SELECT Description FROM Account WHERE Id = :testAccount.Id];
        Assert.areEqual('Contact updated on ' + System.today(), updatedAccount.Description, 
                       'Account description should reflect contact update');
    }
    
    /**
     * Test VIP validation rule
     */
    @isTest
    static void testBeforeUpdate_VIPValidation() {
        // Given: A VIP contact (using Title to indicate VIP status)
        Contact vipContact = new Contact(
            FirstName = 'VIP',
            LastName = 'Customer',
            Email = 'vip@example.com',
            Title = 'VIP Customer'
        );
        insert vipContact;
        
        // When: Try to change VIP email
        Test.startTest();
        vipContact.Email = 'newemail@example.com';
        try {
            update vipContact;
            Assert.fail('Should not allow email change for VIP contacts');
        } catch (DmlException e) {
            // Then: Should get validation error
            Assert.isTrue(e.getMessage().contains('Cannot change email for VIP contacts'), 
                         'Should have correct VIP validation message');
        }
        Test.stopTest();
    }
    
    /**
     * Test governor limits with large data volumes
     */
    @isTest
    static void testGovernorLimits_LargeVolume() {
        // Given: Maximum number of contacts for governor limit testing
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 1000; i++) {
            testContacts.add(new Contact(
                LastName = 'GovernorTest' + i
            ));
        }
        
        // When: Insert all contacts
        Test.startTest();
        insert testContacts;
        Test.stopTest();
        
        // Then: All operations should complete within governor limits
        List<Contact> results = [SELECT Id FROM Contact WHERE LastName LIKE 'GovernorTest%'];
        Assert.areEqual(1000, results.size(), 'Should handle 1000 records within governor limits');
        
        // Verify tasks were created
        Integer taskCount = [SELECT COUNT() FROM Task WHERE Subject LIKE 'Welcome%'];
        Assert.areEqual(1000, taskCount, 'Should create tasks for all contacts');
    }
} 