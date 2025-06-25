/**
 * AccountTrigger - Lesson 8: Advanced Trigger Best Practices
 * 
 * This trigger demonstrates using the TriggerFramework pattern.
 * Notice how simple and clean this trigger is - just one line!
 * 
 * BEST PRACTICES:
 * 1. Trigger contains NO business logic
 * 2. Uses the framework's run() method
 * 3. All events are handled by the framework
 * 4. Easy to read and maintain
 * 
 * @author Cloud Code Academy
 * @since 2025
 */
trigger AccountTrigger on Account (
    before insert, 
    before update, 
    before delete,
    after insert, 
    after update,
    after delete,
    after undelete
) {
    // Execute the handler using the framework
    new AccountTriggerHandler().run();
} 