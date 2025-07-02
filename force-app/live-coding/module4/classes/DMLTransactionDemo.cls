/**
 * @description Demonstrates transaction behavior in Apex DML operations
 * @author Cloud Code Academy
 */
public with sharing class DMLTransactionDemo {
    
    /**
     * @description Demonstrates a successful transaction with multiple DML operations
     * @return Map containing IDs of created records
     */
    public static Map<String, Id> successfulMultiDmlTransaction() {
        Map<String, Id> resultIds = new Map<String, Id>();
        
        // Start a new transaction with multiple DML operations
        // All of these operations will be part of the same transaction
        
        // 1. Create an Account
        Account acc = new Account(
            Name = 'Transaction Demo Account',
            Industry = 'Technology'
        );
        insert acc;
        resultIds.put('accountId', acc.Id);
        System.debug('Created Account: ' + acc.Id);
        
        // 2. Create a Contact related to the Account
        Contact con = new Contact(
            FirstName = 'Transaction',
            LastName = 'Demo',
            AccountId = acc.Id,
            Email = 'transaction.demo@example.com'
        );
        insert con;
        resultIds.put('contactId', con.Id);
        System.debug('Created Contact: ' + con.Id);
        
        // 3. Create an Opportunity related to the Account
        Opportunity opp = new Opportunity(
            Name = 'Transaction Demo Opportunity',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = 50000
        );
        insert opp;
        resultIds.put('opportunityId', opp.Id);
        System.debug('Created Opportunity: ' + opp.Id);
        
        System.debug('Transaction completed successfully with 3 DML operations');
        
        return resultIds;
    }
    
    /**
     * @description Demonstrates a transaction that fails because of an error
     * @return Boolean indicating if the transaction succeeded (should be false)
     */
    public static Boolean failedTransactionDemo() {
        Boolean transactionSucceeded = false;
        
        try {
            // 1. Create an Account
            Account acc = new Account(
                Name = 'Failed Transaction Demo',
                Industry = 'Technology'
            );
            insert acc;
            System.debug('Created Account: ' + acc.Id);
            
            // 2. Create a Contact related to the Account
            Contact con = new Contact(
                // Missing required LastName field - will cause failure
                FirstName = 'Will',
                AccountId = acc.Id,
                Email = 'will.fail@example.com'
            );
            insert con; // This will throw an exception
            System.debug('This line will not execute');
            
            // 3. This part will never execute because of the exception above
            transactionSucceeded = true;
        } catch (Exception e) {
            System.debug('Transaction failed with error: ' + e.getMessage());
            
            // Query to see if the Account was rolled back
            List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'Failed Transaction Demo'];
            System.debug('Accounts found after rollback: ' + accounts.size() + ' (should be 0 if transaction rolled back)');
        }
        
        return transactionSucceeded;
    }
    
    /**
     * @description Demonstrates a transaction with SavePoint and rollback
     * @return Map containing information about the transaction
     */
    public static Map<String, Object> savePointTransactionDemo() {
        Map<String, Object> results = new Map<String, Object>{
            'initialAccountCreated' => false,
            'firstSavePointReached' => false,
            'secondSavePointReached' => false,
            'finalState' => null
        };
        
        // Create an initial account
        Account initialAccount = new Account(Name = 'Initial Account');
        insert initialAccount;
        results.put('initialAccountCreated', true);
        results.put('initialAccountId', initialAccount.Id);
        
        // Set first savepoint after creating the initial account
        Savepoint sp1 = Database.setSavepoint();
        results.put('firstSavePointReached', true);
        
        try {
            // Create more accounts after the first savepoint
            Account secondAccount = new Account(Name = 'Second Account');
            insert secondAccount;
            
            // Set another savepoint
            Savepoint sp2 = Database.setSavepoint();
            results.put('secondSavePointReached', true);
            
            // Create an invalid account (missing required Name field)
            Account invalidAccount = new Account();
            insert invalidAccount; // This will cause an exception
            
            // This line won't execute
            System.debug('This line will not execute');
        } catch (Exception e) {
            // Roll back to the first savepoint
            Database.rollback(sp1);
            
            // Query to see what accounts exist after rollback
            List<Account> remainingAccounts = [SELECT Id, Name FROM Account 
                                            WHERE Name IN ('Initial Account', 'Second Account')];
            
            results.put('finalState', 'Rolled back to first savepoint');
            results.put('remainingAccounts', remainingAccounts);
            
            System.debug('Transaction partially rolled back. Remaining accounts: ' + remainingAccounts.size());
            for (Account acc : remainingAccounts) {
                System.debug('Remaining account: ' + acc.Name);
            }
        }
        
        return results;
    }
    
    /**
     * @description Demonstrates error handling within a transaction
     * @return Boolean indicating if all operations were successful
     */
    public static Boolean errorHandlingInTransaction() {
        Boolean allSuccessful = true;
        List<Account> successfulAccounts = new List<Account>();
        
        try {
            // Create some valid accounts
            List<Account> validAccounts = new List<Account>{
                new Account(Name = 'Valid Account 1'),
                new Account(Name = 'Valid Account 2')
            };
            
            // Insert the valid accounts
            insert validAccounts;
            successfulAccounts.addAll(validAccounts);
            System.debug('Successfully inserted valid accounts');
            
            // Try to create an invalid account, but handle the error
            try {
                Account invalidAccount = new Account(); // Missing required Name
                insert invalidAccount; // This will throw an exception
            } catch (DmlException innerE) {
                // Handle the error without failing the entire transaction
                System.debug('Handled inner exception: ' + innerE.getMessage());
                allSuccessful = false;
            }
            
            // Continue with more operations
            Account finalAccount = new Account(Name = 'Final Account');
            insert finalAccount;
            successfulAccounts.add(finalAccount);
            System.debug('Successfully inserted final account');
            
        } catch (Exception e) {
            System.debug('Outer transaction failed: ' + e.getMessage());
            allSuccessful = false;
        }
        
        System.debug('Transaction completed with allSuccessful=' + allSuccessful);
        System.debug('Created ' + successfulAccounts.size() + ' accounts successfully');
        
        return allSuccessful;
    }
} 