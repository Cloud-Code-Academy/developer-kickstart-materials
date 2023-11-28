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

	/**
	 * Generate a string where the input string is repeated the given number of times, with each
	 * repetition separated by a semicolon.
	 * Do not add a semicolon after the last repetition.
	 * Example: repeatString("Hello World!", 3) should return "Hello World!; Hello World!; Hello World!"
	 * @param inputString The string to be repeated.
	 * @param repeatCount The number of times the string should be repeated.
	 * @return The new string with the inputString repeated repeatCount times.
	 */
	public static String repeatString(String inputString, Integer repeatCount) {
		if (String.isBlank(inputString) || repeatCount <= 0) {
			return '';
		}

		// Initialize the result String
		String result = '';

		// Use a for loop to append the inputString to the result string repeatCount times
		for (Integer i = 0; i < repeatCount; i++) {
			result += inputString;

			// If it is not the last iteration, add a semicolon to separate the strings
			if (i < repeatCount - 1) {
				result += '; ';
			}
		}

		// Return the final result string
		return result;
	}

	/**
	 * Create a list filled with even integers up to the input parameter.
	 * Example: createEvenIntegerList(6) should return [2, 4, 6]
	 * @param n The upper bound for the List.
	 * @return A List of even integers from 2 to 'n' (inclusive if 'n' is even).
	 */
	public static List<Integer> createEvenIntegerList(Integer n) {
		List<Integer> evenIntegerList = new List<Integer>();
		for (Integer i = 2; i <= n; i += 2) {
			evenIntegerList.add(i);
		}
		return evenIntegerList;
	}

	/**
	 * Iterates over a list of integers and sums only the negative integers.
	 * Example: sumNegativeIntegers() should return -9
	 * @return The sum of negative integers from the list.
	 */
	public static Integer sumNegativeIntegers(List<Integer> numbers) {
		Integer sum = 0;
		for (Integer num : numbers) {
			if (num > 0) {
				continue;
			}
			sum += num;
		}

		return sum;
	}

	/**
	 * Create a map where the keys are the names of employees and the values are their departments.
	 * The method then returns the department of the employee whose name is passed as an argument.
	 * Example: getDepartment("John Doe") should return "Engineering"
	 * @param employeeName The name of the employee.
	 * @return The department of the employee, or null if the employee is not found in the Map.
	 */
	public static String getDepartment(String employeeName) {
		// Initialize a Map
		Map<String, String> employeeDepartments = new Map<String, String>();

		// Add key-value pairs to the Map
		employeeDepartments.put('John Doe', 'Engineering');
		employeeDepartments.put('Jane Smith', 'Marketing');
		employeeDepartments.put('Sam Brown', 'Human Resources');
		employeeDepartments.put('Alice Johnson', 'Finance');

		// Get the department of the employee
		String department = employeeDepartments.get(employeeName);

		// Return the department of the employee, or null if the employee is not found in the Map
		return department;
	}
}
