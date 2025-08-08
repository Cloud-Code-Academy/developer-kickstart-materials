public with sharing class DmlDemo {
    // INSERT single record
    public static void insertSingleAccount() {
        Account acc = new Account(Name = 'Acme Corporation');
        insert acc;
        System.debug('Inserted: ' + acc);
    }

    // Bulk INSERT
    public static void insertBulkContacts() {
        List<Contact> contacts = new List<Contact>{
            new Contact(FirstName='Jane', LastName='Doe'),
            new Contact(FirstName='John', LastName='Smith')
        };
        insert contacts;
        System.debug('Inserted ' + contacts.size() + ' contacts');
    }

    // UPDATE in bulk (bulkified)
    public static void bulkUpdateAccounts() {
        List<Account> accList = [SELECT Id, Name FROM Account LIMIT 5];
        for (Account a : accList) {
            a.Name += ' - Updated';
        }
        update accList;
        System.debug('Updated ' + accList.size() + ' accounts');
    }

    // Partial Success
    public static void insertWithPartialSuccess() {
        List<Account> accounts = new List<Account>{
            new Account(Name='Valid Account'),
            new Account() // Missing required Name
        };
        Database.SaveResult[] results = Database.insert(accounts, false);
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Inserted Id: ' + sr.getId());
            } else {
                System.debug('Error: ' + sr.getErrors()[0].getMessage());
            }
        }
    }

    // UPSERT demo
    public static void upsertAccount() {
        Account acc = new Account(Name = 'Upsert Demo Co');
        insert acc;
        acc.Name = 'Upsert Demo Co - Updated';
        upsert acc; // Matches by Id
    }

    // Error Handling
    public static void demoErrorHandling() {
        try {
            insert new Account(); // Missing Name
        } catch (DmlException e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
}
