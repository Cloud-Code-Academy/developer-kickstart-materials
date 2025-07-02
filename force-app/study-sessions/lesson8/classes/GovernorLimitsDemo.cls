/**
 * @description Demonstrates how to query and monitor Governor Limits within Apex Transactions
 * @author PD1 Study Session - Lesson 8
 * 
 * Key Concepts Covered:
 * 1. Using the Limits class to monitor governor limits
 * 2. Checking limits before performing operations
 * 3. Making decisions based on current limit usage
 * 4. Practical examples of limit monitoring
 */
public class GovernorLimitsDemo {
    
    /**
     * @description Demonstrates basic governor limit monitoring
     * Shows how to check various limits during transaction execution
     */
    public static void basicLimitMonitoring() {
        System.debug('=== BASIC GOVERNOR LIMIT MONITORING ===');
        
        // Check limits at the start of the transaction
        displayCurrentLimits('Transaction Start');
        
        // Perform some SOQL queries
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10];
        displayCurrentLimits('After SOQL Query');
        
        // Perform some DML operations
        List<Contact> contactsToInsert = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            contactsToInsert.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact ' + i
            ));
        }
        insert contactsToInsert;
        displayCurrentLimits('After DML Operations');
        
        // Perform some CPU-intensive operations
        performCPUIntensiveWork();
        displayCurrentLimits('After CPU-Intensive Work');
    }
    
    /**
     * @description Displays current governor limit usage
     * @param context Description of when this check is being performed
     */
    private static void displayCurrentLimits(String context) {
        System.debug('--- ' + context + ' ---');
        
        // SOQL Limits
        System.debug('SOQL Queries: ' + Limits.getQueries() + ' / ' + Limits.getLimitQueries());
        System.debug('SOQL Query Rows: ' + Limits.getQueryRows() + ' / ' + Limits.getLimitQueryRows());
        
        // DML Limits
        System.debug('DML Statements: ' + Limits.getDMLStatements() + ' / ' + Limits.getLimitDMLStatements());
        System.debug('DML Rows: ' + Limits.getDMLRows() + ' / ' + Limits.getLimitDMLRows());
        
        // CPU Time Limit
        System.debug('CPU Time: ' + Limits.getCpuTime() + ' / ' + Limits.getLimitCpuTime() + ' ms');
        
        // Heap Size
        System.debug('Heap Size: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize() + ' bytes');
        
        // Callouts (if any)
        System.debug('Callouts: ' + Limits.getCallouts() + ' / ' + Limits.getLimitCallouts());
        
        System.debug(''); // Empty line for readability
    }
    
    /**
     * @description Demonstrates making decisions based on governor limits
     * Shows how to check limits before performing operations and adjust accordingly
     */
    public static void limitBasedDecisionMaking() {
        System.debug('=== LIMIT-BASED DECISION MAKING ===');
        
        // Create some test data first
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;
        
        // Now demonstrate limit-based processing
        processAccountsWithLimitChecking(testAccounts);
    }
    
    /**
     * @description Processes accounts while monitoring SOQL limits
     * @param accounts List of accounts to process
     */
    private static void processAccountsWithLimitChecking(List<Account> accounts) {
        System.debug('Processing ' + accounts.size() + ' accounts with limit checking...');
        
        Integer accountsProcessed = 0;
        List<Contact> contactsToCreate = new List<Contact>();
        
        for (Account acc : accounts) {
            // Check SOQL limits before performing queries
            if (Limits.getQueries() >= Limits.getLimitQueries() - 10) {
                System.debug('Approaching SOQL query limit! Stopping processing.');
                System.debug('Current queries: ' + Limits.getQueries() + ' / ' + Limits.getLimitQueries());
                break;
            }
            
            // Check if account has existing contacts (this uses a SOQL query)
            List<Contact> existingContacts = [
                SELECT Id FROM Contact 
                WHERE AccountId = :acc.Id 
                LIMIT 1
            ];
            
            // Only create contact if account doesn't have one
            if (existingContacts.isEmpty()) {
                contactsToCreate.add(new Contact(
                    FirstName = 'Auto',
                    LastName = 'Contact',
                    AccountId = acc.Id
                ));
            }
            
            accountsProcessed++;
            
            // Check DML limits before inserting
            if (contactsToCreate.size() >= 100 || 
                Limits.getDMLRows() >= Limits.getLimitDMLRows() - 100) {
                
                System.debug('Batch size reached or approaching DML limit. Inserting batch...');
                if (!contactsToCreate.isEmpty()) {
                    insert contactsToCreate;
                    System.debug('Inserted ' + contactsToCreate.size() + ' contacts');
                    contactsToCreate.clear();
                }
            }
        }
        
        // Insert any remaining contacts
        if (!contactsToCreate.isEmpty()) {
            insert contactsToCreate;
            System.debug('Inserted final batch of ' + contactsToCreate.size() + ' contacts');
        }
        
        System.debug('Successfully processed ' + accountsProcessed + ' accounts');
        displayCurrentLimits('After Account Processing');
    }
    
    /**
     * @description Demonstrates CPU time monitoring and management
     * Shows how to break up CPU-intensive work based on limits
     */
    public static void cpuTimeManagement() {
        System.debug('=== CPU TIME MANAGEMENT ===');
        
        displayCurrentLimits('Before CPU-Intensive Work');
        
        // Perform work in chunks, checking CPU time between chunks
        Integer totalIterations = 10000;
        Integer chunkSize = 1000;
        Integer completedIterations = 0;
        
        while (completedIterations < totalIterations) {
            // Check CPU time before starting next chunk
            Integer currentCpuTime = Limits.getCpuTime();
            Integer cpuLimit = Limits.getLimitCpuTime();
            
            if (currentCpuTime >= cpuLimit - 5000) { // Leave 5 seconds buffer
                System.debug('Approaching CPU time limit! Stopping work.');
                System.debug('CPU Time: ' + currentCpuTime + ' / ' + cpuLimit + ' ms');
                break;
            }
            
            // Perform a chunk of work
            Integer iterationsThisChunk = Math.min(chunkSize, totalIterations - completedIterations);
            performWorkChunk(iterationsThisChunk);
            completedIterations += iterationsThisChunk;
            
            System.debug('Completed ' + completedIterations + ' / ' + totalIterations + ' iterations');
            System.debug('Current CPU time: ' + Limits.getCpuTime() + ' ms');
        }
        
        displayCurrentLimits('After CPU-Intensive Work');
    }
    
    /**
     * @description Performs a chunk of CPU-intensive work
     * @param iterations Number of iterations to perform
     */
    private static void performWorkChunk(Integer iterations) {
        // Simulate CPU-intensive work
        for (Integer i = 0; i < iterations; i++) {
            // Some calculations that consume CPU time
            Double result = Math.sqrt(i * Math.random() * 1000);
            String stringWork = 'Processing iteration ' + i + ' with result ' + result;
            // String manipulation to consume more CPU
            stringWork = stringWork.toUpperCase().toLowerCase();
        }
    }
    
    /**
     * @description Demonstrates heap size monitoring
     * Shows how to monitor memory usage during large data operations
     */
    public static void heapSizeMonitoring() {
        System.debug('=== HEAP SIZE MONITORING ===');
        
        displayCurrentLimits('Before Large Data Operations');
        
        // Create progressively larger collections and monitor heap
        List<String> largeList = new List<String>();
        
        for (Integer i = 0; i < 5; i++) {
            // Add 1000 strings to the list
            for (Integer j = 0; j < 1000; j++) {
                largeList.add('This is a test string number ' + (i * 1000 + j) + 
                             ' with some additional text to increase memory usage');
            }
            
            System.debug('Added 1000 more strings. Total: ' + largeList.size());
            System.debug('Current heap size: ' + Limits.getHeapSize() + ' / ' + 
                        Limits.getLimitHeapSize() + ' bytes');
            
            // Check if we're approaching heap limit
            if (Limits.getHeapSize() >= Limits.getLimitHeapSize() * 0.8) {
                System.debug('Approaching heap size limit! Clearing some data...');
                largeList.clear();
                break;
            }
        }
        
        displayCurrentLimits('After Large Data Operations');
    }
    
    /**
     * @description Demonstrates practical limit checking for bulk operations
     * Shows how to use limits to determine batch sizes and processing strategies
     */
    public static void bulkOperationLimitChecking() {
        System.debug('=== BULK OPERATION LIMIT CHECKING ===');
        
        // Create test data
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name = 'Bulk Test Account ' + i));
        }
        insert accounts;
        
        // Process in batches based on current limits
        processBulkDataWithLimits(accounts);
    }
    
    /**
     * @description Processes bulk data while respecting governor limits
     * @param accounts List of accounts to process
     */
    private static void processBulkDataWithLimits(List<Account> accounts) {
        System.debug('Processing ' + accounts.size() + ' accounts in batches...');
        
        // Calculate safe batch size based on current limits
        Integer remainingQueries = Limits.getLimitQueries() - Limits.getQueries();
        Integer remainingDMLRows = Limits.getLimitDMLRows() - Limits.getDMLRows();
        
        // Use conservative batch size to avoid hitting limits
        Integer batchSize = Math.min(50, Math.min(remainingQueries - 10, remainingDMLRows / 2));
        
        System.debug('Calculated safe batch size: ' + batchSize);
        System.debug('Remaining SOQL queries: ' + remainingQueries);
        System.debug('Remaining DML rows: ' + remainingDMLRows);
        
        List<Contact> allContactsToInsert = new List<Contact>();
        Integer processedCount = 0;
        
        for (Integer i = 0; i < accounts.size(); i += batchSize) {
            // Check limits before each batch
            if (Limits.getQueries() >= Limits.getLimitQueries() - 5) {
                System.debug('Stopping - too close to SOQL limit');
                break;
            }
            
            // Get batch of accounts
            Integer endIndex = Math.min(i + batchSize, accounts.size());
            List<Account> accountBatch = new List<Account>();
            for (Integer j = i; j < endIndex; j++) {
                accountBatch.add(accounts[j]);
            }
            
            // Process batch
            List<Contact> batchContacts = processBatch(accountBatch, processedCount);
            allContactsToInsert.addAll(batchContacts);
            processedCount += accountBatch.size();
            
            System.debug('Processed batch ' + (i / batchSize + 1) + 
                        '. Total processed: ' + processedCount);
            displayCurrentLimits('After Batch ' + (i / batchSize + 1));
        }
        
        // Insert all contacts at once (more efficient)
        if (!allContactsToInsert.isEmpty()) {
            insert allContactsToInsert;
            System.debug('Inserted ' + allContactsToInsert.size() + ' contacts total');
        }
        
        displayCurrentLimits('Final Limits');
    }
    
    /**
     * @description Processes a batch of accounts
     * @param accountBatch Batch of accounts to process
     * @param batchNumber Batch number for naming
     * @return List of contacts to be inserted
     */
    private static List<Contact> processBatch(List<Account> accountBatch, Integer batchNumber) {
        List<Contact> contactsToCreate = new List<Contact>();
        
        for (Account acc : accountBatch) {
            // Create a contact for each account
            contactsToCreate.add(new Contact(
                FirstName = 'Batch ' + batchNumber,
                LastName = 'Contact for ' + acc.Name,
                AccountId = acc.Id
            ));
        }
        
        return contactsToCreate;
    }
    
    /**
     * @description Utility method to perform CPU-intensive work for demonstrations
     */
    private static void performCPUIntensiveWork() {
        // Simulate some CPU-intensive calculations
        for (Integer i = 0; i < 1000; i++) {
            Double calculation = Math.pow(i, 2) + Math.sqrt(i * 100);
            String stringWork = 'Result: ' + calculation;
            stringWork = stringWork.replace('Result:', 'Final Result:');
        }
    }
    
    /**
     * @description Gets a summary of all current limits in a readable format
     * @return String containing formatted limit information
     */
    public static String getLimitsSummary() {
        String summary = 'CURRENT GOVERNOR LIMITS SUMMARY:\n';
        summary += 'SOQL Queries: ' + Limits.getQueries() + ' / ' + Limits.getLimitQueries() + '\n';
        summary += 'SOQL Query Rows: ' + Limits.getQueryRows() + ' / ' + Limits.getLimitQueryRows() + '\n';
        summary += 'DML Statements: ' + Limits.getDMLStatements() + ' / ' + Limits.getLimitDMLStatements() + '\n';
        summary += 'DML Rows: ' + Limits.getDMLRows() + ' / ' + Limits.getLimitDMLRows() + '\n';
        summary += 'CPU Time: ' + Limits.getCpuTime() + ' / ' + Limits.getLimitCpuTime() + ' ms\n';
        summary += 'Heap Size: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize() + ' bytes\n';
        summary += 'Callouts: ' + Limits.getCallouts() + ' / ' + Limits.getLimitCallouts();
        
        return summary;
    }
} 