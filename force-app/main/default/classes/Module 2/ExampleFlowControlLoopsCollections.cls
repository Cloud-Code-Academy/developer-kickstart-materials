public with sharing class ExampleFlowControlLoopsCollections {
	/**
	 * Compares two numbers and return "Hello World!" x is greater than the y.
	 * If either of the numbers is null or x is less than y, return null.
	 * Example: helloWorld(40, 10) should return "Hello World!"
	 * @param x The first number.
	 * @param y The second number.
	 * @return "Hello World!" if x greater than y, otherwise return null.
	 */
	public static String helloWorld(Integer x, Integer y) {
		if (x > y) {
			return 'Hello World!';
		}

		return null;
	}

	/**
	 * Checks if a person is tall enough to ride a roller coaster.
	 * A person can ride the roller coaster if they are 48 inches tall or taller.
	 * If the height is less than 48 inches, the method will return false.
	 * Example: canRideRollerCoaster(50) should return true
	 * @param height The height of the person in inches.
	 * @return true if the person is tall enough to ride the roller coaster, false otherwise.
	 */
	public static Boolean canRideRollerCoaster(Integer height) {
		// Initialize canRide as false
		Boolean canRide = false;

		if (height >= 48) {
			// Update canRide to true if the height is 48 or more
			canRide = true;
		}

		// Return the ability to ride the roller coaster
		return canRide;
	}

	/**
	 * Finds the minimum of two numbers.
	 * If both numbers are equal, it returns that number.
	 * Example: findMin(58, 200) should return 58
	 * @param num1 The first number.
	 * @param num2 The second number.
	 * @return The minimum of the two numbers, or null if either number is null.
	 */
	public static Integer findMin(Integer num1, Integer num2) {
		// Check for null values
		if (num1 == null || num2 == null) {
			return null;
		}

		// Use Math.min to find the smallest number
		return Math.min(num1, num2);
	}

	/**
	 * Determines the speed class based on the runner's average speed.
	 * Speed Class A if speed is greater than or equal to 20.
	 * Speed Class B if speed is greater than or equal to 15.
	 * Speed Class C if speed is greater than or equal to 10.
	 * Speed Class D if speed is greater than or equal to 5.
	 * Speed Class E otherwise.
	 * Example: determineSpeedClass(17) should return "B"
	 * @param speed The runner's average speed in km/h.
	 * @return The speed class for the given speed.
	 */
	public static String determineSpeedClass(Integer speed) {
		String speedClass;

		if (speed >= 20) {
			speedClass = 'A';
		} else if (speed >= 15) {
			speedClass = 'B';
		} else if (speed >= 10) {
			speedClass = 'C';
		} else if (speed >= 5) {
			speedClass = 'D';
		} else {
			speedClass = 'E';
		}

		return speedClass;
	}
}
