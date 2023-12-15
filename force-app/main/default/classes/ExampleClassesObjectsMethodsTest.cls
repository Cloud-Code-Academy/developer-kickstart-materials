@IsTest
public with sharing class ExampleClassesObjectsMethodsTest {
	@IsTest
	static void testStringOperationsAndChecks() {
		// Test with a string fulfilling all conditions
		List<String> result = ExampleClassesObjectsMethods.stringOperationsAndChecks('Hello, Salesforce!');
		List<String> expected = new List<String>{ '18', 'Hello', 'hello, salesforce!', 'true', 'false', 'true' };
		System.assertEquals(expected, result, 'Test failed for string Hello, Salesforce!');

		// Test with a string partially fulfilling conditions
		result = ExampleClassesObjectsMethods.stringOperationsAndChecks('Hi, Salesforce!');
		expected = new List<String>{ '15', 'Hi, S', 'hi, salesforce!', 'false', 'false', 'true' };
		System.assertEquals(expected, result, 'Test failed for string Hi, Salesforce!');

		// Test with a string not fulfilling the 'startsWith' and 'endsWith' conditions
		result = ExampleClassesObjectsMethods.stringOperationsAndChecks('Welcome to Sales Force');
		expected = new List<String>{ '22', 'Welco', 'welcome to sales force', 'false', 'true', 'true' };
		System.assertEquals(expected, result, 'Test failed for string Welcome to SalesForce');
	}

	@IsTest
	static void testUniqueSentenceAndVowelCount() {
		// Test with duplicates and vowels
		List<Integer> result = ExampleClassesObjectsMethods.uniqueSentenceAndVowelCount('Hello, Hello, Salesforce!');
		List<Integer> expected = new List<Integer>{ 2, 4 };
		System.assertEquals(expected, result, 'Incorrect vowel counts for "Hello, Hello, Salesforce!"');

		// Test with no duplicates
		result = ExampleClassesObjectsMethods.uniqueSentenceAndVowelCount('Unique Words Only');
		expected = new List<Integer>{ 4, 1, 1 };
		System.assertEquals(expected, result, 'Incorrect vowel counts for "Unique Words Only"');

		// Test with no vowels
		result = ExampleClassesObjectsMethods.uniqueSentenceAndVowelCount('Hll Wrl Wrl');
		expected = new List<Integer>{ 0, 0 };
		System.assertEquals(expected, result, 'Incorrect vowel counts for "Hll Wrl Wrl"');
	}

	@IsTest
	static void testGenerateRandomNumber() {
		// Generate a random number
		for (Integer i; i < 100; i++) {
			Integer randomNumber = ExampleClassesObjectsMethods.generateRandomNumber();
			// check the type of the result to ensure it's an Integer
			Assert.isInstanceOfType(randomNumber, Integer.class, 'The returned value is not of expected type Integer');

			// Assert that the random number is within the expected range (50 - 100)
			Boolean isWithinRange = randomNumber >= 0 && randomNumber <= 100;
			Assert.isTrue(
				isWithinRange,
				'The generated random number ' + randomNumber + ' is not within the expected range (50 - 100)'
			);
		}
	}

	@IsTest
	static void testGetMonthNumber() {
		// Test case for January
		System.assertEquals(
			1,
			ExampleClassesObjectsMethods.getMonthNumber('January'),
			'Incorrect month number for January'
		);

		// Test case for June
		System.assertEquals(6, ExampleClassesObjectsMethods.getMonthNumber('June'), 'Incorrect month number for June');

		// Test case for December
		System.assertEquals(
			12,
			ExampleClassesObjectsMethods.getMonthNumber('December'),
			'Incorrect month number for December'
		);

		// Test case for invalid month
		System.assertEquals(
			null,
			ExampleClassesObjectsMethods.getMonthNumber('NotAMonth'),
			'Should return null for invalid month name'
		);
	}

	/* UNCOMMENT TEST METHODS BELOW ONCE THE BOOK AND PERSON CLASSES ARE SET UP
	@IsTest
	static void testGetMoreAdvancedStudent() {
		// Test case: one student is PD1 certified and the other is not
		ExampleClassesObjectsMethods.Student student1 = new ExampleClassesObjectsMethods.Student('John', 50);
		student1.setPd1Certified(true);
		ExampleClassesObjectsMethods.Student student2 = new ExampleClassesObjectsMethods.Student('Jane', 70);
		System.assertEquals(
			student1,
			ExampleClassesObjectsMethods.getMoreAdvancedStudent(student1, student2),
			'PD1 certified student should be returned'
		);

		// Test case: both students are PD1 certified, but one is further in the program
		student1 = new ExampleClassesObjectsMethods.Student('John', 50);
		student1.setPd1Certified(true);
		student2 = new ExampleClassesObjectsMethods.Student('Jane', 70);
		student2.setPd1Certified(true);
		System.assertEquals(
			student2,
			ExampleClassesObjectsMethods.getMoreAdvancedStudent(student1, student2),
			'Student with higher program completion should be returned'
		);

		// Test case: neither student is PD1 certified, but one is further in the program
		student1 = new ExampleClassesObjectsMethods.Student('John', 50);
		student2 = new ExampleClassesObjectsMethods.Student('Jane', 70);
		System.assertEquals(
			student2,
			ExampleClassesObjectsMethods.getMoreAdvancedStudent(student1, student2),
			'Student with higher program completion should be returned'
		);

		// Test case: students are equally advanced
		student1 = new ExampleClassesObjectsMethods.Student('John', 80);
		student1.setPd1Certified(true);
		student2 = new ExampleClassesObjectsMethods.Student('Jane', 80);
		student2.setPd1Certified(true);
		// Either student could be returned, so assert true for both possibilities
		ExampleClassesObjectsMethods.Student result = ExampleClassesObjectsMethods.getMoreAdvancedStudent(
			student1,
			student2
		);
		System.assertEquals(null, result, 'Either equally advanced student should be returned');
	}
    */
}
