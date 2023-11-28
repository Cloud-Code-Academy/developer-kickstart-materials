@IsTest
private class ExampleFlowControlLoopsCollectionsTest {
	@IsTest
	static void testHelloWorld() {
		// Test case when x > y
		String result = ExampleFlowControlLoopsCollections.helloWorld(10, 5);
		Assert.areEqual('Hello World!', result, 'Incorrect result for x > y');

		// Test case when x = y
		result = ExampleFlowControlLoopsCollections.helloWorld(5, 5);
		Assert.isNull(result, 'Incorrect result for x = y');

		// Test case when x < y
		result = ExampleFlowControlLoopsCollections.helloWorld(5, 10);
		Assert.isNull(result, 'Incorrect result for x < y');

		// Test case when x is null
		result = ExampleFlowControlLoopsCollections.helloWorld(null, 10);
		Assert.isNull(result, 'Incorrect result for null x');

		// Test case when y is null
		result = ExampleFlowControlLoopsCollections.helloWorld(10, null);
		Assert.isNull(result, 'Incorrect result for null y');

		// Test case when both x and y are null
		result = ExampleFlowControlLoopsCollections.helloWorld(null, null);
		Assert.isNull(result, 'Incorrect result for both x and y null');
	}

	@isTest
	static void testCanRideRollerCoaster() {
		// Test case 1: Height is exactly 48 inches
		System.assert(
			ExampleFlowControlLoopsCollections.canRideRollerCoaster(48),
			'Person should be able to ride the roller coaster'
		);

		// Test case 2: Height is more than 48 inches
		System.assert(
			ExampleFlowControlLoopsCollections.canRideRollerCoaster(55),
			'Person should be able to ride the roller coaster'
		);

		// Test case 3: Height is less than 48 inches
		System.assert(
			!ExampleFlowControlLoopsCollections.canRideRollerCoaster(45),
			'Person should not be able to ride the roller coaster'
		);
	}

	@isTest
	static void testFindMin() {
		// Test case with first number smaller
		Integer result = ExampleFlowControlLoopsCollections.findMin(10, 20);
		System.assertEquals(10, result, 'Incorrect min value for 10 and 20');

		// Test case with second number smaller
		result = ExampleFlowControlLoopsCollections.findMin(30, 20);
		System.assertEquals(20, result, 'Incorrect min value for 30 and 20');

		// Test case with equal numbers
		result = ExampleFlowControlLoopsCollections.findMin(25, 25);
		System.assertEquals(25, result, 'Incorrect min value for 25 and 25');

		// Test case with one null value
		result = ExampleFlowControlLoopsCollections.findMin(null, 40);
		System.assertEquals(null, result, 'Result should be null for null input');

		// Test case with both null values
		result = ExampleFlowControlLoopsCollections.findMin(null, null);
		System.assertEquals(null, result, 'Result should be null for both null inputs');
	}

	@isTest
	static void testDetermineSpeedClass() {
		// Test case for Speed Class A
		String result = ExampleFlowControlLoopsCollections.determineSpeedClass(22);
		System.assertEquals('A', result, 'Incorrect speed class for 22 km/h');

		// Test case for Speed Class B
		result = ExampleFlowControlLoopsCollections.determineSpeedClass(17);
		System.assertEquals('B', result, 'Incorrect speed class for 17 km/h');

		// Test case for Speed Class C
		result = ExampleFlowControlLoopsCollections.determineSpeedClass(12);
		System.assertEquals('C', result, 'Incorrect speed class for 12 km/h');

		// Test case for Speed Class D
		result = ExampleFlowControlLoopsCollections.determineSpeedClass(7);
		System.assertEquals('D', result, 'Incorrect speed class for 7 km/h');

		// Test case for Speed Class E
		result = ExampleFlowControlLoopsCollections.determineSpeedClass(3);
		System.assertEquals('E', result, 'Incorrect speed class for 3 km/h');

		// Test boundary conditions
		System.assertEquals(
			'A',
			ExampleFlowControlLoopsCollections.determineSpeedClass(20),
			'Boundary condition failed for 20 km/h'
		);
		System.assertEquals(
			'B',
			ExampleFlowControlLoopsCollections.determineSpeedClass(15),
			'Boundary condition failed for 15 km/h'
		);
		System.assertEquals(
			'C',
			ExampleFlowControlLoopsCollections.determineSpeedClass(10),
			'Boundary condition failed for 10 km/h'
		);
		System.assertEquals(
			'D',
			ExampleFlowControlLoopsCollections.determineSpeedClass(5),
			'Boundary condition failed for 5 km/h'
		);

		// Test negative speeds
		System.assertEquals(
			'E',
			ExampleFlowControlLoopsCollections.determineSpeedClass(-1),
			'Negative speed should classify as E'
		);

		// Test extremely high speeds
		System.assertEquals(
			'A',
			ExampleFlowControlLoopsCollections.determineSpeedClass(1000),
			'Extremely high speed should classify as A'
		);

		// Test zero speed
		System.assertEquals(
			'E',
			ExampleFlowControlLoopsCollections.determineSpeedClass(0),
			'Zero speed should classify as E'
		);

		// If the method were to accept Integer objects:
		// Test null input
		System.assertEquals(
			'E',
			ExampleFlowControlLoopsCollections.determineSpeedClass(null),
			'Null input should classify as E'
		);
	}

	@IsTest
	static void testRepeatString() {
		String result = ExampleFlowControlLoopsCollections.repeatString('Hello World!', 3);
		Assert.areEqual(
			'Hello World!; Hello World!; Hello World!',
			result,
			'Incorrect result for repeatString with count 3'
		);

		result = ExampleFlowControlLoopsCollections.repeatString('Supra', 5);
		Assert.areEqual('Supra; Supra; Supra; Supra; Supra', result, 'Incorrect result for repeatString with count 5');

		result = ExampleFlowControlLoopsCollections.repeatString('ABC', 2);
		Assert.areEqual('ABC; ABC', result, 'Incorrect result for repeatString with count 2');

		result = ExampleFlowControlLoopsCollections.repeatString('', 3);
		Assert.areEqual('', result, 'Empty string should return an empty result');

		// Test with repeat count of zero
		result = ExampleFlowControlLoopsCollections.repeatString('Test', 0);
		Assert.areEqual('', result, 'Zero repeat count should return an empty result');

		// Test with negative repeat count
		result = ExampleFlowControlLoopsCollections.repeatString('Test', -1);
		Assert.areEqual('', result, 'Negative repeat count should be handled gracefully');

		// Test with single repetition
		result = ExampleFlowControlLoopsCollections.repeatString('Single', 1);
		Assert.areEqual('Single', result, 'Single repetition should return the string itself');

		// Test with special characters
		result = ExampleFlowControlLoopsCollections.repeatString('#$%', 2);
		Assert.areEqual('#$%; #$%', result, 'String with special characters should be repeated correctly');

		// Test with a large repeat count
		result = ExampleFlowControlLoopsCollections.repeatString('Repeat', 100);
		// Assertion for large repeat count might be lengthy - consider logic to validate this case
	}

	@IsTest
	static void testCreateEvenIntegerList() {
		// Test case with even upper bound
		List<Integer> result = ExampleFlowControlLoopsCollections.createEvenIntegerList(6);
		List<Integer> expected = new List<Integer>{ 2, 4, 6 };
		System.assertEquals(expected, result, 'Incorrect list for even upper bound 6');

		// Test case with odd upper bound
		result = ExampleFlowControlLoopsCollections.createEvenIntegerList(5);
		expected = new List<Integer>{ 2, 4 };
		System.assertEquals(expected, result, 'Incorrect list for odd upper bound 5');

		// Test case with upper bound less than 2
		result = ExampleFlowControlLoopsCollections.createEvenIntegerList(1);
		expected = new List<Integer>{};
		System.assertEquals(expected, result, 'List should be empty for upper bound 1');

		// Test case with upper bound as 0
		result = ExampleFlowControlLoopsCollections.createEvenIntegerList(0);
		expected = new List<Integer>{};
		System.assertEquals(expected, result, 'List should be empty for upper bound 0');

		// Test case with negative upper bound
		result = ExampleFlowControlLoopsCollections.createEvenIntegerList(-4);
		expected = new List<Integer>{};
		System.assertEquals(expected, result, 'List should be empty for negative upper bound -4');
	}

	@IsTest
	static void testSumNegativeIntegers() {
		// Test case with mix of positive and negative numbers
		Integer result = ExampleFlowControlLoopsCollections.sumNegativeIntegers(
			new List<Integer>{ -1, 2, -3, 4, -5, 6 }
		);
		System.assertEquals(-9, result, 'Sum of negative numbers should be -9');

		// Test case with only positive numbers
		result = ExampleFlowControlLoopsCollections.sumNegativeIntegers(new List<Integer>{ 1, 2, 3 });
		System.assertEquals(0, result, 'Sum should be 0 with only positive numbers');

		// Test case with only negative numbers
		result = ExampleFlowControlLoopsCollections.sumNegativeIntegers(new List<Integer>{ -1, -2, -3 });
		System.assertEquals(-6, result, 'Sum of negative numbers should be -6');

		// Test case with no numbers
		result = ExampleFlowControlLoopsCollections.sumNegativeIntegers(new List<Integer>{});
		System.assertEquals(0, result, 'Sum should be 0 with no numbers');
	}

	@IsTest
	static void testGetDepartment() {
		// Test case for an employee in the Map
		String department = ExampleFlowControlLoopsCollections.getDepartment('John Doe');
		System.assertEquals('Engineering', department, 'Incorrect department for John Doe');

		// Test case for an employee not in the Map
		department = ExampleFlowControlLoopsCollections.getDepartment('Mike Wilson');
		System.assert(department == null, 'Department should be null for an unknown employee');

		// Test case for another employee in the Map
		department = ExampleFlowControlLoopsCollections.getDepartment('Jane Smith');
		System.assertEquals('Marketing', department, 'Incorrect department for Jane Smith');

		// Test case with empty string as input
		department = ExampleFlowControlLoopsCollections.getDepartment('');
		System.assert(department == null, 'Department should be null for empty string input');

		// Test case with null input (if method signature allows)
		department = ExampleFlowControlLoopsCollections.getDepartment(null);
		System.assert(department == null, 'Department should be null for null input');
	}
}
