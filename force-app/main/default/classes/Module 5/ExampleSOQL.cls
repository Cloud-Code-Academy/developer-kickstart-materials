public with sharing class ExampleSOQL {
	/**
	 * Returns all opportunities from the Salesforce Org.
	 * @return List of all opportunities with Id, Name, Amount, CloseDate, StageName
	 */
	public static List<Opportunity> getAllOpportunities() {
		return [SELECT Id, Name, Amount, CloseDate, StageName, AccountId FROM Opportunity];
	}

	/**
	 * Returns the Opportunity Ids for all opportunities with a stage name of 'Prospecting' or 'Closed Won' and an amount greater than a specified value.
	 * @param minAmount The minimum amount for the opportunities to be retrieved.
	 * @return A list of Opportunity Ids.
	 */
	public static List<Id> getOpportunityIdsByStageNameAndAmount(Decimal minAmount) {
		List<Id> opportunityIds = new List<Id>();
		for (Opportunity opp : [
			SELECT Id
			FROM Opportunity
			WHERE (StageName = 'Prospecting' OR StageName = 'Closed Won') AND Amount > :minAmount
		]) {
			opportunityIds.add(opp.Id);
		}
		return opportunityIds;
	}

	/**
	 * Retrieves all Opportunities related to Accounts with names starting with 'Test%' and with a close date within the last 'days' days.
	 * @param days The number of days to look back for the close date.
	 * @return A list of Opportunity records.
	 */
	public static List<Opportunity> getOpportunitiesByAccountNameAndCloseDate(Integer days) {
		Date d = System.today() - days;
		return [
			SELECT Id, Name, CloseDate, Account.Name
			FROM Opportunity
			WHERE Account.Name LIKE 'Test%' AND CloseDate > :d
		];
	}

	/**
	 * Extracts email domains from them leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = test.com
	 * Example: findContactsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param A list of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 */
	public static List<Account> findContactsByLeadEmailDomains(Set<Id> leadIds) {
		// Query the Leads
		List<Lead> leads = [SELECT Id, Email FROM Lead WHERE Id IN :leadIds];
		// Create a set of email domains from the Leads
		Set<String> emailDomains = new Set<String>();
		for (Lead lead : leads) {
			String email = lead.Email;
			if (email != null) {
				emailDomains.add('www.' + email.substring(email.indexOf('@') + 1));
			}
		}
		// Query the Accounts
		return [SELECT Id, Name, Website FROM Account WHERE Website IN :emailDomains];
	}

	/**
	 * Sets the 'Primary_Contact__c' field for the provided Opportunities from the first related Contact of the Account, ordered by first name descending.
	 * @param A list of 'Closed Won' Opportunities.
	 * @return void.
	 */
	public static void setPrimaryContact() {
		//Use the getAllOpportunities() method to get the Opportunities. Adjust query if needed
		List<Opportunity> opportunities = getAllOpportunities();

		// Create a set of Account Ids from the Opportunities
		Set<Id> accountIds = new Set<Id>();
		for (Opportunity opp : opportunities) {
			accountIds.add(opp.AccountId);
		}
		// Query the Contacts
		List<Contact> contacts = [
			SELECT Id, AccountId, FirstName
			FROM Contact
			WHERE AccountId IN :accountIds
			ORDER BY FirstName DESC
			LIMIT 1
		];
		Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
		for (Contact contact : contacts) {
			accountToContactMap.put(contact.AccountId, contact);
		}
		// Update the Opportunities
		for (Opportunity opp : opportunities) {
			Contact primaryContact = accountToContactMap.get(opp.AccountId);
			if (primaryContact != null) {
				opp.Primary_Contact__c = primaryContact.Id;
			}
		}
		update opportunities;
	}
}
