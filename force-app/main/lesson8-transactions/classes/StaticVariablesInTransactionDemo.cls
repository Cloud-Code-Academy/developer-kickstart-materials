/**
 * @description Demonstrates how static variables behave within Apex Transactions
 * @author PD1 Study Session - Lesson 8
 * 
 * Key Concepts Covered:
 * 1. Static variables persist for the lifetime of a transaction
 * 2. Static variables are shared across all method calls within the same transaction
 * 3. Static variables are reset when a new transaction begins
 * 4. Practical use cases for static variables in transactions
 */
public class StaticVariablesInTransactionDemo {
    
    // Static variables - these persist for the ENTIRE transaction lifetime
    private static Integer callCounter = 0;
    private static List<String> executionLog = new List<String>();
    private static Boolean hasProcessedRecords = false;
    private static Set<Id> processedAccountIds = new Set<Id>();
    
    /**
     * @description Demonstrates basic static variable behavior in transactions
     * Shows how static variables maintain their values across method calls
     */
    public static void demonstrateStaticVariablePersistence() {
        System.debug('=== STATIC VARIABLE PERSISTENCE DEMO ===');
        
        // TRANSACTION BEGINS HERE
        
        // Reset static variables for this demo
        resetStaticVariables();
        
        System.debug('Initial call counter: ' + callCounter);
        System.debug('Initial execution log size: ' + executionLog.size());
        
        // Call multiple methods - static variables will persist across all calls
        methodOne();
        methodTwo();
        methodThree();
        
        // Display final state of static variables
        System.debug('Final call counter: ' + callCounter);
        System.debug('Final execution log: ' + executionLog);
        System.debug('Static variables persisted throughout the entire transaction!');
        
        // TRANSACTION ENDS when this method completes
        // Static variables will be reset for the next transaction
    }
    
    /**
     * @description Method One - increments counter and adds to log
     */
    private static void methodOne() {
        callCounter++; // Static variable persists and increments
        executionLog.add('Method One executed at call #' + callCounter);
        System.debug('Method One: Call counter is now ' + callCounter);
    }
    
    /**
     * @description Method Two - increments counter and adds to log
     */
    private static void methodTwo() {
        callCounter++; // Static variable continues to persist
        executionLog.add('Method Two executed at call #' + callCounter);
        System.debug('Method Two: Call counter is now ' + callCounter);
    }
    
    /**
     * @description Method Three - increments counter and adds to log
     */
    private static void methodThree() {
        callCounter++; // Static variable still persists
        executionLog.add('Method Three executed at call #' + callCounter);
        System.debug('Method Three: Call counter is now ' + callCounter);
    }
    
    /**
     * @description Demonstrates a practical use case: preventing duplicate processing
     * Uses static variables to track what has already been processed in this transaction
     */
    public static void preventDuplicateProcessingExample() {
        System.debug('=== PREVENT DUPLICATE PROCESSING EXAMPLE ===');
        
        // TRANSACTION BEGINS
        
        // Reset for demo purposes
        processedAccountIds.clear();
        hasProcessedRecords = false;
        
        // Simulate processing the same accounts multiple times in one transaction
        List<Id> accountBatch1 = new List<Id>();
        List<Id> accountBatch2 = new List<Id>();
        
        // Create some test accounts first
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;
        
        // Add account IDs to our batches (with some overlap)
        accountBatch1.add(testAccounts[0].Id);
        accountBatch1.add(testAccounts[1].Id);
        
        accountBatch2.add(testAccounts[1].Id); // Duplicate!
        accountBatch2.add(testAccounts[2].Id);
        
        // Process batches - static variable prevents duplicate processing
        processAccountBatch(accountBatch1, 'Batch 1');
        processAccountBatch(accountBatch2, 'Batch 2');
        
        System.debug('Final processed account IDs: ' + processedAccountIds);
        System.debug('Total unique accounts processed: ' + processedAccountIds.size());
        
        // TRANSACTION ENDS - static variables will be reset for next transaction
    }
    
    /**
     * @description Processes a batch of accounts, using static variables to prevent duplicates
     * @param accountIds List of Account IDs to process
     * @param batchName Name of the batch for logging
     */
    private static void processAccountBatch(List<Id> accountIds, String batchName) {
        System.debug('Processing ' + batchName + ' with ' + accountIds.size() + ' accounts');
        
        Integer newAccountsProcessed = 0;
        
        for (Id accountId : accountIds) {
            // Check if we've already processed this account in this transaction
            if (!processedAccountIds.contains(accountId)) {
                // Process the account (simulate some work)
                System.debug('Processing new account: ' + accountId);
                processedAccountIds.add(accountId); // Track in static variable
                newAccountsProcessed++;
                
                // Simulate some processing work
                // In real code, this might be updating fields, sending emails, etc.
                
            } else {
                System.debug('Skipping already processed account: ' + accountId);
            }
        }
        
        System.debug(batchName + ' completed. New accounts processed: ' + newAccountsProcessed);
        hasProcessedRecords = true; // Mark that we've done some work
    }
    
    /**
     * @description Demonstrates static variables in trigger context
     * Shows how static variables can prevent recursive trigger execution
     */
    public static void triggerRecursionPreventionExample() {
        System.debug('=== TRIGGER RECURSION PREVENTION EXAMPLE ===');
        
        // This pattern is commonly used in trigger handlers
        // Static variable tracks if trigger logic has already run
        
        if (!hasProcessedRecords) {
            System.debug('First time running trigger logic in this transaction');
            hasProcessedRecords = true; // Set flag to prevent recursion
            
            // Simulate trigger logic that might cause recursion
            simulateTriggerLogic();
            
        } else {
            System.debug('Trigger logic already ran in this transaction - preventing recursion');
        }
    }
    
    /**
     * @description Simulates trigger logic that might cause recursion
     */
    private static void simulateTriggerLogic() {
        System.debug('Executing trigger logic...');
        
        // Create an account
        Account triggerAccount = new Account(Name = 'Trigger Test Account');
        insert triggerAccount;
        
        // Update the account (this might trigger the same trigger again)
        triggerAccount.Description = 'Updated by trigger';
        update triggerAccount;
        
        System.debug('Trigger logic completed');
        
        // If this method calls itself or triggers run again,
        // the static variable prevents infinite recursion
    }
    
    /**
     * @description Demonstrates static variables for transaction-wide counters and limits
     * Shows how to track operations across the entire transaction
     */
    public static void transactionCountersExample() {
        System.debug('=== TRANSACTION COUNTERS EXAMPLE ===');
        
        // Reset counters for demo
        callCounter = 0;
        executionLog.clear();
        
        // Simulate multiple operations that need to be tracked
        performDMLOperations('Operation Set 1');
        performDMLOperations('Operation Set 2');
        performDMLOperations('Operation Set 3');
        
        // Display transaction summary
        System.debug('Transaction Summary:');
        System.debug('Total operation sets: ' + callCounter);
        System.debug('Execution log: ' + executionLog);
    }
    
    /**
     * @description Performs DML operations and tracks them with static variables
     * @param operationName Name of the operation set
     */
    private static void performDMLOperations(String operationName) {
        callCounter++; // Track how many operation sets we've run
        executionLog.add(operationName + ' - Call #' + callCounter);
        
        System.debug('Performing ' + operationName);
        
        // Simulate some DML operations
        Account tempAccount = new Account(Name = operationName + ' Account');
        insert tempAccount;
        
        System.debug(operationName + ' completed');
    }
    
    /**
     * @description Utility method to reset static variables for demo purposes
     * In real code, you typically wouldn't need this as variables reset between transactions
     */
    private static void resetStaticVariables() {
        callCounter = 0;
        executionLog.clear();
        hasProcessedRecords = false;
        processedAccountIds.clear();
    }
    
    /**
     * @description Getter methods to access static variables (for testing or debugging)
     */
    public static Integer getCallCounter() {
        return callCounter;
    }
    
    public static List<String> getExecutionLog() {
        return executionLog.clone(); // Return a copy to prevent external modification
    }
    
    public static Boolean getHasProcessedRecords() {
        return hasProcessedRecords;
    }
    
    public static Set<Id> getProcessedAccountIds() {
        return processedAccountIds.clone(); // Return a copy
    }
} 