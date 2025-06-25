/**
 * Anonymous Apex Script to Test Transaction Concepts
 * 
 * Copy and paste sections of this script into the Developer Console
 * Execute > Anonymous Apex window to test the different concepts
 * 
 * Make sure to check the debug logs to see the detailed output
 */

// ===== SECTION 1: BASIC TRANSACTION CONCEPTS =====
System.debug('========== TESTING BASIC TRANSACTION CONCEPTS ==========');

// Test basic transaction with multiple operations
TransactionBasicsDemo.basicTransactionExample();

System.debug('\n'); // Add space between tests

// Test transaction rollback behavior
try {
    TransactionBasicsDemo.transactionRollbackExample();
} catch (Exception e) {
    System.debug('Caught expected exception: ' + e.getMessage());
}

System.debug('\n');

// Test multiple methods in single transaction
TransactionBasicsDemo.multipleMethodsInTransaction();

System.debug('\n');

// Test query visibility within transaction
TransactionBasicsDemo.queryWithinTransaction();

System.debug('\n========== BASIC TRANSACTION TESTS COMPLETED ==========\n');


// ===== SECTION 2: STATIC VARIABLES IN TRANSACTIONS =====
System.debug('========== TESTING STATIC VARIABLES ==========');

// Test static variable persistence
StaticVariablesInTransactionDemo.demonstrateStaticVariablePersistence();

System.debug('\n');

// Test duplicate processing prevention
StaticVariablesInTransactionDemo.preventDuplicateProcessingExample();

System.debug('\n');

// Test trigger recursion prevention
StaticVariablesInTransactionDemo.triggerRecursionPreventionExample();

System.debug('\n');

// Test transaction counters
StaticVariablesInTransactionDemo.transactionCountersExample();

System.debug('\n========== STATIC VARIABLES TESTS COMPLETED ==========\n');


// ===== SECTION 3: GOVERNOR LIMITS MONITORING =====
System.debug('========== TESTING GOVERNOR LIMITS ==========');

// Test basic limit monitoring
GovernorLimitsDemo.basicLimitMonitoring();

System.debug('\n');

// Test limit-based decision making
GovernorLimitsDemo.limitBasedDecisionMaking();

System.debug('\n');

// Test CPU time management
GovernorLimitsDemo.cpuTimeManagement();

System.debug('\n');

// Test heap size monitoring
GovernorLimitsDemo.heapSizeMonitoring();

System.debug('\n');

// Test bulk operation limit checking
GovernorLimitsDemo.bulkOperationLimitChecking();

System.debug('\n');

// Get current limits summary
System.debug('CURRENT LIMITS SUMMARY:');
System.debug(GovernorLimitsDemo.getLimitsSummary());

System.debug('\n========== GOVERNOR LIMITS TESTS COMPLETED ==========\n');


// ===== SECTION 4: ASYNC APEX TRANSACTIONS =====
System.debug('========== TESTING ASYNC APEX TRANSACTIONS ==========');

// Test async transaction boundary
AsyncApexTransactionDemo.demonstrateAsyncTransactionBoundary();

System.debug('\n');

// Test governor limit async example
AsyncApexTransactionDemo.governorLimitAsyncExample();

System.debug('\n');

// Test job chaining
AsyncApexTransactionDemo.demonstrateJobChaining();

System.debug('\n========== ASYNC APEX TESTS COMPLETED ==========\n');


// ===== SECTION 5: WORKING ASYNC EXAMPLE =====
System.debug('========== TESTING WORKING ASYNC EXAMPLE ==========');

// Create a test account for async processing
Account asyncTestAccount = new Account(Name = 'Async Test Account - ' + DateTime.now());
insert asyncTestAccount;
System.debug('Created test account: ' + asyncTestAccount.Id);

// Enqueue different types of async work
// Note: These will run after the current transaction completes

SimpleAsyncWorker contactWorker = new SimpleAsyncWorker(asyncTestAccount.Id, 'CREATE_CONTACTS');
Id contactJobId = System.enqueueJob(contactWorker);
System.debug('Enqueued contact creation job: ' + contactJobId);

SimpleAsyncWorker oppWorker = new SimpleAsyncWorker(asyncTestAccount.Id, 'CREATE_OPPORTUNITIES');
Id oppJobId = System.enqueueJob(oppWorker);
System.debug('Enqueued opportunity creation job: ' + oppJobId);

SimpleAsyncWorker updateWorker = new SimpleAsyncWorker(asyncTestAccount.Id, 'UPDATE_ACCOUNT');
Id updateJobId = System.enqueueJob(updateWorker);
System.debug('Enqueued account update job: ' + updateJobId);

System.debug('\n========== ASYNC JOBS ENQUEUED ==========');
System.debug('Check the debug logs in a few minutes to see the async job execution');
System.debug('You can also check Setup > Apex Jobs to see the job status');

System.debug('\n========== ALL TRANSACTION TESTS COMPLETED ==========');

/**
 * STUDY NOTES:
 * 
 * 1. TRANSACTION BOUNDARIES:
 *    - This entire script runs in ONE synchronous transaction
 *    - All the demo methods execute within the same transaction
 *    - Only the async jobs create separate transactions
 * 
 * 2. STATIC VARIABLES:
 *    - Static variables persist across all method calls in this script
 *    - They reset between different executions of this script
 * 
 * 3. GOVERNOR LIMITS:
 *    - All operations in this script count toward the same limits
 *    - Watch how the limits increase as more operations are performed
 * 
 * 4. ASYNC EXECUTION:
 *    - The async jobs will execute AFTER this script completes
 *    - Each async job gets fresh governor limits
 *    - Check the debug logs separately for async job execution
 * 
 * 5. DEBUGGING TIPS:
 *    - Set debug log levels to FINEST for detailed output
 *    - Look for transaction start/end markers in the logs
 *    - Notice how static variables maintain their values
 *    - Observe governor limit consumption throughout execution
 */ 