/**
 * TriggerFramework - Lesson 8: Advanced Trigger Best Practices
 * 
 * This abstract class provides a reusable trigger framework.
 * Concrete handler classes should extend this class and override
 * the methods they need to implement.
 * 
 * FEATURES:
 * 1. Standard interface for all triggers
 * 2. Recursive execution prevention
 * 3. Ability to bypass triggers
 * 4. Built-in debugging support
 * 5. Maximum number of runs control
 * 
 * @author Cloud Code Academy
 * @since 2025
 */
public abstract class TriggerFramework {
    
    // Static variables to prevent recursive execution
    private static Map<String, Integer> runCount = new Map<String, Integer>();
    private static Map<String, Boolean> bypassedHandlers = new Map<String, Boolean>();
    
    // Configuration
    @TestVisible
    private static final Integer MAX_RUNS = 5;
    
    /**
     * Main method to execute trigger logic
     * This is called from the trigger
     */
    public void run() {
        // Get the name of the current handler
        String handlerName = getHandlerName();
        
        // Check if this handler is bypassed
        if (isBypassed(handlerName)) {
            System.debug('Handler bypassed: ' + handlerName);
            return;
        }
        
        // Check if we've exceeded max runs
        if (!validateRun(handlerName)) {
            System.debug('Handler exceeded max runs: ' + handlerName);
            return;
        }
        
        // Increment the run count
        incrementRunCount(handlerName);
        
        System.debug('=== Executing Handler: ' + handlerName + ' (Run #' + runCount.get(handlerName) + ') ===');
        
        // Route to the appropriate handler method
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                beforeInsert();
            } else if (Trigger.isUpdate) {
                beforeUpdate();
            } else if (Trigger.isDelete) {
                beforeDelete();
            }
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                afterInsert();
            } else if (Trigger.isUpdate) {
                afterUpdate();
            } else if (Trigger.isDelete) {
                afterDelete();
            } else if (Trigger.isUndelete) {
                afterUndelete();
            }
        }
    }
    
    /**
     * Virtual methods to be overridden by concrete handlers
     */
    protected virtual void beforeInsert() {}
    protected virtual void beforeUpdate() {}
    protected virtual void beforeDelete() {}
    protected virtual void afterInsert() {}
    protected virtual void afterUpdate() {}
    protected virtual void afterDelete() {}
    protected virtual void afterUndelete() {}
    
    /**
     * Helper method to get handler name
     */
    private String getHandlerName() {
        return String.valueOf(this).split(':')[0];
    }
    
    /**
     * Check if handler should run
     */
    private Boolean validateRun(String handlerName) {
        if (!runCount.containsKey(handlerName)) {
            return true;
        }
        return runCount.get(handlerName) < MAX_RUNS;
    }
    
    /**
     * Increment run count for handler
     */
    private void incrementRunCount(String handlerName) {
        if (runCount.containsKey(handlerName)) {
            runCount.put(handlerName, runCount.get(handlerName) + 1);
        } else {
            runCount.put(handlerName, 1);
        }
    }
    
    /**
     * Check if handler is bypassed
     */
    private Boolean isBypassed(String handlerName) {
        return bypassedHandlers.containsKey(handlerName) && bypassedHandlers.get(handlerName);
    }
    
    /**
     * Bypass a specific handler
     * @param handlerName The name of the handler to bypass
     */
    public static void bypass(String handlerName) {
        bypassedHandlers.put(handlerName, true);
        System.debug('Bypassed handler: ' + handlerName);
    }
    
    /**
     * Remove bypass for a specific handler
     * @param handlerName The name of the handler to stop bypassing
     */
    public static void clearBypass(String handlerName) {
        bypassedHandlers.remove(handlerName);
        System.debug('Cleared bypass for handler: ' + handlerName);
    }
    
    /**
     * Check if a handler is currently bypassed
     * @param handlerName The name of the handler to check
     * @return True if bypassed, false otherwise
     */
    public static Boolean isBypassed(String handlerName) {
        return bypassedHandlers.containsKey(handlerName) && bypassedHandlers.get(handlerName);
    }
    
    /**
     * Clear all bypasses
     */
    public static void clearAllBypasses() {
        bypassedHandlers.clear();
        System.debug('Cleared all handler bypasses');
    }
    
    /**
     * Reset run counts (useful for testing)
     */
    @TestVisible
    private static void resetRunCounts() {
        runCount.clear();
        System.debug('Reset all run counts');
    }
    
    /**
     * Helper properties for easy access to trigger context
     */
    protected List<SObject> triggerNew {
        get {
            return Trigger.new;
        }
    }
    
    protected Map<Id, SObject> triggerNewMap {
        get {
            return Trigger.newMap;
        }
    }
    
    protected List<SObject> triggerOld {
        get {
            return Trigger.old;
        }
    }
    
    protected Map<Id, SObject> triggerOldMap {
        get {
            return Trigger.oldMap;
        }
    }
    
    protected Boolean triggerIsExecuting {
        get {
            return Trigger.isExecuting;
        }
    }
    
    protected Integer triggerSize {
        get {
            return Trigger.size;
        }
    }
} 