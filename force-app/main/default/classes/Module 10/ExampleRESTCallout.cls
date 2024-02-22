public with sharing class ExampleRESTCallout {
	/*
	 * Fetches user information from an external system https://dummyjson.com/user/{id} ('DummyJsonUser') based on the provided dummy user ID.
	 * If the callout is successful and returns an HTTP status of 200
	 * Documentation: https://dummyjson.com/docs/users
	 *
	 * @param dummyUserId The ID of the user in the external system to fetch data for.
	 */

	public static String getUserFromId(String dummyUserId) {
		// Create HTTP request to send.

		// Set the endpoint URL. Use direct URL or for best practices use Named Credential.

		// Set the HTTP method to GET.

		// Send the HTTP request and get the response.

		// If the HTTP response code is successful, return the payload
		return null;
	}

	/*
	 * Sends Contact information to an external system https://dummyjson.com/users/add ('DummyJsonUser') to create or update a user based on the provided Salesforce Contact ID.
	 * The method prepares a JSON payload with the contact's information and sends it to the 'DummyJsonUser' add endpoint.
	 *
	 * Documentation: https://dummyjson.com/docs/users
	 *
	 * @param contactId The Salesforce Contact ID used to generate the JSON payload for the external system.
	 */

	public static String postAddUser() {
		// Create HTTP request to send.

		// Set the endpoint URL. Use direct URL or for best practices use Named Credential.

		// Set the HTTP method to POST.

		// Set the body

		// Send the HTTP request and get the response.

		// If the HTTP response code is successful, return the payload
		return null;
	}
}
