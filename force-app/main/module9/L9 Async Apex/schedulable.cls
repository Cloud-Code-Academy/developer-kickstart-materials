/**
 * SCHEDULED APEX EXAMPLE
 * 
 * This example demonstrates:
 * - Implementing the Schedulable interface
 * - Scheduling a batch job to run on a recurring basis
 * - Using cron expressions
 * - Monitoring execution
 */
public class WeeklyInactiveAccountScheduler implements Schedulable {
    
    // Store configuration parameters
    private Integer daysInactive;
    private String notificationEmail;
    private Integer batchSize;
    
    /**
     * Constructor to configure the scheduler
     */
    public WeeklyInactiveAccountScheduler(Integer daysInactive, String notificationEmail, Integer batchSize) {
        this.daysInactive = daysInactive;
        this.notificationEmail = notificationEmail;
        this.batchSize = batchSize;
    }
    
    /**
     * Required execute method for Schedulable interface
     */
    public void execute(SchedulableContext sc) {
        // Create a new instance of the batch job
        InactiveAccountProcessor batchJob = new InactiveAccountProcessor(daysInactive, notificationEmail);
        
        // Start the batch job with specified batch size
        Id batchId = Database.executeBatch(batchJob, batchSize);
        
        // Log execution for monitoring
        System.debug('Scheduled job executed. Batch job ID: ' + batchId);
    }
    
    /**
     * Helper method to schedule the job using a cron expression
     */
    public static String scheduleWeeklyJob(String jobName, Integer daysThreshold, 
                                           String notificationEmail, Integer batchSize) {
        // Create an instance of the scheduler
        WeeklyInactiveAccountScheduler scheduler = new WeeklyInactiveAccountScheduler(
            daysThreshold, notificationEmail, batchSize
        );
        
        // Schedule to run weekly on Sunday at 1:00 AM
        // Cron expression: Seconds Minutes Hours Day_of_month Month Day_of_week Year
        String cronExp = '0 0 1 ? * SUN *';
        
        // Schedule the job
        Id jobId = System.schedule(jobName, cronExp, scheduler);
        return jobId;
    }
    
    /**
     * Helper method to schedule the job for monthly execution
     */
    public static String scheduleMonthlyJob(String jobName, Integer daysThreshold, 
                                            String notificationEmail, Integer batchSize) {
        // Create an instance of the scheduler
        WeeklyInactiveAccountScheduler scheduler = new WeeklyInactiveAccountScheduler(
            daysThreshold, notificationEmail, batchSize
        );
        
        // Schedule to run on the 1st of every month at 2:00 AM
        String cronExp = '0 0 2 1 * ? *';
        
        // Schedule the job
        Id jobId = System.schedule(jobName, cronExp, scheduler);
        return jobId;
    }
    
    /**
     * Helper method to schedule the job for daily execution during weekdays
     */
    public static String scheduleDailyWeekdayJob(String jobName, Integer daysThreshold, 
                                                String notificationEmail, Integer batchSize) {
        // Create an instance of the scheduler
        WeeklyInactiveAccountScheduler scheduler = new WeeklyInactiveAccountScheduler(
            daysThreshold, notificationEmail, batchSize
        );
        
        // Schedule to run Monday through Friday at 11:00 PM
        String cronExp = '0 0 23 ? * MON-FRI *';
        
        // Schedule the job
        Id jobId = System.schedule(jobName, cronExp, scheduler);
        return jobId;
    }
    
    /**
     * Example usage from Anonymous Apex:
     * 
     * // Schedule a weekly job to process accounts inactive for 90+ days
     * String jobId = WeeklyInactiveAccountScheduler.scheduleWeeklyJob(
     *     'Weekly Inactive Account Processing',
     *     90,
     *     'admin@example.com',
     *     200
     * );
     * System.debug('Scheduled job with ID: ' + jobId);
     */
}