public with sharing class ExampleOpportunityHandler {
	//Opportunity Trigger
	public static void validateOpportunity(List<Opportunity> opps) {
		for (Opportunity opp : opps) {
			if (opp.Amount < 5000) {
				opp.addError('Opportunity amount must be greater than 5000');
			}
		}
	}

	public static void setPrimaryContact(List<Opportunity> opps) {
		Set<Id> accountIds = new Set<Id>();
		for (Opportunity opp : opps) {
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

		for (Opportunity opp : opps) {
			if (opp.Primary_Contact__c == null) {
				if (accountIdToContact.containsKey(opp.AccountId)) {
					opp.Primary_Contact__c = accountIdToContact.get(opp.AccountId).Id;
				}
			}
		}
	}

	//Another Opportunity Trigger

	public static void setOpportunityType(List<Opportunity> opps) {
		for (Opportunity opp : opps) {
			if (opp.Type == null) {
				opp.Type = 'New Customer';
			}
		}
	}

	public static void addStageChangeToDescription(List<Opportunity> opps, Map<Id, Opportunity> oldOppMap) {
		for (Opportunity opp : opps) {
			Opportunity oldOpp = oldOppMap.get(opp.Id);
			if (opp.StageName != oldOpp.StageName && opp.Id == oldOpp.Id) {
				opp.Description += '\n Stage Change:' + opp.StageName + ':' + DateTime.now().format();
			}
		}
	}

	public static void validateDelete(List<Opportunity> opps) {
		for (Opportunity oldOpp : opps) {
			if (oldOpp.IsClosed) {
				oldOpp.addError('Cannot delete closed opportunity');
			}
		}
	}

	public static void createTaskForPrimaryContact(List<Opportunity> opps) {
		List<Task> tasks = new List<Task>();
		for (Opportunity opp : opps) {
			Task t = new Task();
			t.Subject = 'Call Primary Contact';
			t.WhatId = opp.Id;
			t.WhoId = opp.Primary_Contact__c;
			t.OwnerId = opp.OwnerId;
			t.ActivityDate = Date.today().addDays(3);
			tasks.add(t);
		}
		insert tasks;
	}

	public static void notifyOwnersOpportunityDeleted(List<Opportunity> opps) {
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Email FROM User]);
		for (Opportunity opp : opps) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new List<String>{ userMap.get(opp.OwnerId).Email };
			mail.setToAddresses(toAddresses);
			mail.setSubject('Opportunity Deleted : ' + opp.Name);
			mail.setPlainTextBody('Your Opportunity: ' + opp.Name + ' has been deleted.');
			mails.add(mail);
		}

		try {
			Messaging.sendEmail(mails);
		} catch (Exception e) {
			System.debug('Exception: ' + e.getMessage());
		}
	}

	public static void assignPrimaryContact(Map<Id, Opportunity> oppNewMap) {
		// get map of set of all opportunity account ids
		Set<Id> oppAccountIds = new Set<Id>();
		for (Opportunity opp : oppNewMap.values()) {
			oppAccountIds.add(opp.AccountId);
		}

		Map<Id, Account> accMap = new Map<Id, Account>(
			[
				SELECT Id, Name, (SELECT Id FROM Contacts WHERE Title = 'VP Sales')
				FROM Account
				WHERE Id IN :oppAccountIds
			]
		);

		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		for (Opportunity opp : oppNewMap.values()) {
			if (opp.Primary_Contact__c == null && !accMap.get(opp.AccountId).Contacts.isEmpty()) {
				Opportunity oppToUpdate = new Opportunity(Id = opp.Id);
				oppToUpdate.Primary_Contact__c = accMap.get(opp.AccountId).Contacts[0].Id;
				oppMap.put(opp.Id, oppToUpdate);
			}
		}

		update oppMap.values();
	}
}
