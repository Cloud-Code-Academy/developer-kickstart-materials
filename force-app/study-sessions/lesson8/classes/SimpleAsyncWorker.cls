/**
 * @description Simple Queueable class to demonstrate async transaction execution
 * @author PD1 Study Session - Lesson 8
 * 
 * This class demonstrates:
 * 1. How async Apex runs in a separate transaction
 * 2. Fresh governor limits in async execution
 * 3. Accessing data created in the synchronous transaction
 */
public class SimpleAsyncWorker implements Queueable {
    
    private Id accountId;
    private String workType;
    
    /**
     * @description Constructor for the async worker
     * @param accountId ID of the account to work with
     * @param workType Type of work to perform
     */
    public SimpleAsyncWorker(Id accountId, String workType) {
        this.accountId = accountId;
        this.workType = workType;
    }
    
    /**
     * @description Execute method - runs in a separate transaction
     * @param context Queueable context provided by Salesforce
     */
    public void execute(QueueableContext context) {
        System.debug('=== SIMPLE ASYNC WORKER EXECUTING ===');
        System.debug('ASYNCHRONOUS TRANSACTION BEGINS');
        System.debug('Job ID: ' + context.getJobId());
        System.debug('Work Type: ' + workType);
        
        // IMPORTANT: This is a SEPARATE transaction with fresh governor limits
        System.debug('Fresh governor limits available:');
        System.debug('SOQL Queries: ' + Limits.getQueries() + ' / ' + Limits.getLimitQueries());
        System.debug('DML Statements: ' + Limits.getDMLStatements() + ' / ' + Limits.getLimitDMLStatements());
        System.debug('CPU Time: ' + Limits.getCpuTime() + ' ms / ' + Limits.getLimitCpuTime() + ' ms');
        
        try {
            // Query the account that was created in the synchronous transaction
            // This proves that committed data from sync transaction is visible in async transaction
            Account acc = [SELECT Id, Name, Description FROM Account WHERE Id = :accountId];
            System.debug('Retrieved account from sync transaction: ' + acc.Name);
            
            // Perform different types of work based on workType
            if (workType == 'CREATE_CONTACTS') {
                createContactsForAccount(acc);
            } else if (workType == 'CREATE_OPPORTUNITIES') {
                createOpportunitiesForAccount(acc);
            } else if (workType == 'UPDATE_ACCOUNT') {
                updateAccountDescription(acc);
            } else {
                System.debug('Unknown work type: ' + workType);
            }
            
            System.debug('Async work completed successfully');
            
        } catch (Exception e) {
            System.debug('Error in async transaction: ' + e.getMessage());
            // In a real implementation, you might want to log this error
            // or send a notification about the failure
        }
        
        System.debug('ASYNCHRONOUS TRANSACTION ENDS');
        // The async transaction commits here, separate from any sync transaction
    }
    
    /**
     * @description Creates contacts for the account
     * @param acc Account to create contacts for
     */
    private void createContactsForAccount(Account acc) {
        System.debug('Creating contacts for account: ' + acc.Name);
        
        List<Contact> contactsToCreate = new List<Contact>();
        for (Integer i = 1; i <= 3; i++) {
            contactsToCreate.add(new Contact(
                FirstName = 'Async Contact ' + i,
                LastName = 'for ' + acc.Name,
                AccountId = acc.Id,
                Email = 'async.contact' + i + '@example.com'
            ));
        }
        
        insert contactsToCreate;
        System.debug('Created ' + contactsToCreate.size() + ' contacts in async transaction');
    }
    
    /**
     * @description Creates opportunities for the account
     * @param acc Account to create opportunities for
     */
    private void createOpportunitiesForAccount(Account acc) {
        System.debug('Creating opportunities for account: ' + acc.Name);
        
        List<Opportunity> opportunitiesToCreate = new List<Opportunity>();
        for (Integer i = 1; i <= 2; i++) {
            opportunitiesToCreate.add(new Opportunity(
                Name = 'Async Opportunity ' + i + ' for ' + acc.Name,
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30 * i),
                Amount = 10000 * i
            ));
        }
        
        insert opportunitiesToCreate;
        System.debug('Created ' + opportunitiesToCreate.size() + ' opportunities in async transaction');
    }
    
    /**
     * @description Updates the account description
     * @param acc Account to update
     */
    private void updateAccountDescription(Account acc) {
        System.debug('Updating account description for: ' + acc.Name);
        
        acc.Description = 'Updated by async transaction at ' + DateTime.now();
        update acc;
        
        System.debug('Updated account description in async transaction');
    }
} 