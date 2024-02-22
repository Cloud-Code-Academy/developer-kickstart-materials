@IsTest
public with sharing class ExampleRESTCalloutTest {
	@IsTest
	static void testGetUserFromId() {
		// Set up the mock response generator
		Test.setMock(HttpCalloutMock.class, new ExampleRESTCalloutMockGenerator());

		// Call the method to test
		String result = ExampleRESTCallout.getUserFromId('1');

		// Assert the response is as expected
		System.assertNotEquals(null, result, 'The response should not be null');
		Map<String, Object> userData = (Map<String, Object>) JSON.deserializeUntyped(result);
		System.assertEquals('Johnny', userData.get('firstName'), 'The firstName does not match');
	}

	@IsTest
	static void testPostAddUser() {
		// Set up the mock response generator
		Test.setMock(HttpCalloutMock.class, new ExampleRESTCalloutMockGenerator());

		// Call the method to test
		String result = ExampleRESTCallout.postAddUser();

		// Assert the response is as expected
		System.assertNotEquals(null, result, 'The response should not be null');
		Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(result);
		System.assertEquals('success', response.get('status'), 'The status does not match expected value');
	}
}
