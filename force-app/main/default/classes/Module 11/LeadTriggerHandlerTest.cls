@isTest
public with sharing class LeadTriggerHandlerTest {
	@testSetup
	static void setup() {
		// Create a list of leads to be used in tests
		List<Lead> leads = new List<Lead>{
			new Lead(
				LastName = 'Test Lead Web Email',
				Company = 'Test Company',
				LeadSource = 'Web',
				Email = 'test@example.com'
			),
			new Lead(LastName = 'Test Lead Phone', Company = 'Test Company', Phone = '1234567890'),
			new Lead(LastName = 'Test Lead Tech Industry', Company = 'Test Company', Industry = 'Technology'),
			new Lead(
				LastName = 'Test Lead All Criteria',
				Company = 'Test Company',
				LeadSource = 'Web',
				Email = 'allcriteria@example.com',
				Phone = '1234567890',
				Industry = 'Technology'
			),
			new Lead(LastName = 'Test Lead No Criteria', Company = 'Test Company') // This lead does not match any criteria
		};

		// Insert the leads
		insert leads;
	}

	@IsTest
	static void testHandleTitleNormalization() {
		// Set up test data
		List<Lead> testLeads = new List<Lead>{
			new Lead(FirstName = 'Test', LastName = 'VP', Title = 'vp', Company = 'Cloud Code'),
			new Lead(FirstName = 'Test', LastName = 'Manager', Title = 'mgr', Company = 'Cloud Code'),
			new Lead(FirstName = 'Test', LastName = 'Executive', Title = 'exec', Company = 'Cloud Code'),
			new Lead(FirstName = 'Test', LastName = 'Assistant', Title = 'assist', Company = 'Cloud Code'),
			new Lead(FirstName = 'Test', LastName = 'NoChange', Title = 'NoChange', Company = 'Cloud Code') // This should not match any condition
		};

		// Insert the test leads to set their Ids, necessary for DML operations inside the tested method
		insert testLeads;

		Test.startTest();
		// Call the method to test
		LeadTriggerHandler.handleTitleNormalization(testLeads);
		Test.stopTest();

		// Query back the leads to assert changes
		List<Lead> updatedLeads = [SELECT Title FROM Lead WHERE Id IN :testLeads];

		// Assert the expected title normalization
		System.assertEquals('Vice President', updatedLeads[0].Title, 'The VP title was not normalized correctly.');
		System.assertEquals('Manager', updatedLeads[1].Title, 'The Manager title was not normalized correctly.');
		System.assertEquals('Executive', updatedLeads[2].Title, 'The Executive title was not normalized correctly.');
		System.assertEquals('Assistant', updatedLeads[3].Title, 'The Assistant title was not normalized correctly.');
		System.assertEquals('NoChange', updatedLeads[4].Title, 'The NoChange title should not have been altered.');
	}

	@IsTest
	static void testHandleAutoLeadScoring() {
		// Query leads inserted by testSetup method
		List<Lead> leadsToScore = [SELECT Id, LeadSource, Email, Phone, Industry, Lead_Score__c FROM Lead];

		// Call the method to test
		Test.startTest();
		LeadTriggerHandler.handleAutoLeadScoring(leadsToScore);
		Test.stopTest();

		// Update leads to save the scores
		update leadsToScore;

		// Re-query leads to verify scores
		Map<Id, Lead> scoredLeads = new Map<Id, Lead>(
			[SELECT Id, Lead_Score__c, LeadSource, Email, Phone, Industry, LastName FROM Lead]
		);

		// Assert the scores are correctly assigned
		for (Lead ld : scoredLeads.values()) {
			Integer expectedScore = 0;
			if (ld.LeadSource == 'Web' && ld.Email != null) {
				expectedScore += 3;
			}
			if (ld.Phone != null) {
				expectedScore += 5;
			}
			if (ld.Industry == 'Technology') {
				expectedScore += 10;
			}

			System.assertEquals(expectedScore, ld.Lead_Score__c, 'Incorrect score for Lead: ' + ld.LastName);
		}
	}

	@IsTest
	static void testAutoConvertLeadWithMatchingEmail() {
		String accountName = 'Test Account';
		Account testAccount = TestDataFactory.createAccount(accountName);
		// Setup - Create a contact
		String testEmail = 'test@example.com';
		Contact testContact = TestDataFactory.createContact(testAccount.Id, testEmail);

		// Create a lead with the same email
		List<Lead> testLeads = TestDataFactory.createLeads(1, testEmail);

		Test.startTest();
		// Test the auto convert method by inserting the lead
		insert testLeads;
		Test.stopTest();

		// Verify the lead was converted
		Lead convertedLead = [SELECT IsConverted, ConvertedContactId FROM Lead WHERE Id = :testLeads[0].Id];
		System.assert(convertedLead.IsConverted, 'Lead should be converted.');
		System.assertEquals(
			testContact.Id,
			convertedLead.ConvertedContactId,
			'Lead was not converted to the correct contact.'
		);
	}
}
