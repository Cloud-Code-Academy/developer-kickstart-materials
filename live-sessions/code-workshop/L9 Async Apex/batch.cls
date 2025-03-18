/**
 * BATCH APEX EXAMPLE
 * 
 * This example demonstrates:
 * - Implementing the Database.Batchable interface
 * - Creating start, execute, and finish methods
 * - Processing inactive accounts
 * - Error handling and notification
 */
public class InactiveAccountProcessor implements Database.Batchable<SObject>, Database.Stateful {
    
    // Variables to track processing
    private Integer recordsProcessed = 0;
    private Integer recordsFailed = 0;
    private List<String> errorMessages = new List<String>();
    private Date inactiveThreshold;
    private String emailNotificationAddress;
    
    /**
     * Constructor to set the inactive threshold and notification email
     */
    public InactiveAccountProcessor(Integer daysInactive, String notificationEmail) {
        this.inactiveThreshold = Date.today().addDays(-daysInactive);
        this.emailNotificationAddress = notificationEmail;
    }
    
    /**
     * Start method defines the query to retrieve records to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for accounts that haven't been modified in X days
        return Database.getQueryLocator([
            SELECT Id, Name, LastModifiedDate, IsInactive__c, LastActivityDate 
            FROM Account 
            WHERE LastModifiedDate < :inactiveThreshold
            AND IsInactive__c = false
        ]);
    }
    
    /**
     * Execute method processes each batch of records
     */
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        // Lists to track processing
        List<Account> accountsToUpdate = new List<Account>();
        
        // Process each account
        for (Account acc : scope) {
            try {
                // Mark as inactive
                acc.IsInactive__c = true;
                acc.InactiveReason__c = 'No activity for ' + 
                    (Date.today().daysBetween(acc.LastModifiedDate.date()) * -1) + ' days';
                accountsToUpdate.add(acc);
                recordsProcessed++;
            } catch (Exception e) {
                // Track errors
                recordsFailed++;
                errorMessages.add('Error processing account ' + acc.Id + ': ' + e.getMessage());
            }
        }
        
        // Update accounts with error handling
        if (!accountsToUpdate.isEmpty()) {
            try {
                List<Database.SaveResult> results = Database.update(accountsToUpdate, false); // Allow partial success
                
                // Process save results
                for (Integer i = 0; i < results.size(); i++) {
                    if (!results[i].isSuccess()) {
                        recordsProcessed--; // Adjust the count
                        recordsFailed++;
                        String accName = accountsToUpdate[i].Name != null ? accountsToUpdate[i].Name : accountsToUpdate[i].Id;
                        errorMessages.add('Failed to update account ' + accName + ': ' + 
                                         results[i].getErrors()[0].getMessage());
                    }
                }
            } catch (Exception e) {
                recordsFailed += accountsToUpdate.size();
                recordsProcessed -= accountsToUpdate.size();
                errorMessages.add('Batch update error: ' + e.getMessage());
            }
        }
    }
    
    /**
     * Finish method executes after all batches complete
     */
    public void finish(Database.BatchableContext bc) {
        // Send email notification with results
        if (String.isNotBlank(emailNotificationAddress)) {
            sendSummaryEmail(bc.getJobId());
        }
        
        // Log results
        System.debug('Batch Job Completed');
        System.debug('Total Records Processed: ' + recordsProcessed);
        System.debug('Total Records Failed: ' + recordsFailed);
        
        // Create a log record in a custom object (optional implementation)
        createBatchJobLog(bc.getJobId());
    }
    
    /**
     * Helper method to send summary email
     */
    private void sendSummaryEmail(Id jobId) {
        // Get job details
        AsyncApexJob job = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems
            FROM AsyncApexJob
            WHERE Id = :jobId
        ];
        
        // Prepare email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { emailNotificationAddress });
        mail.setSubject('Inactive Account Processing Job Complete');
        
        String body = 'The batch job to process inactive accounts has completed.\n\n';
        body += 'Job Status: ' + job.Status + '\n';
        body += 'Records Processed: ' + recordsProcessed + '\n';
        body += 'Records Failed: ' + recordsFailed + '\n\n';
        
        if (!errorMessages.isEmpty()) {
            body += 'ERRORS:\n';
            for (String error : errorMessages) {
                body += '• ' + error + '\n';
            }
        }
        
        mail.setPlainTextBody(body);
        
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (Exception e) {
            System.debug('Error sending email notification: ' + e.getMessage());
        }
    }
    
    /**
     * Helper method to create a log record
     */
    private void createBatchJobLog(Id jobId) {
        // This would typically insert a record into a custom object
        // Implementation depends on your org's data model
        System.debug('Log created for job: ' + jobId);
    }
    
    /**
     * Execute the batch from Anonymous Apex with:
     * 
     * // Process accounts inactive for 90 days, 200 records per batch
     * InactiveAccountProcessor batchJob = new InactiveAccountProcessor(90, 'admin@example.com');
     * Id jobId = Database.executeBatch(batchJob, 200);
     */
}