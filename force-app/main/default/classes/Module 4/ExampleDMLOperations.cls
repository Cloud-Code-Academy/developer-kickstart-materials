public with sharing class ExampleDMLOperations {
	/**
	 * Create a new Lead with the specified last name and company.
	 * @param lastName The last name of the lead to be created.
	 * @param company The company of the lead to be created.
	 * @return The new Lead.
	 */
	public static Lead createLead(String lastName, String company) {
		// Create a new Lead setting the last name and company

		// Insert the Lead

		return null;
	}

	/**
	 * Creates multiple Lead records with the provided list of last names and a common company.
	 * Set the company name to 'Acme Inc'
	 * @param lastNames A list of last names for the leads to be created.
	 * @return A list of created Lead records.
	 */
	public static List<Lead> createMultipleLeads(List<String> lastNames) {
		// Loop through the last names and create a new Lead for each one

		// Return the list of Leads
		return null;
	}

	/**
	 * Updates a list of Cases based on their Origin.
	 * if the Origin is 'Web', set the Description to 'Web Inquiry'.
	 * if the origin is 'Email', set the Description to 'Email Inquiry'.
	 * if the origin is 'Phone', set the Description to 'Phone Inquiry'.
	 * @param cases List of Cases to be updated.
	 */
	public static void updateCaseListBasedOnOrigin(List<Case> cases) {
		// Iterate over the cases

		// if the Origin is 'Web', set the Description to 'Web Inquiry'.
		// if the origin is 'Email', set the Description to 'Email Inquiry'.
		// if the origin is 'Phone', set the Description to 'Phone Inquiry'.

		// Update the Cases
	}

	/**
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, it updates that Account.
	 * If no such Account exists, it creates a new one.
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];

		// if the Account exists, update it

		// otherwise, create a new Account

		// Upsert the Account
		return null;
	}

	/**
	 * Upserts accounts and links contacts to them based on the contact's last name and account name.
	 * Accounts are upserted or found using the upsertAccount method.
	 * Contacts are then linked to these accounts based on a full last name match.
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact

		// Extract the Account Name from Contact's LastName

		// Get the account based on the name or create one if it doesn't exist

		// Link the Contact to its Account using the Account Id

		// Upsert the Contacts
	}

	/**
	 * Insert a list of Leads and then delete only those with 'Phone' as their source.
	 * @param leads The list of Lead objects to be inserted and conditionally deleted.
	 */
	public static void insertAndDeletePhoneLeads(List<Lead> leads) {
		// Prepare a List to store the Leads to be deleted

		// Loop through the inserted Leads and add to delete list if source is 'Phone'

		// Delete the filtered Leads
	}
}
