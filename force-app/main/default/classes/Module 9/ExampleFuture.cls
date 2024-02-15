/*
 * Update/Uncomment the template code to create a method
 * Create a future method that updates all account and opportunities description to 'Meeting in the future'
 */

public with sharing class ExampleFuture {
	@future
	public static void updateDescription() {
		// Define the new value for the description field.
		String description = 'Meeting in the future';

		// Query all Account records and their related Opportunities.
		Map<Id, Account> accountsToUpdate = new Map<Id, Account>([SELECT Id, Name FROM Account]);
		// Loop through each Account in our map.
		for (Account acc : accountsToUpdate.values()) {
			// Update the description field for the Account.
			acc.Description = description;
		}

		// Commit the changes for the Accounts to the database.
		update accountsToUpdate.values();
	}
}
