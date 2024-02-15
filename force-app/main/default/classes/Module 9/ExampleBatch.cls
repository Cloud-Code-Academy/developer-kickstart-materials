/*
 * Implementing the 'Database.Batchable' interface allows you to define a job that can be broken into smaller batches.
 * Update all Account records to have the same description 'Batching the next meetings together.''
 * Send an email to all active users
 */

public with sharing class ExampleBatch implements Database.Batchable<sObject> {
	// The 'start' method is executed at the beginning of the batch Apex job.
	// It returns a 'Database.QueryLocator' object which the platform uses to identify the records to process.
	public Database.QueryLocator start(Database.BatchableContext BC) {
		// Here we're querying all the 'Account' records, specifically their Id, Name, and the custom field 'Description'.
		return Database.getQueryLocator([SELECT Id, Name, Description FROM Account]);
	}

	// The 'execute' method processes the records retrieved by the 'start' method.
	// This method is called once for each batch of records to be processed.
	public void execute(Database.BatchableContext BC, List<Account> scope) {
		// We're defining a string that we will use to update the 'Description' field on the Account
		String description = 'Batching the next meetings together.';

		// A set to store the Ids of the Account records being processed.
		// A set is a collection that doesn't allow duplicate values.
		Set<Id> accountIds = new Set<Id>();

		// Loop through each Account in the current batch.
		for (Account a : scope) {
			// Update the 'Description' field of the Account.
			a.Description = description;

			// Add the Id of the Account to our set.
			accountIds.add(a.Id);
		}

		// Save the updated Account records back to Salesforce.
		update scope;
	}

	// The 'finish' method is called after all batches are processed.
	public void finish(Database.BatchableContext BC) {
		// Query active User records, excluding any with an email that starts with 'autoproc'.
		List<User> users = [SELECT Id, Name, Email FROM User WHERE IsActive = TRUE AND (NOT Email LIKE 'autoproc%')];

		// A set to store the email addresses of the active users.
		Set<String> emails = new Set<String>();

		// Loop through each user.
		for (User u : users) {
			// Add each user's email address to our set.
			emails.add(u.Email);
		}

		// Check if we have any email addresses.
		if (!emails.isEmpty()) {
			// If we do, call the 'sendEmail' method to send them a notification.
			sendEmailToActiveUsers(emails);
		}
	}

	// This private helper method sends an email to the provided set of email addresses.
	private void sendEmailToActiveUsers(Set<String> emails) {
		try {
			// Create a new email message object.
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

			// Set the recipient addresses.
			mail.setToAddresses(new List<String>(emails));

			// Set the subject of the email.
			mail.setSubject('Description Batch Complete');

			// Set the body of the email.
			mail.setPlainTextBody('The description batch has completed.');

			// Send the email.
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
		} catch (Exception e) {
			// If there's an error sending the email, log the error message.
			System.debug('Error sending email: ' + e.getMessage());
		}
	}
}
