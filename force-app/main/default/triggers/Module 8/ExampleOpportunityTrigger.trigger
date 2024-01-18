trigger ExampleOpportunityTrigger on Opportunity(
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
	switch on Trigger.operationType {
		when BEFORE_INSERT {
			//Opportunity Trigger - Validate Opportunity
			ExampleOpportunityHandler.validateOpportunity(Trigger.new);
			//Another Opportunity Trigger - Set Type
			ExampleOpportunityHandler.setOpportunityType(Trigger.new);
		}
		when BEFORE_UPDATE {
			//Opportunity Trigger - Set Primary Contact
			ExampleOpportunityHandler.setPrimaryContact(Trigger.new);
			//Another Opportunity Trigger - Change Description
			ExampleOpportunityHandler.addStageChangeToDescription(Trigger.new, Trigger.oldMap);
		}
		when BEFORE_DELETE {
			ExampleOpportunityHandler.validateDelete(Trigger.old);
		}
		when AFTER_INSERT {
			ExampleOpportunityHandler.createTaskForPrimaryContact(Trigger.new);
		}
		when AFTER_UPDATE {
		}
		when AFTER_DELETE {
			ExampleOpportunityHandler.notifyOwnersOpportunityDeleted(Trigger.old);
		}
		when AFTER_UNDELETE {
			ExampleOpportunityHandler.assignPrimaryContact(Trigger.newMap);
		}
	}

}
