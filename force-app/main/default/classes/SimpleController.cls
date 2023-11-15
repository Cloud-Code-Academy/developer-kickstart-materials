public class SimpleController {
    public String name {get; set;} // Property bound to the inputText in the Visualforce page
    public String greeting {get; set;} // Property to store the greeting message

    // Method to handle the 'Submit' button action
    public void submit() {
        greeting = 'Hello, ' + name + '!'; // Constructs a greeting message using the input name
    }
}
