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
			null,
			ExampleFlowControlLoopsCollections.determineSpeedClass(null),
			'Null input should return null'
		);
	}
}
