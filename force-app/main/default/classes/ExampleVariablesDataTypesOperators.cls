public with sharing class ExampleVariablesDataTypesOperators {
	/**
	 * Performs addition of two numbers.
	 * Example: addition(1, 2) should return 3
	 * @param a The first number.
	 * @param b The second number.
	 * @return The sum of the two numbers, or null if either number is null.
	 */
	public static Integer addition(Integer a, Integer b) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Performs subtraction of two numbers.
	 * If either of the numbers is null, return null.
	 * Example: subtraction(1, 2) should return -1
	 * @param a The first number.
	 * @param b The second number.
	 * @return The difference between the two numbers.
	 */
	public static Integer subtraction(Integer a, Integer b) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Performs multiplication of two numbers.
	 * Example: multiplication(2, 3) should return 6
	 * @param a The first number.
	 * @param b The second number.
	 * @return The product of the two numbers.
	 */
	public static Integer multiplication(Integer a, Integer b) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Performs division of two numbers.
	 * If the denominator is zero, return 0 to avoid division by zero error.
	 * Example: division(6, 3) should return 2
	 * @param a The numerator.
	 * @param b The denominator.
	 * @return The quotient of the division, or 0 if the denominator is zero.
	 */
	public static Decimal division(Integer a, Integer b) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Checks if a number is odd.
	 * Example: isOdd(2) should return false
	 * This concept is not specifically covered in the content this week, but you can use the Math class and the modulus function to understand if the number is even or odd.
	 * The modulus function returns the remainder of a division operation, think about how you can use this to determine if a number is even or odd.
	 * Resources: https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_math.htm#apex_System_Math_mod
	 * @param num The number to check.
	 * @return True if the number is odd, False otherwise.
	 */
	public static Boolean isOdd(Integer num) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Checks if a number is negative.
	 * Example: isNegative(-2) should return true
	 * @param num The number to check.
	 * @return true if the number is negative, false otherwise.
	 */
	public static Boolean isNegative(Integer num) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Concatenates two strings.
	 * Example: concatenateStrings('Hello', 'World') should return 'HelloWorld'
	 * @param str1 The first string.
	 * @param str2 The second string.
	 * @return The concatenated string.
	 */
	public static String concatenateStrings(String str1, String str2) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Checks if a date is today or in the past.
	 * Example: isDateTodayOrPast(Date.newInstance(2019, 1, 1)) should return true if the current date is after 2019, 1, 1
	 * The concept of getting the current date is not specifically covered in the content this week, but you can use the Date class to get the current date.
	 * Resources: https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_date.htm#apex_System_Date_today
	 * @param dt The date to check.
	 * @return True if the date is today or in the past, False otherwise.
	 */
	public static Boolean isDateTodayOrPast(Date dt) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Converts the number of seconds to minutes.
	 * The conversion factor from seconds to minutes is a constant of 60.
	 * Formula: Minutes = seconds / 60
	 * Example: convertSecondsToMinutes(120) should return 2
	 * @param seconds The number of seconds.
	 * @return The number of minutes equivalent to the given number of seconds.
	 */
	public static Integer convertSecondsToMinutes(Integer seconds) {
		Integer SECONDS_PER_MINUTE;
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Calculates the average of two numbers.
	 * Formula: Average = (Sum of Numbers) ÷ 2
	 * Example: averageOfTwoNumbers(1, 3) should return 2.0
	 * @param a The first number.
	 * @param b The second number.
	 * @return The average of the two numbers.
	 */
	public static Double averageOfTwoNumbers(Integer a, Integer b) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Convert this double into an integer using casting
	 * @param num a number that may contain decimal points.
	 * @return Integer.
	 */
	public static Integer performIntegerCast(Decimal num) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Calculate the weekly and monthly paycheck based on hourly rate and number of hours.
	 * Weekly Paycheck is calculated by the formula: rate multiplied by hours.
	 * Monthly Paycheck is calculated by the formula: weekly paycheck multiplied by 4.
	 * Example: calculateMonthlyPaycheck(10.0, 40.0) should return 1600.0
	 * @param hourlyRate The rate of pay per hour.
	 * @param numberOfHours The number of hours worked in a week.
	 * @return A Decimal representing the monthly paycheck.
	 */
	public static Decimal calculateMonthlyPaycheck(Decimal hourlyRate, Double numberOfHours) {
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Calculate the yearly paycheck based on hourly rate and number of hours worked per week.
	 * Yearly Paycheck is calculated by the formula: (rate multiplied by hours) multiplied by 52.
	 * Example: calculateYearlyPaycheck(10.0, 40.0) should return 20800.0
	 * @param hourlyRate The rate of pay per hour.
	 * @param numberOfHours The number of hours worked in a week.
	 * @return A Decimal representing the yearly paycheck.
	 */
	public static Decimal calculateYearlyPaycheck(Decimal hourlyRate, Double numberOfHours) {
		return null; // Replace null with the variable you used to store the result
	}
}
