@isTest
public with sharing class ExampleDMLOperationsTest {
	@IsTest
	static void testCreateLeadWithValidData() {
		String lastName = 'Doe';
		String company = 'Acme Inc';

		Test.startTest();
		Lead newLead = ExampleDMLOperations.createLead(lastName, company);
		Test.stopTest();

		// Verify that the Lead was created and returned by the method
		System.assertNotEquals(null, newLead.Id, 'A lead record should be created');
		System.assertEquals(lastName, newLead.LastName, 'Lead last name should match');
		System.assertEquals(company, newLead.Company, 'Lead company should match');
	}

	@IsTest
	static void testCreateMultipleLeads() {
		List<String> lastNames = new List<String>{ 'Doe', 'Smith', 'Johnson' };
		String company = 'Acme Inc';

		Test.startTest();
		List<Lead> createdLeads = ExampleDMLOperations.createMultipleLeads(lastNames);
		Test.stopTest();

		// Verify that the correct number of leads were created
		System.assertEquals(lastNames.size(), createdLeads.size(), 'Incorrect number of leads created');

		// Verify each lead's details
		for (Integer i = 0; i < lastNames.size(); i++) {
			System.assertEquals(lastNames[i], createdLeads[i].LastName, 'Lead last name should match');
			System.assertEquals(company, createdLeads[i].Company, 'Lead company should match');
		}
	}

	@IsTest
	static void testUpdateCaseListBasedOnOrigin() {
		// Create test cases for different origins
		Case webCase = new Case(Origin = 'Web');
		Case emailCase = new Case(Origin = 'Email');
		Case phoneCase = new Case(Origin = 'Phone');

		// Insert test cases to ensure they have Ids
		insert new List<Case>{ webCase, emailCase, phoneCase };

		// Prepare list for method call
		List<Case> testCases = new List<Case>{ webCase, emailCase, phoneCase };

		Test.startTest();
		ExampleDMLOperations.updateCaseListBasedOnOrigin(testCases);
		Test.stopTest();

		// Query updated cases
		Map<Id, Case> updatedCases = new Map<Id, Case>(
			[SELECT Id, Origin, Description FROM Case WHERE Id IN :testCases]
		);

		// Verify cases are updated correctly based on Origin
		System.assertEquals(
			'Web Inquiry',
			updatedCases.get(webCase.Id).Description,
			'Description should be updated for Web origin'
		);
		System.assertEquals(
			'Email Inquiry',
			updatedCases.get(emailCase.Id).Description,
			'Description should be updated for Email origin'
		);
		System.assertEquals(
			'Phone Inquiry',
			updatedCases.get(phoneCase.Id).Description,
			'Description should be updated for Phone origin'
		);
	}

	@IsTest
	static void testUpsertAccount() {
		String accountName = 'Test Account';

		// Test creating a new account
		Test.startTest();
		Account upsertedAccount = ExampleDMLOperations.upsertAccount(accountName);

		// Verify that the account was created
		System.assertNotEquals(null, upsertedAccount.Id, 'Account should be created with an Id');
		System.assertEquals(accountName, upsertedAccount.Name, 'Account name should match');

		// Test updating the existing account
		String updatedAccountName = 'Test Account';
		upsertedAccount.Name = updatedAccountName;

		Account updatedAccount = ExampleDMLOperations.upsertAccount(updatedAccountName);
		Test.stopTest();

		// Verify that the account was updated
		System.assertEquals(updatedAccount.Id, upsertedAccount.Id, 'Account Id should remain the same after update');
	}

	@IsTest
	static void testUpsertAccountsWithContacts() {
		Account testAccount = new Account(Name = 'Doe');
		insert testAccount;
		// Create test contacts with last names matching account names
		List<Contact> testContacts = new List<Contact>{
			new Contact(LastName = 'Doe', FirstName = 'John'),
			new Contact(LastName = 'Smith', FirstName = 'Jane')
		};

		Test.startTest();
		ExampleDMLOperations.upsertAccountsWithContacts(testContacts);
		Test.stopTest();

		List<Account> accounts = [SELECT Id FROM Account];
		System.assertEquals(2, accounts.size(), 'Two accounts should be created');

		// Query the upserted contacts to verify account links
		List<Contact> upsertedContacts = [
			SELECT Id, LastName, AccountId, Account.Name
			FROM Contact
			WHERE Id IN :testContacts
		];
		for (Contact c : upsertedContacts) {
			System.assertNotEquals(null, c.AccountId, 'Contact should be linked to an Account');
			System.assertEquals(c.LastName, c.Account.Name, 'Contact last name should match Account name');
		}
	}

	@IsTest
	static void testInsertAndDeletePhoneLeads() {
		// Prepare test leads with different sources
		Lead phoneLead = new Lead(LastName = 'PhoneLead', Company = 'Test Company', LeadSource = 'Phone');
		Lead webLead = new Lead(LastName = 'WebLead', Company = 'Test Company', LeadSource = 'Web');

		// Create a list of leads
		List<Lead> leads = new List<Lead>{ phoneLead, webLead };
		insert leads;

		Test.startTest();
		ExampleDMLOperations.insertAndDeletePhoneLeads(leads);
		Test.stopTest();

		// Query to check remaining leads
		List<Lead> remainingLeads = [
			SELECT Id, LastName
			FROM Lead
			WHERE LastName IN :new List<String>{ 'PhoneLead', 'WebLead' }
		];

		// Assert that only the web lead remains
		System.assertEquals(1, remainingLeads.size(), 'Only one lead should remain');
		System.assertEquals('WebLead', remainingLeads[0].LastName, 'Only the web lead should remain');
	}
}
