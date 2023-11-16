@IsTest
public with sharing class ExampleVariablesDataTypesOperatorsTest {
	@IsTest
	static void testAddition() {
		Integer result;

		// Test addition of two positive numbers
		result = ExampleVariablesDataTypesOperators.addition(10, 15);
		System.assertEquals(25, result, 'Incorrect addition result for two positive numbers');

		// Test addition with one negative and one positive number
		result = ExampleVariablesDataTypesOperators.addition(-7, 12);
		System.assertEquals(5, result, 'Incorrect result for addition with one negative and one positive number');

		// Test addition with zero
		result = ExampleVariablesDataTypesOperators.addition(0, 9);
		System.assertEquals(9, result, 'Incorrect result for addition with zero');

		// Test addition of two large numbers
		result = ExampleVariablesDataTypesOperators.addition(500000, 300000);
		System.assertEquals(800000, result, 'Incorrect result for addition of two large numbers');
	}

	@IsTest
	static void testSubtraction() {
		Integer result;

		// Test subtraction of two positive numbers
		result = ExampleVariablesDataTypesOperators.subtraction(5, 3);
		System.assertEquals(2, result, 'Incorrect result for 5 - 3');

		// Test subtraction with a negative number
		result = ExampleVariablesDataTypesOperators.subtraction(-4, 6);
		System.assertEquals(-10, result, 'Incorrect result for -4 - 6');

		// Test subtraction resulting in zero
		result = ExampleVariablesDataTypesOperators.subtraction(8, 8);
		System.assertEquals(0, result, 'Incorrect result for 8 - 8');

		// Test subtraction with null values
		result = ExampleVariablesDataTypesOperators.subtraction(null, 5);
		System.assertEquals(null, result, 'Incorrect result for null - 5');

		result = ExampleVariablesDataTypesOperators.subtraction(5, null);
		System.assertEquals(null, result, 'Incorrect result for 5 - null');
	}

	@IsTest
	static void testMultiplication() {
		// Test positive numbers
		System.assertEquals(
			6,
			ExampleVariablesDataTypesOperators.multiplication(2, 3),
			'Incorrect multiplication result for 2 * 3'
		);

		// Test negative numbers
		System.assertEquals(
			15,
			ExampleVariablesDataTypesOperators.multiplication(-3, -5),
			'Incorrect multiplication result for -3 * -5'
		);

		// Test zero
		System.assertEquals(
			0,
			ExampleVariablesDataTypesOperators.multiplication(0, 5),
			'Incorrect multiplication result for 0 * 5'
		);
	}

	@IsTest
	static void testDivision() {
		// Test normal division
		System.assertEquals(
			2,
			ExampleVariablesDataTypesOperators.division(6, 3),
			'Incorrect division result for 6 / 3'
		);

		// Test division by zero
		System.assertEquals(
			0,
			ExampleVariablesDataTypesOperators.division(5, 0),
			'Incorrect division result for 5 / 0'
		);

		// Test division with negative numbers
		System.assertEquals(
			-4,
			ExampleVariablesDataTypesOperators.division(-8, 2),
			'Incorrect division result for -8 / 2'
		);
	}

	@IsTest
	static void testIsOdd() {
		// Test with an even number
		System.assertEquals(
			false,
			ExampleVariablesDataTypesOperators.isOdd(2),
			'2 should be identified as even (not odd)'
		);

		// Test with an odd number
		System.assertEquals(true, ExampleVariablesDataTypesOperators.isOdd(3), '3 should be identified as odd');

		// Test with zero (even)
		System.assertEquals(false, ExampleVariablesDataTypesOperators.isOdd(0), '0 should be identified as even');

		// Test with a negative even number
		System.assertEquals(false, ExampleVariablesDataTypesOperators.isOdd(-4), '-4 should be identified as even');

		// Test with a negative odd number
		System.assertEquals(true, ExampleVariablesDataTypesOperators.isOdd(-5), '-5 should be identified as odd');
	}

	@IsTest
	static void testIsNegative() {
		// Test with a negative number
		System.assertEquals(
			true,
			ExampleVariablesDataTypesOperators.isNegative(-1),
			'-1 should be identified as negative'
		);

		// Test with zero (not negative)
		System.assertEquals(
			false,
			ExampleVariablesDataTypesOperators.isNegative(0),
			'0 should not be identified as negative'
		);

		// Test with a positive number (not negative)
		System.assertEquals(
			false,
			ExampleVariablesDataTypesOperators.isNegative(5),
			'5 should not be identified as negative'
		);

		// Test with a large negative number
		System.assertEquals(
			true,
			ExampleVariablesDataTypesOperators.isNegative(-100000),
			'-100000 should be identified as negative'
		);
	}

	@IsTest
	static void testConcatenateStrings() {
		// Test concatenation of two regular strings
		System.assertEquals(
			'HelloWorld',
			ExampleVariablesDataTypesOperators.concatenateStrings('Hello', 'World'),
			'Concatenation of "Hello" and "World" should result in "HelloWorld"'
		);

		// Test concatenation with an empty string
		System.assertEquals(
			'Hello',
			ExampleVariablesDataTypesOperators.concatenateStrings('Hello', ''),
			'"Hello" concatenated with an empty string should result in "Hello"'
		);
		System.assertEquals(
			'World',
			ExampleVariablesDataTypesOperators.concatenateStrings('', 'World'),
			'An empty string concatenated with "World" should result in "World"'
		);

		// Test concatenation with null values
		System.assertEquals(
			'Hello',
			ExampleVariablesDataTypesOperators.concatenateStrings('Hello', null),
			'"Hello" concatenated with null should result in "Hello"'
		);
		System.assertEquals(
			'World',
			ExampleVariablesDataTypesOperators.concatenateStrings(null, 'World'),
			'null concatenated with "World" should result in "World"'
		);

		// Test concatenation of two empty strings
		System.assertEquals(
			'',
			ExampleVariablesDataTypesOperators.concatenateStrings('', ''),
			'Concatenation of two empty strings should result in an empty string'
		);
	}

	@IsTest
	static void testIsDateTodayOrPast() {
		Date pastDate = Date.newInstance(2000, 1, 1);
		Date futureDate = Date.newInstance(2100, 1, 1);
		Date today = Date.today();

		// Test with a past date
		System.assertEquals(
			true,
			ExampleVariablesDataTypesOperators.isDateTodayOrPast(pastDate),
			'Past date should return true'
		);

		// Test with a future date
		System.assertEquals(
			false,
			ExampleVariablesDataTypesOperators.isDateTodayOrPast(futureDate),
			'Future date should return false'
		);

		// Test with today's date
		System.assertEquals(
			true,
			ExampleVariablesDataTypesOperators.isDateTodayOrPast(today),
			'Today should return true'
		);
	}

	@IsTest
	static void testConvertSecondsToMinutes() {
		// Test conversion with 0 seconds
		System.assertEquals(
			0,
			ExampleVariablesDataTypesOperators.convertSecondsToMinutes(0),
			'0 seconds should be 0 minutes'
		);

		// Test conversion with 60 seconds (1 minute)
		System.assertEquals(
			1,
			ExampleVariablesDataTypesOperators.convertSecondsToMinutes(60),
			'60 seconds should be 1 minute'
		);

		// Test conversion with 120 seconds (2 minutes)
		System.assertEquals(
			2,
			ExampleVariablesDataTypesOperators.convertSecondsToMinutes(120),
			'120 seconds should be 2 minutes'
		);

		// Test conversion with an arbitrary number of seconds
		System.assertEquals(
			10,
			ExampleVariablesDataTypesOperators.convertSecondsToMinutes(600),
			'600 seconds should be 10 minutes'
		);
	}

	@IsTest
	static void testAverageOfTwoNumbers() {
		// Test with two positive numbers
		System.assertEquals(
			2.0,
			ExampleVariablesDataTypesOperators.averageOfTwoNumbers(1, 3),
			'Average of 1 and 3 should be 2.0'
		);

		// Test with one positive and one negative number
		System.assertEquals(
			0.0,
			ExampleVariablesDataTypesOperators.averageOfTwoNumbers(-2, 2),
			'Average of -2 and 2 should be 0.0'
		);

		// Test with two negative numbers
		System.assertEquals(
			-3.0,
			ExampleVariablesDataTypesOperators.averageOfTwoNumbers(-4, -2),
			'Average of -4 and -2 should be -3.0'
		);

		// Test with zeros
		System.assertEquals(
			0.0,
			ExampleVariablesDataTypesOperators.averageOfTwoNumbers(0, 0),
			'Average of 0 and 0 should be 0.0'
		);
	}

	@IsTest
	static void testPerformIntegerCast() {
		// Test with a positive number
		System.assertEquals(
			2,
			ExampleVariablesDataTypesOperators.performIntegerCast(2.5),
			'2.5 should be rounded to 3'
		);

		// Test with a negative number
		System.assertEquals(
			-1,
			ExampleVariablesDataTypesOperators.performIntegerCast(-1.5),
			'-1.5 should be rounded to -2'
		);

		// Test with a number having no decimal part
		System.assertEquals(4, ExampleVariablesDataTypesOperators.performIntegerCast(4.0), '4.0 should remain 4');

		// Test with zero
		System.assertEquals(0, ExampleVariablesDataTypesOperators.performIntegerCast(0.0), '0.0 should remain 0');
	}

	@IsTest
	static void testCalculateMonthlyPaycheck() {
		// Test with standard hourly rate and hours
		System.assertEquals(
			1600.0,
			ExampleVariablesDataTypesOperators.calculateMonthlyPaycheck(10.0, (Double) 40.0),
			'Monthly paycheck for $10 hourly rate and 40 hours per week should be $1600'
		);

		// Test with different hourly rate and hours
		System.assertEquals(
			2400.0,
			ExampleVariablesDataTypesOperators.calculateMonthlyPaycheck(15.0, (Double) 40.0),
			'Monthly paycheck for $15 hourly rate and 40 hours per week should be $2400'
		);

		// Test with part-time hours
		System.assertEquals(
			800.0,
			ExampleVariablesDataTypesOperators.calculateMonthlyPaycheck(10.0, (Double) 20.0),
			'Monthly paycheck for $10 hourly rate and 20 hours per week should be $800'
		);

		// Test with zero hours (no work)
		System.assertEquals(
			0.0,
			ExampleVariablesDataTypesOperators.calculateMonthlyPaycheck(10.0, (Double) 0.0),
			'Monthly paycheck for $10 hourly rate and 0 hours per week should be $0'
		);
	}

	@IsTest
	static void testCalculateYearlyPaycheck() {
		// Test with standard hourly rate and hours
		System.assertEquals(
			20800.0,
			ExampleVariablesDataTypesOperators.calculateYearlyPaycheck(10.0, (Double) 40.0),
			'Yearly paycheck calculation for $10 hourly rate and 40 hours per week should be $20800'
		);

		// Test with different hourly rate and hours
		System.assertEquals(
			31200.0,
			ExampleVariablesDataTypesOperators.calculateYearlyPaycheck(15.0, (Double) 40.0),
			'Yearly paycheck calculation for $15 hourly rate and 40 hours per week should be $31200'
		);

		// Test with part-time hours
		System.assertEquals(
			10400.0,
			ExampleVariablesDataTypesOperators.calculateYearlyPaycheck(10.0, (Double) 20.0),
			'Yearly paycheck calculation for $10 hourly rate and 20 hours per week should be $10400'
		);

		// Test with zero hours (no work)
		System.assertEquals(
			0.0,
			ExampleVariablesDataTypesOperators.calculateYearlyPaycheck(10.0, (Double) 0.0),
			'Yearly paycheck calculation for $10 hourly rate and 0 hours per week should be $0'
		);
	}
}
