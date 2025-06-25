/**
 * @description Demonstrates Asynchronous Apex and how it creates separate transactions
 * @author PD1 Study Session - Lesson 8
 * 
 * Key Concepts Covered:
 * 1. How asynchronous Apex creates separate transactions
 * 2. Using async Apex when approaching governor limits
 * 3. Queueable Apex for handling remaining work
 * 4. Relationship between synchronous and asynchronous transactions
 */
public class AsyncApexTransactionDemo {
    
    /**
     * @description Demonstrates how async Apex creates a separate transaction
     * Shows the boundary between synchronous and asynchronous execution
     */
    public static void demonstrateAsyncTransactionBoundary() {
        System.debug('=== ASYNC TRANSACTION BOUNDARY DEMO ===');
        System.debug('SYNCHRONOUS TRANSACTION BEGINS');
        
        // This is all part of the FIRST (synchronous) transaction
        Account syncAccount = new Account(Name = 'Synchronous Account');
        insert syncAccount;
        System.debug('Synchronous account created: ' + syncAccount.Id);
        
        // Create some contacts synchronously
        List<Contact> syncContacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            syncContacts.add(new Contact(
                FirstName = 'Sync',
                LastName = 'Contact ' + i,
                AccountId = syncAccount.Id
            ));
        }
        insert syncContacts;
        System.debug('Synchronous contacts created: ' + syncContacts.size());
        
        // Enqueue asynchronous work - this will run in a SEPARATE transaction
        System.debug('Enqueuing asynchronous work...');
        // Note: AsyncWorkerQueueable would be in a separate file in a real implementation
        System.debug('Would enqueue AsyncWorkerQueueable for account: ' + syncAccount.Id);
        System.debug('Async job would run in separate transaction with fresh limits');
        
        System.debug('SYNCHRONOUS TRANSACTION ENDS');
        // The synchronous transaction commits here
        // The asynchronous transaction will start later
    }
    
    /**
     * @description Demonstrates using async Apex when approaching governor limits
     * Shows practical decision-making based on current limit usage
     */
    public static void governorLimitAsyncExample() {
        System.debug('=== GOVERNOR LIMIT ASYNC EXAMPLE ===');
        
        // Create a large number of accounts to process
        List<Account> accountsToProcess = new List<Account>();
        for (Integer i = 0; i < 150; i++) {
            accountsToProcess.add(new Account(Name = 'Limit Test Account ' + i));
        }
        insert accountsToProcess;
        System.debug('Created ' + accountsToProcess.size() + ' accounts to process');
        
        // Process accounts with limit checking
        processAccountsWithLimitHandling(accountsToProcess);
    }
    
    /**
     * @description Processes accounts and uses async Apex when approaching limits
     * @param accounts List of accounts to process
     */
    private static void processAccountsWithLimitHandling(List<Account> accounts) {
        System.debug('Processing accounts with limit handling...');
        
        List<Contact> contactsToCreate = new List<Contact>();
        List<Account> remainingAccounts = new List<Account>();
        Integer processedCount = 0;
        
        for (Account acc : accounts) {
            // Check SOQL query limits
            if (Limits.getQueries() >= Limits.getLimitQueries() - 20) {
                System.debug('Approaching SOQL limit! Current: ' + Limits.getQueries() + 
                           ' / ' + Limits.getLimitQueries());
                System.debug('Moving remaining ' + (accounts.size() - processedCount) + 
                           ' accounts to async processing');
                
                // Add remaining accounts to async processing list
                for (Integer i = processedCount; i < accounts.size(); i++) {
                    remainingAccounts.add(accounts[i]);
                }
                break;
            }
            
            // Process this account (uses a SOQL query)
            List<Contact> existingContacts = [
                SELECT Id FROM Contact 
                WHERE AccountId = :acc.Id 
                LIMIT 1
            ];
            
            if (existingContacts.isEmpty()) {
                contactsToCreate.add(new Contact(
                    FirstName = 'Sync',
                    LastName = 'Contact',
                    AccountId = acc.Id
                ));
            }
            
            processedCount++;
        }
        
        // Insert contacts created in synchronous transaction
        if (!contactsToCreate.isEmpty()) {
            insert contactsToCreate;
            System.debug('Synchronously created ' + contactsToCreate.size() + ' contacts');
        }
        
        // If we have remaining accounts, process them asynchronously
        if (!remainingAccounts.isEmpty()) {
            System.debug('Enqueuing ' + remainingAccounts.size() + 
                        ' accounts for asynchronous processing');
            
            // Create list of account IDs for async processing
            List<Id> remainingAccountIds = new List<Id>();
            for (Account acc : remainingAccounts) {
                remainingAccountIds.add(acc.Id);
            }
            
            // Enqueue async job - this runs in a SEPARATE transaction with fresh limits
            // Note: BulkAccountProcessorQueueable would be in a separate file in a real implementation
            System.debug('Would enqueue BulkAccountProcessorQueueable for ' + remainingAccountIds.size() + ' accounts');
            System.debug('Async job would run with fresh governor limits');
        }
        
        System.debug('Synchronous processing completed. Processed: ' + processedCount + 
                    ' accounts synchronously');
    }
    
    /**
     * @description Demonstrates chaining queueable jobs across multiple transactions
     * Shows how complex work can be broken across multiple async transactions
     */
    public static void demonstrateJobChaining() {
        System.debug('=== JOB CHAINING DEMO ===');
        
        // Create a large dataset that will require multiple transactions
        List<Account> largeDataset = new List<Account>();
        for (Integer i = 0; i < 500; i++) {
            largeDataset.add(new Account(Name = 'Chain Test Account ' + i));
        }
        insert largeDataset;
        
        System.debug('Created ' + largeDataset.size() + ' accounts for chain processing');
        
        // Start the chain processing
        List<Id> accountIds = new List<Id>();
        for (Account acc : largeDataset) {
            accountIds.add(acc.Id);
        }
        
        // Note: In a real implementation, you would create separate classes for the queueable jobs
        // For this demo, we'll reference them but they would be in separate files
        System.debug('Would start chain processing job with ChainableProcessorQueueable');
        System.debug('Chain processing would handle ' + accountIds.size() + ' accounts in batches');
    }
} 