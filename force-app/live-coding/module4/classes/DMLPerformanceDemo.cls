/**
 * @description Demonstrates DML performance optimization techniques
 * @author Cloud Code Academy
 */
public with sharing class DMLPerformanceDemo {
    
    /**
     * @description Demonstrates batching related records in a single DML statement
     * @param numAccounts Number of Account records to create
     * @param contactsPerAccount Number of Contact records to create per Account
     * @return Total execution time in milliseconds
     */
    public static Long batchRelatedRecordsDml(Integer numAccounts, Integer contactsPerAccount) {
        Long startTime = System.currentTimeMillis();
        
        // First, create all accounts in a single DML
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numAccounts; i++) {
            accounts.add(new Account(
                Name = 'Batch Account ' + i,
                Industry = 'Technology'
            ));
        }
        
        insert accounts;
        System.debug('Inserted ' + accounts.size() + ' accounts in 1 DML statement');
        
        // Now create contacts for each account in a single DML
        List<Contact> allContacts = new List<Contact>();
        
        for (Account acc : accounts) {
            for (Integer i = 0; i < contactsPerAccount; i++) {
                allContacts.add(new Contact(
                    FirstName = 'Contact',
                    LastName = 'Batch ' + i,
                    AccountId = acc.Id,
                    Email = 'contact' + i + '@' + acc.Id + '.example.com'
                ));
            }
        }
        
        insert allContacts;
        System.debug('Inserted ' + allContacts.size() + ' contacts in 1 DML statement');
        
        Long endTime = System.currentTimeMillis();
        Long executionTime = endTime - startTime;
        
        System.debug('Total execution time: ' + executionTime + ' ms');
        return executionTime;
    }
    
    /**
     * @description Demonstrates inefficient DML pattern for comparison
     * @param numAccounts Number of Account records to create
     * @param contactsPerAccount Number of Contact records to create per Account
     * @return Total execution time in milliseconds
     */
    public static Long inefficientDmlPattern(Integer numAccounts, Integer contactsPerAccount) {
        Long startTime = System.currentTimeMillis();
        
        // Create accounts one at a time (inefficient)
        List<Id> accountIds = new List<Id>();
        for (Integer i = 0; i < numAccounts; i++) {
            Account acc = new Account(
                Name = 'Inefficient Account ' + i,
                Industry = 'Technology'
            );
            
            // BAD PRACTICE: One DML per account
            insert acc;
            accountIds.add(acc.Id);
        }
        
        System.debug('Inserted ' + accountIds.size() + ' accounts with ' + accountIds.size() + ' DML statements');
        
        // Create contacts one at a time (inefficient)
        Integer contactCount = 0;
        for (Id accId : accountIds) {
            for (Integer i = 0; i < contactsPerAccount; i++) {
                Contact con = new Contact(
                    FirstName = 'Contact',
                    LastName = 'Inefficient ' + i,
                    AccountId = accId,
                    Email = 'contact' + i + '@' + accId + '.example.com'
                );
                
                // BAD PRACTICE: One DML per contact
                insert con;
                contactCount++;
            }
        }
        
        System.debug('Inserted ' + contactCount + ' contacts with ' + contactCount + ' DML statements');
        
        Long endTime = System.currentTimeMillis();
        Long executionTime = endTime - startTime;
        
        System.debug('Total execution time: ' + executionTime + ' ms');
        System.debug('WARNING: This method demonstrates what NOT to do!');
        return executionTime;
    }
    
    /**
     * @description Demonstrates using maps to organize records before DML
     * @param accountNames List of Account names to create
     * @return Map of AccountId to List of created Contacts
     */
    public static Map<Id, List<Contact>> organizeRecordsWithMaps(List<String> accountNames) {
        // Create a map to store Account names to Account records
        Map<String, Account> nameToAccountMap = new Map<String, Account>();
        
        // Create Account records
        List<Account> accounts = new List<Account>();
        for (String name : accountNames) {
            Account acc = new Account(Name = name);
            accounts.add(acc);
            nameToAccountMap.put(name, acc);
        }
        
        // Insert accounts in bulk
        insert accounts;
        System.debug('Inserted ' + accounts.size() + ' accounts');
        
        // Create a map to store Account IDs to Contacts
        Map<Id, List<Contact>> accountToContactsMap = new Map<Id, List<Contact>>();
        
        // Create contacts for each account
        List<Contact> allContacts = new List<Contact>();
        
        for (Account acc : accounts) {
            List<Contact> accountContacts = new List<Contact>();
            
            // Create 2 contacts for each account
            for (Integer i = 0; i < 2; i++) {
                Contact con = new Contact(
                    FirstName = 'Contact',
                    LastName = acc.Name + ' ' + i,
                    AccountId = acc.Id
                );
                allContacts.add(con);
                accountContacts.add(con);
            }
            
            accountToContactsMap.put(acc.Id, accountContacts);
        }
        
        // Insert all contacts in bulk
        insert allContacts;
        System.debug('Inserted ' + allContacts.size() + ' contacts');
        
        return accountToContactsMap;
    }
    
    /**
     * @description Demonstrates separating operations by object type for better organization
     * @param numRecords Number of each type of record to create
     */
    public static void separateOperationsByObjectType(Integer numRecords) {
        System.debug('Creating ' + numRecords + ' records of each type (Account, Contact, Opportunity)');
        
        // Create accounts
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numRecords; i++) {
            accounts.add(new Account(Name = 'Account ' + i));
        }
        insert accounts;
        System.debug('Inserted ' + accounts.size() + ' accounts');
        
        // Create contacts (not related to accounts for this demo)
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < numRecords; i++) {
            contacts.add(new Contact(
                FirstName = 'First',
                LastName = 'Contact ' + i
            ));
        }
        insert contacts;
        System.debug('Inserted ' + contacts.size() + ' contacts');
        
        // Create opportunities (not related to accounts for this demo)
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < numRecords; i++) {
            opportunities.add(new Opportunity(
                Name = 'Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }
        insert opportunities;
        System.debug('Inserted ' + opportunities.size() + ' opportunities');
        
        // Now update all records (separate operations by object type)
        for (Account acc : accounts) {
            acc.Description = 'Updated description';
        }
        update accounts;
        System.debug('Updated ' + accounts.size() + ' accounts');
        
        for (Contact con : contacts) {
            con.Title = 'Updated Title';
        }
        update contacts;
        System.debug('Updated ' + contacts.size() + ' contacts');
        
        for (Opportunity opp : opportunities) {
            opp.Description = 'Updated description';
        }
        update opportunities;
        System.debug('Updated ' + opportunities.size() + ' opportunities');
    }
    
    /**
     * @description Compares performance of different DML approaches
     * @param numRecords Number of records to use in comparison
     * @return Map containing execution times for different approaches
     */
    public static Map<String, Long> compareDmlPerformance(Integer numRecords) {
        Map<String, Long> performanceResults = new Map<String, Long>();
        
        // Approach 1: Efficient bulk DML
        Long startTime1 = System.currentTimeMillis();
        
        List<Account> accounts1 = new List<Account>();
        for (Integer i = 0; i < numRecords; i++) {
            accounts1.add(new Account(Name = 'Efficient ' + i));
        }
        insert accounts1;
        
        Long endTime1 = System.currentTimeMillis();
        Long executionTime1 = endTime1 - startTime1;
        performanceResults.put('efficientBulkDml', executionTime1);
        
        // Approach 2: Inefficient multiple DML (but not too many to hit limits)
        Long startTime2 = System.currentTimeMillis();
        
        Integer maxDml = Math.min(numRecords, 100); // Limit to avoid governor limits
        for (Integer i = 0; i < maxDml; i++) {
            Account acc = new Account(Name = 'Inefficient ' + i);
            insert acc;
        }
        
        Long endTime2 = System.currentTimeMillis();
        Long executionTime2 = endTime2 - startTime2;
        performanceResults.put('inefficientMultipleDml', executionTime2);
        
        // Calculate performance difference
        Double percentageDifference = ((Double)executionTime2 / executionTime1 - 1) * 100;
        System.debug('Efficient approach took ' + executionTime1 + ' ms');
        System.debug('Inefficient approach took ' + executionTime2 + ' ms');
        System.debug('The inefficient approach took ' + percentageDifference.setScale(2) + '% longer');
        
        return performanceResults;
    }
}
