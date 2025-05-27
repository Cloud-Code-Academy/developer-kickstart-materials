/**
 * @description Demonstrates using the Database class methods for DML operations
 * @author Cloud Code Academy
 */
public with sharing class DMLDatabaseClassDemo {
    
    /**
     * @description Demonstrates using Database.insert() for partial success
     * @return List of successful record IDs
     */
    public static List<Id> databaseInsertWithPartialSuccess() {
        // Create a list with some valid and some invalid records
        List<Account> mixedAccounts = new List<Account>{
            new Account(Name = 'Valid Account 1'),
            new Account(Name = 'Valid Account 2'),
            new Account() // Missing required Name field — will fail
        };
        
        System.debug('Attempting to insert ' + mixedAccounts.size() + ' accounts, but one is invalid');
        
        // Second parameter "false" allows partial success
        Database.SaveResult[] results = Database.insert(mixedAccounts, false);
        
        // Process the results
        List<Id> successIds = new List<Id>();
        
        for (Integer i = 0; i < results.size(); i++) {
            Database.SaveResult sr = results[i];
            if (sr.isSuccess()) {
                // Success
                successIds.add(sr.getId());
                System.debug('Successfully inserted account ' + i + ' with ID: ' + sr.getId());
            } else {
                // Handle the errors
                for (Database.Error err : sr.getErrors()) {
                    System.debug('Error on record ' + i + ': ' + err.getStatusCode() + ' - ' + err.getMessage());
                    System.debug('Fields that affected this error: ' + err.getFields());
                }
            }
        }
        
        System.debug('Successfully inserted ' + successIds.size() + ' out of ' + mixedAccounts.size() + ' records');
        return successIds;
    }
    
    /**
     * @description Demonstrates the standard insert vs Database.insert() approach
     */
    public static void compareInsertApproaches() {
        // Create a list with one invalid record
        List<Account> accountsWithOneInvalid = new List<Account>{
            new Account(Name = 'Valid Account'),
            new Account() // Missing required Name field
        };
        
        // Try standard DML - will throw exception
        try {
            System.debug('Attempting standard insert - will fail completely if any record is invalid');
            insert accountsWithOneInvalid;
            System.debug('This line won\'t execute if there are any invalid records');
        } catch (DmlException e) {
            System.debug('Standard insert failed: ' + e.getMessage());
        }
        
        // Try Database class with allOrNone = true - also throws exception
        try {
            System.debug('Attempting Database.insert with allOrNone=true - will behave like standard insert');
            Database.insert(accountsWithOneInvalid, true);
            System.debug('This line won\'t execute if there are any invalid records');
        } catch (DmlException e) {
            System.debug('Database.insert with allOrNone=true failed: ' + e.getMessage());
        }
        
        // Try Database class with allOrNone = false - allows partial success
        System.debug('Attempting Database.insert with allOrNone=false - will allow partial success');
        Database.SaveResult[] results = Database.insert(accountsWithOneInvalid, false);
        
        // Process results
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                System.debug('Record ' + i + ' was successfully inserted');
            } else {
                System.debug('Record ' + i + ' failed, but other valid records were still inserted');
            }
        }
    }
    
    /**
     * @description Demonstrates using Database.update() with partial success
     * @param accountIds List of Account IDs to update
     * @return List of successful update IDs
     */
    public static List<Id> databaseUpdateWithPartialSuccess(List<Id> accountIds) {
        // Create list with some valid updates and some invalid
        List<Account> mixedUpdates = new List<Account>();
        
        // Valid updates
        for (Id accId : accountIds) {
            mixedUpdates.add(new Account(
                Id = accId,
                Description = 'Valid update'
            ));
        }
        
        // Add an invalid update (ID doesn't exist)
        mixedUpdates.add(new Account(
            Id = '001000000000000', // Fake ID that doesn't exist
            Description = 'Invalid update - ID doesn\'t exist'
        ));
        
        // Perform update with partial success allowed
        Database.SaveResult[] results = Database.update(mixedUpdates, false);
        
        // Process results
        List<Id> successIds = new List<Id>();
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                successIds.add(sr.getId());
                System.debug('Successfully updated account: ' + sr.getId());
            } else {
                for (Database.Error err : sr.getErrors()) {
                    System.debug('Error updating record: ' + err.getStatusCode() + ' - ' + err.getMessage());
                }
            }
        }
        
        System.debug('Successfully updated ' + successIds.size() + ' out of ' + mixedUpdates.size() + ' records');
        return successIds;
    }
    
    /**
     * @description Demonstrates using Database.delete() with partial success
     * @param accountIds List of Account IDs to delete
     * @return List of successfully deleted IDs
     */
    public static List<Id> databaseDeleteWithPartialSuccess(List<Id> accountIds) {
        // Create list of IDs to delete
        List<Id> idsToDelete = new List<Id>(accountIds);
        
        // Add an invalid ID
        idsToDelete.add('001000000000000'); // Fake ID that doesn't exist
        
        // Perform delete with partial success allowed
        Database.DeleteResult[] results = Database.delete(idsToDelete, false);
        
        // Process results
        List<Id> successIds = new List<Id>();
        for (Integer i = 0; i < results.size(); i++) {
            Database.DeleteResult dr = results[i];
            if (dr.isSuccess()) {
                successIds.add(idsToDelete[i]);
                System.debug('Successfully deleted account: ' + idsToDelete[i]);
            } else {
                for (Database.Error err : dr.getErrors()) {
                    System.debug('Error deleting record ' + idsToDelete[i] + ': ' + err.getStatusCode() + ' - ' + err.getMessage());
                }
            }
        }
        
        System.debug('Successfully deleted ' + successIds.size() + ' out of ' + idsToDelete.size() + ' records');
        return successIds;
    }
} 