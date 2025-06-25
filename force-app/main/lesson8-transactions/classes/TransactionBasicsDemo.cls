/**
 * @description Demonstrates the basics of Apex Transactions
 * @author PD1 Study Session - Lesson 8
 * 
 * Key Concepts Covered:
 * 1. What is an Apex Transaction
 * 2. Transaction boundaries
 * 3. Multiple operations within a single transaction
 * 4. Rollback behavior on exceptions
 */
public class TransactionBasicsDemo {
    
    /**
     * @description Demonstrates a basic Apex transaction with multiple DML operations
     * All operations execute within a single transaction - either all succeed or all fail
     */
    public static void basicTransactionExample() {
        System.debug('=== BASIC TRANSACTION EXAMPLE ===');
        System.debug('Starting transaction...');
        
        try {
            // TRANSACTION BEGINS HERE
            // All the code below executes within ONE Apex transaction
            
            // Step 1: Create and insert an Account
            Account newAccount = new Account(
                Name = 'Transaction Demo Account',
                Type = 'Customer'
            );
            insert newAccount;
            System.debug('Account inserted with ID: ' + newAccount.Id);
            
            // Step 2: Create and insert a Contact related to the Account
            Contact newContact = new Contact(
                FirstName = 'John',
                LastName = 'Doe',
                AccountId = newAccount.Id,
                Email = 'john.doe@example.com'
            );
            insert newContact;
            System.debug('Contact inserted with ID: ' + newContact.Id);
            
            // Step 3: Create and insert an Opportunity
            Opportunity newOpportunity = new Opportunity(
                Name = 'Demo Opportunity',
                AccountId = newAccount.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            );
            insert newOpportunity;
            System.debug('Opportunity inserted with ID: ' + newOpportunity.Id);
            
            System.debug('All operations completed successfully!');
            // TRANSACTION COMMITS HERE (automatically when method completes successfully)
            
        } catch (Exception e) {
            // If ANY operation fails, the ENTIRE transaction is rolled back
            // None of the records will be saved to the database
            System.debug('Transaction failed and rolled back: ' + e.getMessage());
            throw e;
        }
    }
    
    /**
     * @description Demonstrates transaction rollback when an exception occurs
     * Shows how all operations in a transaction are undone if any operation fails
     */
    public static void transactionRollbackExample() {
        System.debug('=== TRANSACTION ROLLBACK EXAMPLE ===');
        
        try {
            // TRANSACTION BEGINS
            
            // Step 1: Successfully create an Account
            Account testAccount = new Account(Name = 'Test Account for Rollback');
            insert testAccount;
            System.debug('Account created: ' + testAccount.Id);
            
            // Step 2: Successfully create a Contact
            Contact testContact = new Contact(
                FirstName = 'Jane',
                LastName = 'Smith',
                AccountId = testAccount.Id
            );
            insert testContact;
            System.debug('Contact created: ' + testContact.Id);
            
            // Step 3: This will cause an exception (missing required fields)
            Opportunity badOpportunity = new Opportunity(
                Name = 'Bad Opportunity'
                // Missing required fields: StageName, CloseDate
            );
            insert badOpportunity; // This will throw an exception
            
        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
            System.debug('ENTIRE TRANSACTION ROLLED BACK!');
            System.debug('Account and Contact were NOT saved to database');
            // Even though Account and Contact inserts succeeded initially,
            // they are rolled back because the transaction failed
        }
    }
    
    /**
     * @description Demonstrates calling multiple methods within a single transaction
     * Shows how Method A -> Method B -> Method C all execute in the same transaction
     */
    public static void multipleMethodsInTransaction() {
        System.debug('=== MULTIPLE METHODS IN SINGLE TRANSACTION ===');
        System.debug('Starting main method...');
        
        // All method calls below happen within the SAME transaction
        methodA();
        
        System.debug('Main method completed - transaction will commit');
    }
    
    /**
     * @description Method A that calls Method B (part of transaction demo)
     */
    private static void methodA() {
        System.debug('Executing Method A');
        
        // Create an Account in Method A
        Account accountFromMethodA = new Account(Name = 'Account from Method A');
        insert accountFromMethodA;
        System.debug('Method A: Account inserted with ID: ' + accountFromMethodA.Id);
        
        // Method A calls Method B
        methodB(accountFromMethodA.Id);
        
        System.debug('Method A completed');
    }
    
    /**
     * @description Method B that calls Method C (part of transaction demo)
     * @param accountId The Account ID passed from Method A
     */
    private static void methodB(Id accountId) {
        System.debug('Executing Method B');
        
        // Create a Contact in Method B
        Contact contactFromMethodB = new Contact(
            FirstName = 'Method B',
            LastName = 'Contact',
            AccountId = accountId
        );
        insert contactFromMethodB;
        System.debug('Method B: Contact inserted with ID: ' + contactFromMethodB.Id);
        
        // Method B calls Method C
        methodC(accountId);
        
        System.debug('Method B completed');
    }
    
    /**
     * @description Method C (final method in the chain)
     * @param accountId The Account ID passed down from Method A
     */
    private static void methodC(Id accountId) {
        System.debug('Executing Method C');
        
        // Create an Opportunity in Method C
        Opportunity oppFromMethodC = new Opportunity(
            Name = 'Opportunity from Method C',
            AccountId = accountId,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert oppFromMethodC;
        System.debug('Method C: Opportunity inserted with ID: ' + oppFromMethodC.Id);
        
        System.debug('Method C completed');
        
        // IMPORTANT: Even though we have 3 different methods (A, B, C),
        // ALL DML operations happen within the SAME Apex transaction
        // If Method C fails, ALL records from Methods A, B, and C are rolled back
    }
    
    /**
     * @description Demonstrates what happens when you query records within the same transaction
     * Shows that uncommitted changes are visible within the transaction
     */
    public static void queryWithinTransaction() {
        System.debug('=== QUERY WITHIN TRANSACTION EXAMPLE ===');
        
        // Count accounts before transaction
        Integer accountCountBefore = [SELECT COUNT() FROM Account];
        System.debug('Account count before transaction: ' + accountCountBefore);
        
        // TRANSACTION BEGINS
        
        // Insert a new account
        Account newAccount = new Account(Name = 'Query Demo Account');
        insert newAccount;
        System.debug('Account inserted (but not yet committed)');
        
        // Query accounts within the same transaction
        // The newly inserted account IS visible in queries within the same transaction
        Integer accountCountDuring = [SELECT COUNT() FROM Account];
        System.debug('Account count during transaction: ' + accountCountDuring);
        System.debug('New account IS visible within the same transaction');
        
        // TRANSACTION COMMITS when method completes successfully
        System.debug('Transaction completed and committed');
    }
} 