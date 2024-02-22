public with sharing class ExampleRESTCalloutMockGenerator {
	public HTTPResponse respond(HTTPRequest req) {
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');

		// Check if the request is a POST request
		if (req.getMethod() == 'POST') {
			// Return a success response for the POST request
			res.setBody('{"status": "success"}');
		} else {
			// Return the dummy user details for the GET request
			res.setBody(
				'{"email": "test@example.com", "phone": "+123456789", "birthDate": "1990-01-01", "address": {"address": "123 Test St", "city": "Test City", "postalCode": "12345", "state": "TS", "country": "Testland"}}'
			);
		}
		res.setStatusCode(200);
		return res;
	}
}
