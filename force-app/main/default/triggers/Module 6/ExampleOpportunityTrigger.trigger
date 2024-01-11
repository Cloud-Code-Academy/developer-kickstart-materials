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
			for (Opportunity opp : Trigger.new) {
				if (opp.Amount < 5000) {
					opp.addError('Opportunity amount must be greater than 5000');
				}
			}
		}
		when BEFORE_UPDATE {
			//Get contacts related to the opportunity account
			Set<Id> accountIds = new Set<Id>();
			for (Opportunity opp : Trigger.new) {
				accountIds.add(opp.AccountId);
			}

			Map<Id, Contact> contacts = new Map<Id, Contact>(
				[
					SELECT Id, FirstName, AccountId
					FROM Contact
					WHERE AccountId IN :accountIds AND Title = 'CEO'
					ORDER BY FirstName ASC
				]
			);
			Map<Id, Contact> accountIdToContact = new Map<Id, Contact>();

			for (Contact cont : contacts.values()) {
				if (!accountIdToContact.containsKey(cont.AccountId)) {
					accountIdToContact.put(cont.AccountId, cont);
				}
			}

			for (Opportunity opp : Trigger.new) {
				if (opp.Primary_Contact__c == null) {
					if (accountIdToContact.containsKey(opp.AccountId)) {
						opp.Primary_Contact__c = accountIdToContact.get(opp.AccountId).Id;
					}
				}
			}
		}
		when BEFORE_DELETE {
		}
		when AFTER_INSERT {
		}
		when AFTER_UPDATE {
		}
		when AFTER_DELETE {
		}
		when AFTER_UNDELETE {
		}
	}

}
