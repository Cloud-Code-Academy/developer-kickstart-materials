@isTest
public class BasicAccountTriggerTest {
    /**
     * Verifies that the BasicAccountTrigger sets a default name on insert when no name is provided.
     */
    @isTest
    static void testDefaultNameSet() {
        // Create an account without setting the Name field
        Account acc = new Account();

        Test.startTest();
        insert acc;
        Test.stopTest();

        // Query the inserted record to verify that a default name was applied
        Account result = [SELECT Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Default Account Name', result.Name,
            'Account name should be defaulted when null or blank');
    }
}