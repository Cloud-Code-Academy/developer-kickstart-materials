/**
 * @description Demonstrates bulk DML operations and best practices
 * @author Cloud Code Academy
 */
public with sharing class DMLBulkOperationsDemo {
    
    /**
     * @description Demonstrates inserting multiple records with a single DML statement
     * @param numRecords Number of records to create
     * @return List of inserted Account IDs
     */
    public static List<Id> insertBulkRecords(Integer numRecords) {
        // Create a list to hold the new Account records
        List<Account> accountsToInsert = new List<Account>();
        
        // Add records to the list
        for (Integer i = 0; i < numRecords; i++) {
            Account acc = new Account(
                Name = 'Bulk Account ' + i,
                Industry = 'Technology',
                Description = 'Created in bulk operation'
            );
            accountsToInsert.add(acc);
        }
        
        // Insert all records with a single DML statement
        insert accountsToInsert;
        
        // Collect and return the IDs
        List<Id> accountIds = new List<Id>();
        for (Account acc : accountsToInsert) {
            accountIds.add(acc.Id);
        }
        
        System.debug('Inserted ' + accountIds.size() + ' records with 1 DML statement');
        return accountIds;
    }
    
    /**
     * @description Demonstrates updating multiple records with a single DML statement
     * @param accountIds List of Account IDs to update
     */
    public static void updateBulkRecords(List<Id> accountIds) {
        // Option 1: Query first, then update
        List<Account> accountsToUpdate = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        
        for (Account acc : accountsToUpdate) {
            acc.Description = 'Updated in bulk';
        }
        
        // Update all records with a single DML statement
        update accountsToUpdate;
        System.debug('Updated ' + accountsToUpdate.size() + ' records with 1 DML statement');
        
        // Option 2: Create instances with IDs and update directly
        List<Account> directUpdateAccounts = new List<Account>();
        
        for (Id accId : accountIds) {
            Account acc = new Account(
                Id = accId,
                BillingCity = 'San Francisco',
                BillingState = 'CA'
            );
            directUpdateAccounts.add(acc);
        }
        
        // Update all records with a single DML statement
        update directUpdateAccounts;
        System.debug('Directly updated ' + directUpdateAccounts.size() + ' records with 1 DML statement');
    }
    
    /**
     * @description Demonstrates the anti-pattern of DML inside a loop
     * @param accountIds List of Account IDs
     */
    public static void dmlInLoopAntiPattern(List<Id> accountIds) {
        System.debug('WARNING: This method demonstrates what NOT to do!');
        
        // BAD PRACTICE - Will hit governor limits with large data sets
        Integer dmlCounter = 0;
        for (Id accId : accountIds) {
            Account acc = new Account(
                Id = accId,
                ShippingCity = 'New York',
                ShippingState = 'NY'
            );
            
            // DON'T put DML inside loops!
            update acc;
            dmlCounter++;
        }
        
        System.debug('Used ' + dmlCounter + ' DML statements - THIS IS BAD!');
        System.debug('This would fail with governor limits if accountIds had more than 150 records');
    }
    
    /**
     * @description Demonstrates the correct pattern for updating many records
     * @param accountIds List of Account IDs
     */
    public static void bulkUpdateCorrectPattern(List<Id> accountIds) {
        // GOOD PRACTICE - Collect all updates, then perform single DML
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Id accId : accountIds) {
            Account acc = new Account(
                Id = accId,
                ShippingCity = 'Chicago',
                ShippingState = 'IL'
            );
            accountsToUpdate.add(acc);
        }
        
        // Single DML statement outside the loop
        update accountsToUpdate;
        
        System.debug('Used 1 DML statement for all records - THIS IS GOOD!');
    }
    
    /**
     * @description Demonstrates deleting multiple records with a single DML statement
     * @param accountIds List of Account IDs to delete
     */
    public static void deleteBulkRecords(List<Id> accountIds) {
        List<Account> accountsToDelete = new List<Account>();
        
        for (Id accId : accountIds) {
            accountsToDelete.add(new Account(Id = accId));
        }
        
        // Delete all records with a single DML statement
        delete accountsToDelete;
        
        System.debug('Deleted ' + accountsToDelete.size() + ' records with 1 DML statement');
    }
}