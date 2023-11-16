@IsTest
public with sharing class ExampleVariablesDataTypesOperatorsTest {
    @IsTest
    static void testAddition() {
        Integer result;
    
        // Test addition of two positive numbers
        result = VariablesDataTypesOperators.addition(10, 15);
        System.assertEquals(25, result, 'Incorrect addition result for two positive numbers');
    
        // Test addition with one negative and one positive number
        result = VariablesDataTypesOperators.addition(-7, 12);
        System.assertEquals(5, result, 'Incorrect result for addition with one negative and one positive number');
    
        // Test addition with zero
        result = VariablesDataTypesOperators.addition(0, 9);
        System.assertEquals(9, result, 'Incorrect result for addition with zero');
    
        // Test addition of two large numbers
        result = VariablesDataTypesOperators.addition(500000, 300000);
        System.assertEquals(800000, result, 'Incorrect result for addition of two large numbers');
    }
}