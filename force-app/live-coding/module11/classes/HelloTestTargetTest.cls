@isTest
private class HelloTestTargetTest {
    /**
     * Tests that the greeting returned by HelloTestTarget.getGreeting() is formatted correctly.
     */
    @isTest
    static void testGreeting() {
        String result = HelloTestTarget.getGreeting('Salesforce');
        System.assertEquals('Hello, Salesforce!', result,
            'Greeting did not match expected output.');
    }

    /**
     * Tests that the greeting method handles different names correctly.
     */
    @isTest
    static void testGreetingWithDifferentName() {
        String result = HelloTestTarget.getGreeting('Trailblazer');
        System.assertEquals('Hello, Trailblazer!', result,
            'Greeting did not match expected output for Trailblazer.');
    }
}