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
		HttpRequest request = new HttpRequest();

		// Set the endpoint URL. Use direct URL or for best practices use Named Credential.
		request.setEndpoint('https://dummyjson.com/users' + '/' + dummyUserId);
		// request.setHeader('Authorization', 'Token token');
		// request.setEndpoint('callout:DummyJSON' + '/' + dummyUserId);

		// Set the HTTP method to GET.
		request.setMethod('GET');
		Http http = new Http();
		HttpResponse response = http.send(request);

		// Send the HTTP request and get the response.
		if (response.getStatusCode() == 200) {
			return response.getBody();
		} else {
			return null;
		}
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
		HttpRequest request = new HttpRequest();

		// Set the endpoint URL. Use direct URL or for best practices use Named Credential.
		request.setEndpoint('https://dummyjson.com/users/add');

		// Set the HTTP method to POST.
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');

		// Set the body
		String body = '{ "firstName": "Warren", "lastName": "Walters", "email": "warren@cloudcodeacademy.com", "age" : 35 }';
		Map<String, Object> jsonMap = new Map<String, Object>();
		jsonMap.put('firstName', 'Warren');
		jsonMap.put('lastName', 'Walters');
		jsonMap.put('email', 'warren@cloudcodeacademy.com');
		jsonMap.put('age', 35);
		body = JSON.serialize(jsonMap);

		// Send the HTTP request and get the response.
		request.setBody(body);
		Http http = new Http();
		HttpResponse response = http.send(request);

		// If the HTTP response code is successful, return the payload
		if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
			return response.getBody();
		}
		return null;
	}
}
