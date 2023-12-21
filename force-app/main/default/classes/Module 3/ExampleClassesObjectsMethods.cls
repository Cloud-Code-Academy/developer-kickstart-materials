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

		// String operations
		results.add(String.valueOf(input.length()));
		results.add(input.substring(0, 5));
		results.add(input.toLowerCase());

		// String checks
		results.add(String.valueOf(input.startsWith('Hello')));
		results.add(String.valueOf(input.endsWith('Force')));
		results.add(String.valueOf(input.contains('Sales')));

		return results;
	}

	/**
	 * Takes a sentence, removes duplicate words, and counts the vowels in the resulting sentence.
	 * Example: uniqueSentenceAndVowelCount("Hello, Hello, Salesforce!") should return [, Salesforce!", 5].
	 * @param sentence The input sentence.
	 * @return A list containing the sentence with only unique words and the number of vowels in this sentence.
	 */
	public static List<Integer> uniqueSentenceAndVowelCount(String sentence) {
		// Split the sentence into words
		List<String> words = sentence.split(' ');

		// Create a set to store unique words
		Set<String> uniqueWords = new Set<String>();

		// Add each word to the set
		for (String word : words) {
			uniqueWords.add(word);
		}

		// Join the unique words back into a sentence
		String uniqueSentence = String.join(new List<String>(uniqueWords), ' ');

		List<Integer> results = new List<Integer>();
		// Count vowels in the unique sentence
		Integer resultIndex = 0;
		for (String word : uniqueWords) {
			Integer vowelCount = 0;
			for (Integer i = 0; i < word.length(); i++) {
				String character = word.toLowerCase().split('')[i];
				if (character == 'a' || character == 'e' || character == 'i' || character == 'o' || character == 'u') {
					vowelCount++;
				}
			}
			results.add(vowelCount);
			resultIndex++;
		}
		// Return the results
		return results;
	}

	/**
	 * Generate a random number between 50 and 100
	 * Example: generateRandomNumber() should return a number like 75.
	 * @return A integer between 0 and 100.
	 */
	public static Integer generateRandomNumber() {
		// Use Math class to generate number between 0 and 100
		Integer randomInteger = (Integer) (Math.random() * 100);

		// Return the random integer
		return randomInteger;
	}

	/**
	 * Given the name of a month, return its corresponding number.
	 * Example: getMonthNumber("January") should return 1
	 * @param monthName The name of the month.
	 * @return The number of the month for the given name.
	 */
	public static Integer getMonthNumber(String monthName) {
		// Define a map of months
		Map<String, Integer> months = new Map<String, Integer>{
			'January' => 1,
			'February' => 2,
			'March' => 3,
			'April' => 4,
			'May' => 5,
			'June' => 6,
			'July' => 7,
			'August' => 8,
			'September' => 9,
			'October' => 10,
			'November' => 11,
			'December' => 12
		};

		// Get the month number from the map using the month name
		Integer monthNumber = months.get(monthName);

		// Return the month number
		return monthNumber;
	}

	/**
	 * The Student class represents a student.
	 * Each Student object has a name, whether they are PD1 certified, and the amount of program completed.
	 * This class can be used in the context of a school, college, etc.
	 * where you need to manipulate and manage student information.
	 */
	public class Student {
		// Declare instance variables - name, PD1 certification status, and program completion amount
		private String name;
		private Boolean pd1Certified;
		private Integer programCompleteAmount;

		// Constructor to initialize the name, PD1 certification status, and program completion amount
		public Student(String name, Integer programCompleteAmount) {
			this.name = name;
			this.pd1Certified = false;
			this.programCompleteAmount = programCompleteAmount;
		}

		// Method that returns the details of the student
		public String introduceYourself() {
			return 'Hello, my name is ' +
				this.name +
				', PD1 Certified: ' +
				this.pd1Certified +
				', Program Completion: ' +
				this.programCompleteAmount +
				'%.';
		}

		// Getter method that returns the name of the student
		public String getName() {
			return this.name;
		}

		// Getter method that returns the PD1 certification status
		public Boolean isPd1Certified() {
			return this.pd1Certified;
		}

		// Getter method that returns the program completion amount
		public Integer getProgramCompleteAmount() {
			return this.programCompleteAmount;
		}

		// Setter method that sets the name of the student
		public void setName(String name) {
			this.name = name;
		}

		// Setter method that sets the PD1 certification status
		public void setPd1Certified(Boolean pd1Certified) {
			this.pd1Certified = pd1Certified;
		}

		// Setter method that sets the program completion amount
		public void setProgramCompleteAmount(Integer programCompleteAmount) {
			this.programCompleteAmount = programCompleteAmount;
		}
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
		// Check PD1 certification
		if (student1.isPd1Certified() && !student2.isPd1Certified()) {
			return student1;
		} else if (!student1.isPd1Certified() && student2.isPd1Certified()) {
			return student2;
		} else {
			// Compare program completion amounts
			if (student1.getProgramCompleteAmount() > student2.getProgramCompleteAmount()) {
				return student1;
			} else if (student1.getProgramCompleteAmount() < student2.getProgramCompleteAmount()) {
				return student2;
			} else {
				return null;
			}
		}
	}
}
