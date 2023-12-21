/*
 * Resources:
 * String class: https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_string.htm
 * Date class: https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_date.htm
 * Math class: https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_math.htm
 * Classes: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_understanding.htm
 */
public with sharing class ExampleClassesObjectsMethods {
	/**
	 * Performs various string operations and checks on a given string.
	 * Operations include finding the length, obtaining a substring, converting to lowercase,
	 * and checking if it starts with, ends with, or contains specific substrings.
	 * Example: stringOperationsAndChecks('Hello, Salesforce!') should return a list like ["17", "Hello", "hello, salesforce!", true, false, false].
	 * @param input The input string.
	 * @return A list containing the length of the string, a substring of the string, the string in lower case,
	 * and boolean values indicating whether the string starts with 'Hello', ends with 'Force', or contains 'Sales'.
	 */
	public static List<String> stringOperationsAndChecks(String input) {
		List<String> results = new List<String>();

		// Get the length of the string

		// Get a substring of the string

		// Convert the string to lowercase

		// Check if the string starts with 'Hello'

		// Check if the string ends with 'Force'

		// Check if the string contains 'Sales'

		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Takes a sentence, removes duplicate words, and counts the vowels in the resulting sentence.
	 * Example: uniqueSentenceAndVowelCount("Hello, Hello, Salesforce!") should return [, Salesforce!", 5].
	 * @param sentence The input sentence.
	 * @return A list containing the sentence with only unique words and the number of vowels in this sentence.
	 */
	public static List<Integer> uniqueSentenceAndVowelCount(String sentence) {
		// Split the sentence into words

		// Create a set to store unique words

		// Add each word to the set

		// Join the unique words back into a sentence

		// Count vowels in the unique sentence

		// Iterate through each word in the unique sentence

		// Iterate through each character in the word

		// Check if the character is a vowel

		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Generate a random number between 50 and 100
	 * Example: generateRandomNumber() should return a number like 75.
	 * @return A integer between 0 and 100.
	 */
	public static Integer generateRandomNumber() {
		// Use Math class to generate number between 0 and 100

		// Return the random integer
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * Given the name of a month, return its corresponding number.
	 * Example: getMonthNumber("January") should return 1
	 * @param monthName The name of the month.
	 * @return The number of the month for the given name.
	 */
	public static Integer getMonthNumber(String monthName) {
		// Define a map of months
		// January => 1, February => 2, March => 3, April => 4, May => 5, June => 6, July => 7, August => 8, September => 9, October => 10, November => 11, December => 12

		// Get the month number from the map using the month name

		// Return the month number
		return null; // Replace null with the variable you used to store the result
	}

	/**
	 * The Student class represents a student.
	 * Each Student object has a name, whether they are PD1 certified, and the amount of program completed.
	 * This class can be used in the context of a school, college, etc.
	 * where you need to manipulate and manage student information.
	 */
	public class Student {
		// Declare instance variables - name, PD1 certification status, and program completion amount

		// Constructor to initialize the name, and program completion amount

		// Method that returns the details of the student
		public String introduceYourself() {
			return null; // Replace null with the variable you used to store the result
		}

		// Getter method that returns the name of the student

		// Getter method that returns the PD1 certification status

		// Getter method that returns the program completion amount

		// Setter method that sets the name of the student

		// Setter method that sets the PD1 certification status

		// Setter method that sets the program completion amount
	}

	/**
	 * Compare two Student objects based on their PD1 certification and program progress.
	 * If one is PD1 certified and the other is not, return the certified student.
	 * If both are either certified or not certified, return the student who has progressed further in the program.
	 * If they have equal progress, return null.
	 *
	 * @param student1 The first Student object.
	 * @param student2 The second Student object.
	 * @return The Student object of the student who is further ahead or PD1 certified.
	 */
	public static Student getMoreAdvancedStudent(Student student1, Student student2) {
		// Check if one student is PD1 certified and the other is not

		// Compare program completion amounts

		return null; // Replace null with the variable you used to store the result
	}
}
