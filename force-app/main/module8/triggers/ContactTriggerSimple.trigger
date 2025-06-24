/**
 * ContactTriggerSimple - Lesson 8: Advanced Trigger Best Practices
 * 
 * This trigger demonstrates the CORRECT way to implement triggers.
 * It contains NO business logic - only routing to the handler class.
 * 
 * BEST PRACTICES:
 * 1. Trigger is thin - only routes to handler
 * 2. All logic is in the handler class
 * 3. Easy to read and understand
 * 4. Supports all trigger events
 * 
 * @author Cloud Code Academy
 * @since 2025
 */
trigger ContactTriggerSimple on Contact (
    before insert, 
    before update, 
    after insert, 
    after update,
    before delete,
    after delete,
    after undelete
) {
    // Create instance of handler
    SimpleTriggerHandler handler = new SimpleTriggerHandler();
    
    // Route to appropriate handler method based on trigger event
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.handleBeforeInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            handler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        else if (Trigger.isDelete) {
            // handler.handleBeforeDelete(Trigger.old, Trigger.oldMap);
        }
    }
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.handleAfterInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            handler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        else if (Trigger.isDelete) {
            // handler.handleAfterDelete(Trigger.old, Trigger.oldMap);
        }
        else if (Trigger.isUndelete) {
            // handler.handleAfterUndelete(Trigger.new);
        }
    }
} 