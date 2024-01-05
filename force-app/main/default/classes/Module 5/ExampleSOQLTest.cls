@isTest
public with sharing class ExampleSOQLTest {
	@IsTest
	static void testGetAllOpportunities() {
		// Create test data
		Opportunity testOpp1 = new Opportunity(
			Name = 'Test Opp 1',
			CloseDate = Date.today().addDays(10),
			StageName = 'Prospecting',
			Amount = 10000
		);
		Opportunity testOpp2 = new Opportunity(
			Name = 'Test Opp 2',
			CloseDate = Date.today().addDays(20),
			StageName = 'Qualification',
			Amount = 20000
		);
		insert new List<Opportunity>{ testOpp1, testOpp2 };

		// Call the method to test
		List<Opportunity> opportunities = null; //Replace null with your method call from SOQL class

		// Assert that the number of opportunities returned is correct
		System.assertEquals(2, opportunities.size(), 'Number of opportunities returned is incorrect.');

		// Assert that the opportunities returned have the correct names
		Set<String> oppNames = new Set<String>{ 'Test Opp 1', 'Test Opp 2' };
		for (Opportunity opp : opportunities) {
			System.assert(oppNames.contains(opp.Name), 'Opportunity name is incorrect.');
			Assert.isNotNull(opp.Amount, 'Opportunity amount is null.');
			Assert.isNotNull(opp.CloseDate, 'Opportunity close date is null.');
			Assert.isNotNull(opp.StageName, 'Opportunity stage name is null.');
		}
	}

	@IsTest
	static void testGetOpportunityIdsByStageNameAndAmount() {
		// Create test data
		Opportunity testOpp1 = new Opportunity(
			Name = 'Test Opp 1',
			CloseDate = Date.today().addDays(10),
			StageName = 'Prospecting',
			Amount = 1000 // Amount less than 1500
		);
		Opportunity testOpp2 = new Opportunity(
			Name = 'Test Opp 2',
			CloseDate = Date.today().addDays(20),
			StageName = 'Closed Won',
			Amount = 2000 // Amount greater than 1500
		);
		Opportunity testOpp3 = new Opportunity(
			Name = 'Test Opp 3',
			CloseDate = Date.today().addDays(15),
			StageName = 'Negotiation',
			Amount = 1600 // Amount greater than 1500 but stage name does not match
		);
		insert new List<Opportunity>{ testOpp1, testOpp2, testOpp3 };

		// Call the method to test
		Decimal minAmount = 1500;
		List<Id> oppIds = null; //Replace null with your method call from SOQL class

		// Assert that only one opportunity returned matches the criteria
		System.assertEquals(1, oppIds.size(), 'Number of opportunities returned is incorrect.');

		// Query the opportunities to verify the correct one was returned
		List<Opportunity> returnedOpps = [SELECT Id, StageName, Amount FROM Opportunity WHERE Id IN :oppIds];
		for (Opportunity opp : returnedOpps) {
			System.assert(
				opp.StageName == 'Prospecting' || opp.StageName == 'Closed Won',
				'Opportunity stage name should be Prospecting or Closed Won.'
			);
			System.assert(opp.Amount > minAmount, 'Opportunity amount should be greater than ' + minAmount);
		}
	}

	@IsTest
	static void testGetOpportunitiesByAccountNameAndCloseDate() {
		// Create test data
		Account testAccount = new Account(Name = 'TestAccount');
		insert testAccount;

		Opportunity opp1 = new Opportunity(
			Name = 'Opportunity 1',
			CloseDate = Date.today().addDays(-5),
			StageName = 'Prospecting',
			Amount = 10000,
			AccountId = testAccount.Id
		);
		Opportunity opp2 = new Opportunity(
			Name = 'Opportunity 2',
			CloseDate = Date.today().addDays(-10), // Outside the last 7 days
			StageName = 'Negotiation',
			Amount = 20000,
			AccountId = testAccount.Id
		);
		insert new List<Opportunity>{ opp1, opp2 };

		// Call the method to test
		Integer days = 7;
		List<Opportunity> opportunities = null; //Replace null with your method call from SOQL class

		// Assert that the correct number of opportunities are returned
		System.assertEquals(1, opportunities.size(), 'Incorrect number of opportunities returned.');

		// Assert that the opportunity returned has the correct details
		Opportunity returnedOpp = opportunities[0];
		System.assertEquals('Opportunity 1', returnedOpp.Name, 'Opportunity name should match.');
		System.assertEquals(
			testAccount.Id,
			returnedOpp.AccountId,
			'Opportunity should be linked to the correct account.'
		);
		System.assert(
			returnedOpp.CloseDate >= Date.today().addDays(-days),
			'Opportunity close date should be within the last ' + days + ' days.'
		);
	}

	@IsTest
	static void testFindContactsByLeadEmailDomains() {
		// Create test data
		// Generate random number of leads between 1 and 10
		List<String> domains = new List<String>{ 'example.com', 'test.com', 'other.com' };

		Integer numLeads = 10;
		List<Lead> leads = new List<Lead>();
		for (Integer i = 0; i < numLeads; i++) {
			String email = 'test' + i + '@' + domains[(Integer) Math.floor(Math.random() * domains.size())];
			leads.add(new Lead(Email = email, LastName = 'Test Lead ' + i, Company = 'Test Company ' + i));
		}

		insert leads;

		// Create test accounts
		Integer numAccounts = (Integer) Math.floor(Math.random() * 10) + 3;
		Map<String, List<Account>> domainToAccount = new Map<String, List<Account>>();
		List<Account> accounts = new List<Account>();
		for (Integer i = 0; i < numAccounts; i++) {
			String domain;
			Integer domainIndex = Math.mod(i, domains.size());
			if (domainIndex == 0) {
				domain = domains[0];
			} else if (domainIndex == 1) {
				domain = domains[1];
			} else {
				domain = domains[2];
			}
			String website = 'www.' + domain;
			accounts.add(new Account(Name = 'Test Account ' + i, Website = website));
			if (!domainToAccount.containsKey(domain)) {
				domainToAccount.put(domain, new List<Account>());
			}
			domainToAccount.get(domain).add(accounts[i]);
		}
		insert accounts;

		// Call the method to test
		Lead testLead = leads[(Integer) Math.floor(Math.random() * leads.size())];
		String testLeadDomain = testLead.Email.split('@')[1];
		Set<Id> leadIds = new Set<Id>{ testLead.Id };
		List<Account> matchedAccounts = ExampleSOQL.findContactsByLeadEmailDomains(leadIds);

		// Assert that the number of matched accounts is correct
		System.assertEquals(
			domainToAccount.get(testLeadDomain).size(),
			matchedAccounts.size(),
			'Number of matched accounts is incorrect.'
		);

		// Assert that the matched accounts have the correct website domain
		try {
			for (Account acc : matchedAccounts) {
				Boolean accountFound = false;
				for (Account testAccount : domainToAccount.get(testLeadDomain)) {
					if (acc.Id == testAccount.Id) {
						accountFound = true;
						System.assertEquals(testAccount.Website, acc.Website, 'Account website domain is incorrect.');
						break;
					}
				}
				Assert.isTrue(accountFound, 'Account not found in the matched accounts list.');
			}
		} catch (Exception ex) {
			Assert.fail('Exception thrown: ' + ex.getMessage());
		}
	}

	@IsTest
	static void testSetPrimaryContact() {
		// Create test data
		Account testAccount1 = new Account(Name = 'Test Account 1');
		insert testAccount1;

		Contact testContact1 = new Contact(FirstName = 'Zara', LastName = 'Smith', AccountId = testAccount1.Id);
		Contact testContact2 = new Contact(FirstName = 'Aaron', LastName = 'Johnson', AccountId = testAccount1.Id);
		insert new List<Contact>{ testContact1, testContact2 };

		Opportunity testOpp1 = new Opportunity(
			Name = 'Test Opp 1',
			StageName = 'Closed Won',
			CloseDate = Date.today(),
			AccountId = testAccount1.Id
		);
		insert testOpp1;

		// Call the method to test
		ExampleSOQL.setPrimaryContact();

		// Query for the updated Opportunity
		Opportunity updatedOpp = [SELECT Id, Primary_Contact__c FROM Opportunity WHERE Id = :testOpp1.Id];

		// Assert that the Primary Contact was set correctly
		System.assertEquals(testContact1.Id, updatedOpp.Primary_Contact__c, 'Primary Contact was not set correctly.');
	}
}
