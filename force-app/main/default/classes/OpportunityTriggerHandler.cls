public with sharing class OpportunityTriggerHandler {
    
    public static void handleBeforeUpdate(List<Opportunity> triggerNewOpportunities) {

        for (Opportunity opp : triggerNewOpportunities) {
            if (opp.StageName == 'Closed Won' && opp.Amount == null) {
                opp.addError('Amount is required for Closed Won opportunities');
            }
        }
    }

    public static void handleAfterUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldMapOpp) {
         List<Account> accountsToUpdate = new List<Account>();
        Set<Id> accountIds = new Set<Id>();

        for (Opportunity opp : newOpps) {
            if (opp.StageName == 'Closed Won' && oldMapOpp.get(opp.Id).StageName != 'Closed Won') {
                accountIds.add(opp.AccountId);
            }
        }

        for (Account acc : [SELECT Id, Description FROM Account WHERE Id IN :accountIds]) {
            acc.Description = 'Has closed deals';
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
}