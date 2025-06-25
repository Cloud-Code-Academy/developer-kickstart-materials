trigger OpportunityTrigger on Opportunity (before update, after update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        List<Opportunity> newOpps = Trigger.new;
        OpportunityTriggerHandler.handleBeforeUpdate(newOpps);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
       OpportunityTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}