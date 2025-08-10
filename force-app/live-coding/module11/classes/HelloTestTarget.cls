public with sharing class HelloTestTarget {
    /**
     * Returns a greeting message for the supplied name.
     *
     * @param name The name to greet.
     * @return A greeting string in the form "Hello, <name>!".
     */
    public static String getGreeting(String name) {
        return 'Hello, ' + name + '!';
    }
}