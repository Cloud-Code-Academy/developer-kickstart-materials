/*
 * Trigger Exercise Description
 * Complete the following exercises based on the tests.
 * Create triggers on Account and Opportunity with specific behaviors.
 *
 * Opportunity Trigger:
 * 1. Validate that the amount of an opportunity is greater than 5000 when it is inserted.
 * 2. Set the primary contact on an updated opportunity to the contact with the title of 'CEO' on the same account.
 * 
 * AnotherOpportunityTrigger: 
 * AnotherOpportunityTrigger has multiple issues relating to trigger bad practices. 
 * Update this trigger to follow best practices and ensure that it is bulkified. 
 * 
 * Combining Triggers: 
 * Combine the logic from both AnotherOpportunityTrigger and OpportunityTrigger into a single unified 
 * OpportunityTriggerHandler class by implementing the TriggerHandler framework provided. 
 * This handler will be responsible for all Opportunity-related trigger events. By consolidating the 
 * logic into one handler, you ensure more maintainable and organized code.
 * The OpportunityTriggerHandler class was not provided. You will need to create this class from scratch and extend the TriggerHandler class.
 * Some of the logic for AnotherOpportunityTrigger and OpportunityTrigger may conflict. 
 * Ensure that the logic is combined into one method and that the method is called from the appropriate trigger event.

 *
 * Test Class: ExampleTriggerBestPracticeTest
 * This test class should include methods to validate the correct behavior of each trigger based on the above requirements.
 *
 * RESOURCES:
 * - Trigger Context Variables: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_context_variables.htm
 * - Context Variable Considerations: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_context_variables_considerations.htm
 * - Get Started with Apex Triggers: https://trailhead.salesforce.com/content/learn/modules/apex_triggers/apex_triggers_intro
 * NOTE: Disable all duplicate rules in the org. This will help prevent errors in the test classes or triggers. https://help.salesforce.com/s/articleView?id=ind.Disable_Account_Duplicate_Rule_CAM_OS_Enabled.htm&type=5
 */
@IsTest
public with sharing class ExampleTriggerTest {
	/*
	 * Opportunity Trigger
	 * When an opportunity is inserted validate that the amount is greater than 5000.
	 * Trigger should only fire on update.
	 */
	@IsTest
	static void testOpportunityTrigger_amountValidation() {
		// Prepare the test data
		List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
		for (Integer i = 0; i < 400; i++) {
			Opportunity opp = new Opportunity(
				Name = 'Test Opportunity ' + i,
				CloseDate = Date.today().addDays(i),
				StageName = 'Prospecting',
				Amount = 1 // The initial Amount is greater than 5000
			);
			opportunitiesToInsert.add(opp);
		}

		Test.startTest();
		try {
			insert opportunitiesToInsert;
			System.assert(false, 'Expected an exception but did not get one.');
		} catch (DmlException e) {
			System.assert(
				e.getMessage().contains('Opportunity amount must be greater than 5000'),
				'The error message is not as expected message: ' + e.getMessage()
			);
		}

		Test.stopTest();
	}

	/*
	 * Opportunity Trigger
	 * When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
	 * Trigger should only fire on update.
	 */
	@IsTest
	static void testOpportunityTrigger_setPrimaryContact() {
		// Prepare the test data
		List<Account> accountsToInsert = new List<Account>();
		for (Integer i = 0; i < 10; i++) {
			Account testAccount = new Account(Name = 'Test Account ' + i);
			accountsToInsert.add(testAccount);
		}

		insert accountsToInsert;

		List<Contact> contactsToInsert = new List<Contact>();
		List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
		for (Account acc : accountsToInsert) {
			for (Integer i = 0; i < 10; i++) {
				Contact con = new Contact(
					FirstName = String.valueOf(i),
					LastName = 'Last Name ' + i,
					AccountId = acc.Id
				);
				if (i == 0) {
					con.Title = 'CEO';
					con.FirstName = 'Big Boss';
				}
				contactsToInsert.add(con);
			}

			for (Integer i = 0; i < 10; i++) {
				Opportunity opp = new Opportunity(
					Name = 'Test Opportunity ' + i,
					CloseDate = Date.today().addDays(i),
					StageName = 'Prospecting',
					Amount = 6000,
					AccountId = acc.Id,
					Primary_Contact__c = null
				);
				opportunitiesToInsert.add(opp);
			}
		}

		// Update the opportunities
		Test.startTest();

		insert contactsToInsert;
		insert opportunitiesToInsert;

		for (Opportunity opp : opportunitiesToInsert) {
			opp.Primary_Contact__c = null;
		}
		update opportunitiesToInsert;
		Test.stopTest();

		// Check that the primary contact is set correctly
		List<Opportunity> updatedOpportunities = [
			SELECT Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.Title
			FROM Opportunity
			WHERE Id IN :opportunitiesToInsert
		];
		for (Opportunity opp : updatedOpportunities) {
			System.assertNotEquals(null, opp.Primary_Contact__c, 'Primary contact was not set.');
			System.assertEquals(opp.Primary_Contact__r.FirstName, 'Big Boss', 'Primary contact was not set correctly.');
			System.assertEquals(opp.Primary_Contact__r.Title, 'CEO', 'Primary contact was not set correctly.');
		}
	}

	//Part 2 - AnotherOpportunityTrigger Refactor
	/*
	 * AnotherOpportunityTrigger was created by a previous developer and is causing some issues.
	 * The trigger does not follow best practices and needs to be refactored.
	 * Look for the following issues and refactor the trigger to follow best practices:
	 * - Avoid nested for loop - 1 instance
	 * - Avoid DML inside for loop - 1 instance
	 * - Bulkify Your Code - 1 instance
	 * - Avoid SOQL Query inside for loop - 2 instances
	 * - Stop recursion - 1 instance
	 * All of the AnotherOpportunityTrigger tests should pass if you have refactored the trigger correctly
	 */
	@IsTest
	private static void testAnotherOpportunityTrigger_setType() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		Integer numberOfOpps = 5;
		for (Integer i = 0; i < numberOfOpps; i++) {
			Opportunity opp = new Opportunity(
				Name = 'Test Opportunity ' + i,
				StageName = 'Prospecting',
				CloseDate = Date.today(),
				AccountId = acc.Id,
				Amount = 10000
			);
			insert opp;
		}

		List<Opportunity> opps = [SELECT Id, Name, Type FROM Opportunity WHERE AccountId = :acc.Id];
		System.assertEquals(numberOfOpps, opps.size(), 'Number of Opportunities created is incorrect.');
		for (Opportunity opp : opps) {
			System.assertEquals('New Customer', opp.Type, 'Opportunity ' + opp.Name + ' Type is incorrect.');
		}
	}

	@IsTest
	private static void testAnotherOpportunityTrigger_validateCloseOpportunity() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		List<Opportunity> oppsToInsert = new List<Opportunity>();
		oppsToInsert.add(
			new Opportunity(
				Name = 'Open Opp',
				StageName = 'Prospecting',
				CloseDate = Date.today(),
				AccountId = acc.Id,
				Amount = 10000
			)
		);
		oppsToInsert.add(
			new Opportunity(
				Name = 'Closed Won Opp',
				StageName = 'Closed Won',
				CloseDate = Date.today(),
				AccountId = acc.Id,
				Amount = 10000
			)
		);
		oppsToInsert.add(
			new Opportunity(
				Name = 'Closed Lost Opp',
				StageName = 'Closed Lost',
				CloseDate = Date.today(),
				AccountId = acc.Id,
				Amount = 10000
			)
		);

		insert oppsToInsert;

		List<Opportunity> opps = [SELECT Id, Name, StageName FROM Opportunity WHERE AccountId = :acc.Id];
		System.assertEquals(3, opps.size(), 'Number of Opportunities created is incorrect.');
		for (Opportunity opp : opps) {
			try {
				delete opp;
				if (opp.Name != 'Open Opp') {
					System.assert(false, 'Exception should have been thrown.');
				}
			} catch (Exception e) {
				if (opp.Name != 'Open Opp') {
					System.assert(
						e.getMessage().contains('Cannot delete closed opportunity'),
						'Exception message is incorrect.' + e.getMessage()
					);
				}
			}
		}
	}

	@IsTest
	private static void testAnotherOpportunityTrigger_insertTask() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		List<Opportunity> oppsToInsert = new List<Opportunity>();
		Integer numberOfOpps = 200;
		for (Integer i = 0; i < numberOfOpps; i++) {
			Opportunity opp = new Opportunity(
				Name = 'Test Opportunity ' + i,
				StageName = 'Prospecting',
				CloseDate = Date.today(),
				AccountId = acc.Id,
				Amount = 10000
			);
			oppsToInsert.add(opp);
		}

		insert oppsToInsert;

		List<Task> tasks = [SELECT Id, Subject, WhatId FROM Task WHERE WhatId IN :oppsToInsert];
		System.assertEquals(numberOfOpps, tasks.size(), 'Number of Tasks created is incorrect.');
	}

	@IsTest
	private static void testAnotherOpportunityTrigger_updateDescriptionFromStage() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		List<Opportunity> opps = new List<Opportunity>();
		Integer numberOfOpps = 10;
		for (Integer i = 0; i < numberOfOpps; i++) {
			Opportunity opp = new Opportunity(
				Name = 'Test Opportunity ' + i,
				StageName = 'Prospecting',
				CloseDate = Date.today(),
				AccountId = acc.Id,
				Amount = 10000
			);
			opps.add(opp);
		}
		insert opps;

		for (Opportunity opp : opps) {
			opp.StageName = 'Qualification';
		}
		update opps;

		List<Opportunity> updatedOpps = [SELECT Id, Description FROM Opportunity WHERE Id IN :opps];
		System.assertEquals(numberOfOpps, updatedOpps.size(), 'Number of Opportunities updated is incorrect.');
		for (Opportunity opp : updatedOpps) {
			System.assert(
				opp.Description.contains('Stage Change:Qualification'),
				'Opportunity Description is incorrect: ' + opp.Description
			);
		}
	}

	@IsTest
	private static void testAnotherOpportunityTrigger_notifyOwnersOpportunityDeleted() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		List<Opportunity> oppsToInsert = new List<Opportunity>();
		Integer numberOfOpps = 200;
		for (Integer i = 0; i < numberOfOpps; i++) {
			Opportunity opp = new Opportunity(
				Name = 'Test Opportunity ' + i,
				StageName = 'Prospecting',
				CloseDate = Date.today(),
				AccountId = acc.Id,
				Amount = 10000
			);
			oppsToInsert.add(opp);
		}

		insert oppsToInsert;

		delete oppsToInsert;
		List<Opportunity> opps = [SELECT Id, Name FROM Opportunity WHERE AccountId = :acc.Id];
		System.assertEquals(0, opps.size(), 'Number of Opportunities created is incorrect.');
	}

	@IsTest
	private static void testAnotherOpportunityTrigger_assignPrimaryContact() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		Contact primaryContact = new Contact(FirstName = 'Primary', LastName = 'Contact', AccountId = acc.Id);

		insert primaryContact;

		Contact notPrimaryContact = new Contact(
			FirstName = 'Not Primary',
			LastName = 'Contact',
			AccountId = acc.Id,
			Title = 'VP Sales'
		);

		insert notPrimaryContact;

		List<Opportunity> oppsToInsert = new List<Opportunity>();
		Integer numberOfOpps = 200;
		for (Integer i = 0; i < numberOfOpps; i++) {
			Opportunity opp = new Opportunity(
				Name = 'Test Opportunity ' + i,
				StageName = 'Prospecting',
				CloseDate = Date.today(),
				AccountId = acc.Id,
				Primary_Contact__c = primaryContact.Id,
				Amount = 10000
			);
			oppsToInsert.add(opp);
		}

		insert oppsToInsert;

		delete primaryContact;

		delete oppsToInsert;

		undelete oppsToInsert;

		Test.startTest();
		List<Opportunity> opps = [SELECT Id, Name, Primary_Contact__c FROM Opportunity WHERE AccountId = :acc.Id];
		System.assertEquals(numberOfOpps, opps.size(), 'Number of Opportunities created is incorrect.');
		List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE Id = :primaryContact.Id];
		System.assertEquals(0, contacts.size(), 'Primary Contact should not exist.');
		List<Contact> moreContact = [SELECT Id, Name FROM Contact];
		for (Opportunity opp : opps) {
			System.assertEquals(
				notPrimaryContact.Id,
				opp.Primary_Contact__c,
				'Opportunity Primary Contact is incorrect: ' + opp.Primary_Contact__c
			);
		}
		Test.stopTest();
	}
}
