/*
 * Implement the Queueable interface to process records asynchronously.
 * This example processes up to 10 Account records where the Description field is not empty.
 * It then removes the Description from the Account records and updates them.
 */
public with sharing class ExampleQueueable implements Queueable {
	// Declare a private variable to store a collection of Account records.
	// The 'Map' is a collection that holds key-value pairs. In this case, the key is the Account ID and the value is the Account record.
	private Map<Id, Account> accounts;

	// This is the constructor for the NextStepQueueable class.
	// It initializes the class with a Map of Account records.
	public ExampleQueueable(Map<Id, Account> accounts) {
		// The 'this' keyword refers to the current instance of the class.
		// We're assigning the 'accounts' parameter to the class's 'accounts' variable.
		this.accounts = accounts;
	}

	// This static method queues a job to run the execute method of this class.
	public static void enqueueJob() {
		// Query up to 10 Account records where the Description field is not empty.
		Map<Id, Account> accountMap = new Map<Id, Account>();

		for (Account acc : [SELECT Id, Description FROM Account]) {
			if (!String.isEmpty(acc.Description)) {
				accountMap.put(acc.Id, acc);

				if (accountMap.size() == 10) {
					break;
				}
			}
		}
		System.debug('accountMap: ' + accountMap);

		// Check if we retrieved any Account records.
		if (!accountMap.isEmpty()) {
			// If we have records, enqueue a new job to process them asynchronously.
			System.enqueueJob(new ExampleQueueable(accountMap));
		}
	}

	// This method is required by the 'Queueable' interface.
	// It contains the logic that will run when the queued job is executed.
	public void execute(QueueableContext context) {
		// Loop over each Account in our map.
		for (Account acc : accounts.values()) {
			// Call the helper method to remove the description (Description) from the Account.
			removeNextStep(acc);
		}

		// Save the changes to the Account records back to Salesforce.
		update accounts.values();

		// Call the static method to queue another job to process more Account records.
		enqueueJob();
	}
	// Helper method to remove the Description from an Account.
	private static void removeNextStep(Account acc) {
		acc.Description = null; // Set the Description field to 'null', effectively clearing it.
	}
}
