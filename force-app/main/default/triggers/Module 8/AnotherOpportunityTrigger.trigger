/*
AnotherOpportunityTrigger Overview

This trigger was initially created for handling various events on the Opportunity object. It was developed by a prior developer and has since been noted to cause some issues in our org.

IMPORTANT:
- This trigger does not adhere to Salesforce best practices.
- It is essential to review, understand, and refactor this trigger to ensure maintainability, performance, and prevent any inadvertent issues.

ISSUES:
Avoid nested for loop - 1 instance
Avoid DML inside for loop - 1 instance
Bulkify Your Code - 1 instance
Avoid SOQL Query inside for loop - 2 instances
Stop recursion - 1 instance

RESOURCES: 
https://www.salesforceben.com/12-salesforce-apex-best-practices/
https://developer.salesforce.com/blogs/developer-relations/2015/01/apex-best-practices-15-apex-commandments
*/
trigger AnotherOpportunityTrigger on Opportunity(
	before insert,
	after insert,
	before update,
	after update,
	before delete,
	after delete,
	after undelete
) {
	// if (Trigger.isBefore) {
	// 	if (Trigger.isInsert) {
	// 		for (Opportunity opp : Trigger.new) {
	// 			if (opp.Type == null) {
	// 				opp.Type = 'New Customer';
	// 			}
	// 		}
	// 	} else if (Trigger.isUpdate) {
	// 		for (Opportunity opp : Trigger.new) {
	// 			Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
	// 			if (opp.StageName != oldOpp.StageName && opp.Id == oldOpp.Id) {
	// 				opp.Description += '\n Stage Change:' + opp.StageName + ':' + DateTime.now().format();
	// 			}
	// 		}
	// 	} else if (Trigger.isDelete) {
	// 		for (Opportunity oldOpp : Trigger.old) {
	// 			if (oldOpp.IsClosed) {
	// 				oldOpp.addError('Cannot delete closed opportunity');
	// 			}
	// 		}
	// 	}
	// }

	// List<Task> tasks = new List<Task>();
	// if (Trigger.isAfter) {
	// 	if (Trigger.isInsert) {
	// 		for (Opportunity opp : Trigger.new) {
	// 			Task t = new Task();
	// 			t.Subject = 'Call Primary Contact';
	// 			t.WhatId = opp.Id;
	// 			t.WhoId = opp.Primary_Contact__c;
	// 			t.OwnerId = opp.OwnerId;
	// 			t.ActivityDate = Date.today().addDays(3);
	// 			tasks.add(t);
	// 		}
	// 	} else if (Trigger.isDelete) {
	// 		notifyOwnersOpportunityDeleted(Trigger.old);
	// 	} else if (Trigger.isUndelete) {
	// 		assignPrimaryContact(Trigger.newMap);
	// 	}

	// 	insert tasks;
	// }

	// private static void notifyOwnersOpportunityDeleted(List<Opportunity> opps) {
	// 	List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
	// 	Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Email FROM User]);
	// 	for (Opportunity opp : opps) {
	// 		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	// 		String[] toAddresses = new List<String>{ userMap.get(opp.OwnerId).Email };
	// 		mail.setToAddresses(toAddresses);
	// 		mail.setSubject('Opportunity Deleted : ' + opp.Name);
	// 		mail.setPlainTextBody('Your Opportunity: ' + opp.Name + ' has been deleted.');
	// 		mails.add(mail);
	// 	}

	// 	try {
	// 		Messaging.sendEmail(mails);
	// 	} catch (Exception e) {
	// 		System.debug('Exception: ' + e.getMessage());
	// 	}
	// }

	// private static void assignPrimaryContact(Map<Id, Opportunity> oppNewMap) {
	// 	// get map of set of all opportunity account ids
	// 	Set<Id> oppAccountIds = new Set<Id>();
	// 	for (Opportunity opp : oppNewMap.values()) {
	// 		oppAccountIds.add(opp.AccountId);
	// 	}

	// 	Map<Id, Account> accMap = new Map<Id, Account>(
	// 		[
	// 			SELECT Id, Name, (SELECT Id FROM Contacts WHERE Title = 'VP Sales')
	// 			FROM Account
	// 			WHERE Id IN :oppAccountIds
	// 		]
	// 	);

	// 	Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
	// 	for (Opportunity opp : oppNewMap.values()) {
	// 		if (opp.Primary_Contact__c == null && !accMap.get(opp.AccountId).Contacts.isEmpty()) {
	// 			Opportunity oppToUpdate = new Opportunity(Id = opp.Id);
	// 			oppToUpdate.Primary_Contact__c = accMap.get(opp.AccountId).Contacts[0].Id;
	// 			oppMap.put(opp.Id, oppToUpdate);
	// 		}
	// 	}

	// 	update oppMap.values();
	// }
}
