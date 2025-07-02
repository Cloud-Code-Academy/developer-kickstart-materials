/**
 * IntegrationDemoHelper - Helper class for learning integrations
 * 
 * This class provides simple examples and instructions for beginners
 * to understand and practice Salesforce integrations.
 * 
 * HOW TO USE THIS CLASS:
 * 1. Open Developer Console
 * 2. Go to Debug > Open Execute Anonymous Window
 * 3. Copy and run the example code snippets below
 */
public class IntegrationDemoHelper {
    
    /**
     * Example 1: Testing REST Endpoints with Workbench
     * 
     * Steps to test your REST endpoint:
     * 1. Go to workbench.developerforce.com
     * 2. Login to your org
     * 3. Go to utilities > REST Explorer
     * 4. Use these URLs:
     *    - GET: /services/apexrest/simpleAPI/
     *    - POST: /services/apexrest/simpleAPI/
     *    - DELETE: /services/apexrest/simpleAPI/{contactId}
     * 
     * For POST, use this JSON body:
     * {
     *   "firstName": "Test",
     *   "lastName": "User",
     *   "email": "test@example.com"
     * }
     */
    public static void restEndpointInstructions() {
        System.debug('===== REST ENDPOINT TESTING INSTRUCTIONS =====');
        System.debug('1. Your REST endpoint URL: /services/apexrest/simpleAPI/');
        System.debug('2. Available methods: GET, POST, DELETE');
        System.debug('3. Test using Workbench REST Explorer');
        System.debug('4. Remember to include /services/apexrest/ before your URL mapping');
    }
    
    /**
     * Example 2: Making a Simple Callout
     * Run this in Execute Anonymous to test callouts
     * 
     * IMPORTANT: First add this to Remote Site Settings:
     * - Name: JokeAPI
     * - URL: https://official-joke-api.appspot.com
     */
    public static void testSimpleCallout() {
        System.debug('===== TESTING SIMPLE CALLOUT =====');
        
        // Check if we're in a test context
        if (Test.isRunningTest()) {
            System.debug('Cannot make real callouts in test context!');
            return;
        }
        
        try {
            // Make the callout
            SimpleExternalCallout.getRandomJoke();
            System.debug('Check the debug logs for the joke!');
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            System.debug('Did you add the Remote Site Setting?');
        }
    }
    
    /**
     * Example 3: Common Integration Patterns
     * This method shows common patterns you'll see in real projects
     */
    public static void commonPatterns() {
        System.debug('===== COMMON INTEGRATION PATTERNS =====');
        
        // Pattern 1: Sync on record creation (using trigger)
        System.debug('1. Trigger Pattern:');
        System.debug('   - Use @future(callout=true) from trigger');
        System.debug('   - Pass record IDs, not full records');
        System.debug('   - Query fresh data in the @future method');
        
        // Pattern 2: Batch sync
        System.debug('2. Batch Sync Pattern:');
        System.debug('   - Use Batch Apex with Database.AllowsCallouts');
        System.debug('   - Limit callouts per batch (max 100)');
        System.debug('   - Handle failures gracefully');
        
        // Pattern 3: Real-time integration
        System.debug('3. Real-time Pattern:');
        System.debug('   - Use Platform Events or Streaming API');
        System.debug('   - Consider using middleware (MuleSoft, etc.)');
        System.debug('   - Monitor API limits carefully');
    }
    
    /**
     * Example 4: Debugging Tips
     * Common issues and how to fix them
     */
    public static void debuggingTips() {
        System.debug('===== INTEGRATION DEBUGGING TIPS =====');
        
        System.debug('1. "Unauthorized endpoint" error:');
        System.debug('   - Add URL to Remote Site Settings');
        System.debug('   - Check if URL includes https://');
        
        System.debug('2. "Read timed out" error:');
        System.debug('   - Increase timeout: request.setTimeout(120000)');
        System.debug('   - Check if external API is slow');
        
        System.debug('3. "Callout not allowed" error:');
        System.debug('   - Add @future(callout=true) for triggers');
        System.debug('   - Cannot make callouts after DML');
        
        System.debug('4. Testing issues:');
        System.debug('   - Always use Test.setMock()');
        System.debug('   - Cannot make real callouts in tests');
    }
    
    /**
     * Example 5: Security Best Practices
     */
    public static void securityTips() {
        System.debug('===== SECURITY BEST PRACTICES =====');
        
        System.debug('1. API Keys:');
        System.debug('   - NEVER hardcode in Apex');
        System.debug('   - Use Named Credentials or Custom Settings');
        
        System.debug('2. Data Validation:');
        System.debug('   - Always validate incoming data');
        System.debug('   - Use try-catch for all DML');
        
        System.debug('3. Access Control:');
        System.debug('   - Check user permissions before callouts');
        System.debug('   - Limit REST endpoint access appropriately');
    }
    
    /**
     * Run all examples
     * Execute this in Anonymous Apex to see all tips
     */
    public static void runAllExamples() {
        restEndpointInstructions();
        System.debug('');
        
        commonPatterns();
        System.debug('');
        
        debuggingTips();
        System.debug('');
        
        securityTips();
        System.debug('');
        
        System.debug('===== NEXT STEPS =====');
        System.debug('1. Try the REST endpoint in Workbench');
        System.debug('2. Add Remote Site Setting and test callout');
        System.debug('3. Run the test class to see 100% coverage');
        System.debug('4. Experiment with different APIs');
    }
} 