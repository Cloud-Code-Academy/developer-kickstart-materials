/*
 * Complete the following exercises based on the tests.
 * Create triggers on account and on opportunity.
 *
 * Account trigger should do the following:
 * 1. Set the account type to prospect.
 * 2. Copy the shipping address to the billing address.
 * 3. Set the account rating to hot.
 * 4. Create a contact for each account inserted.
 *
 * Opportunity trigger should do the following:
 * 1. Validate that the amount is greater than 5000.
 * 2. Prevent the deletion of a closed won opportunity for a banking account.
 * 3. Set the primary contact on the opportunity to the contact with the title of CEO.
 *
 * RESOURCES:
 * - Trigger Context Variables: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_context_variables.htm
 * - Context Variable Considerations: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_context_variables_considerations.htm
 * - Get Started with Apex Triggers: https://trailhead.salesforce.com/content/learn/modules/apex_triggers/apex_triggers_intro
 * NOTE: Disable all duplicate rules in the org. This will help prevent errors in the test classes or triggers. https://help.salesforce.com/s/articleView?id=ind.Disable_Account_Duplicate_Rule_CAM_OS_Enabled.htm&type=5
 */
@IsTest
public with sharing class TriggerTest {
	/*
	 * Account Trigger
	 * When an account is inserted set the rating to 'Hot' if the Phone, Website, and Fax ALL have a value.
	 * Trigger should only fire on insert.
	 */
	@IsTest
	static void testAccountTrigger_setRating() {
		// Prepare the test data
		List<Account> accountsToInsert = new List<Account>();
		List<Account> accountsNotHot = new List<Account>();
		for (Integer i = 0; i < 400; i++) {
			if (Math.mod(0, 2) == 0) {
				Account acc = new Account(
					Name = 'Test Account ' + i,
					Phone = '1234567890',
					Website = 'www.testwebsite' + i + '.com',
					Fax = '0987654321'
				);
				accountsToInsert.add(acc);
			} else {
				Account acc = new Account(Name = 'Test Account ' + i, Rating = 'Warm');
				accountsNotHot.add(acc);
			}
		}

		// Perform the test
		Test.startTest();
		insert accountsToInsert;
		insert accountsNotHot;
		Test.stopTest();

		// Retrieve the accounts again
		List<Account> insertedAccounts = [SELECT Id, Rating FROM Account WHERE Id IN :accountsToInsert];

		// Assert that the Rating field has been correctly set to 'Hot' for each account
		for (Integer i = 0; i < insertedAccounts.size(); i++) {
			System.assertEquals(
				'Hot',
				insertedAccounts[i].Rating,
				'Rating not correctly set to Hot for account ' + i + '.'
			);
			insertedAccounts[i].Rating = null;
		}

		update insertedAccounts;
		List<Account> updatedAccounts = [SELECT Id, Rating FROM Account WHERE Id IN :insertedAccounts];
		for (Account acc : updatedAccounts) {
			System.assertEquals(null, acc.Rating, 'Rating should not change on update.');
		}

		// Retrieve the accounts again
		List<Account> insertedAccountsNotHot = [SELECT Id, Rating FROM Account WHERE Id IN :accountsNotHot];

		// Assert that the Rating field has not been changed for each account
		for (Integer i = 0; i < insertedAccountsNotHot.size(); i++) {
			System.assertEquals(
				'Warm',
				insertedAccountsNotHot[i].Rating,
				'Rating incorrectly changed for account ' + i + '.'
			);
		}
	}

	@IsTest
	static void testAccountTrigger_defaultCase() {
		// Prepare the test data
		List<Account> accountsToInsert = new List<Account>();
		for (Integer i = 0; i < 200; i++) {
			accountsToInsert.add(new Account(Name = 'Test Account ' + i));
		}

		// Perform the test
		Test.startTest();
		insert accountsToInsert;
		Test.stopTest();

		// Retrieve the newly created Cases
		List<Case> cases = [
			SELECT Id, Subject, Status, Priority, AccountId
			FROM Case
			WHERE AccountId IN :accountsToInsert
		];

		// Assert that the correct number of Cases has been created
		System.assertEquals(200, cases.size(), 'Incorrect number of Cases created.');

		// Assert that each Case has the expected field values
		for (Case c : cases) {
			System.assertEquals('Default Case', c.Subject, 'Case Subject is incorrect.');
			System.assertEquals('New', c.Status, 'Case Status is incorrect.');
			System.assertEquals('Medium', c.Priority, 'Case Priority is incorrect.');
			System.assertNotEquals(null, c.AccountId, 'Case AccountId is null.');
		}
	}

	/*
	 * Opportunity Trigger
	 * When an opportunity is updated validate that the amount is greater than 5000.
	 * Error Message: 'Opportunity amount must be greater than 5000'
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
				Amount = 6000 // The initial Amount is greater than 5000
			);
			opportunitiesToInsert.add(opp);
		}
		insert opportunitiesToInsert;

		List<Opportunity> oppsTriggerValidation = new List<Opportunity>();
		List<Opportunity> oppsNotTriggerValidation = new List<Opportunity>();
		// Try to update the opportunities to have an Amount less than 5000
		for (Integer i = 0; i < 400; i++) {
			if (Math.mod(i, 2) == 0) {
				opportunitiesToInsert[i].Amount = 4000;
				oppsTriggerValidation.add(opportunitiesToInsert[i]);
			} else {
				opportunitiesToInsert[i].Amount = 8000;
				oppsNotTriggerValidation.add(opportunitiesToInsert[i]);
			}
		}

		// Perform the test and assert that an error is thrown
		Test.startTest();
		try {
			update opportunitiesToInsert;
			System.assert(false, 'Expected an exception but did not get one.');
		} catch (DmlException e) {
			System.assert(
				e.getMessage().contains('Opportunity amount must be greater than 5000'),
				'The error message is not as expected. Message: ' + e.getMessage()
			);
		}

		// Assert that the opportunities that should not trigger the validation rule have been updated
		update oppsNotTriggerValidation;
		List<Opportunity> oppsNotTriggerValidationUpdated = [
			SELECT Id, Amount
			FROM Opportunity
			WHERE Id IN :oppsNotTriggerValidation
		];
		for (Opportunity opp : oppsNotTriggerValidationUpdated) {
			System.assertEquals(8000, opp.Amount, 'Opportunity Amount is incorrect.');
		}
		Test.stopTest();
	}

	/*
	 * Opportunity Trigger
	 * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
	 * Error Message: 'Cannot delete closed opportunity for a banking account that is won'
	 * Trigger should only fire on delete.
	 */
	@IsTest
	static void testOpportunityTrigger_deleteCloseWonOpportunity() {
		// Prepare the test data
		Account testAccount = new Account(Name = 'Test Account', Industry = 'Banking');
		insert testAccount;

		List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
		for (Integer i = 0; i < 400; i++) {
			Opportunity opp = new Opportunity(
				Name = 'Test Opportunity ' + i,
				CloseDate = Date.today().addDays(i),
				StageName = 'Closed Won',
				Amount = 6000,
				AccountId = testAccount.Id
			);
			opportunitiesToInsert.add(opp);
		}
		insert opportunitiesToInsert;

		// Try to delete the opportunities
		Test.startTest();
		try {
			delete opportunitiesToInsert;
			System.assert(false, 'Expected an exception but did not get one.');
		} catch (DmlException e) {
			System.assert(
				e.getMessage().contains('Cannot delete closed opportunity for a banking account that is won'),
				'The error message is not as expected.'
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
}
