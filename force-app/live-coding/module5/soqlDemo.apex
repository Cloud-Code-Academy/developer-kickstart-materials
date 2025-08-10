/*
 * soqlDemo.apex - Lesson 5: SOQL & Basic Data Retrieval in Apex
 *
 * This anonymous Apex script demonstrates simple SOQL queries and iterating over results.
 */

// Retrieve and debug a few accounts using the demo class
List<Account> accounts = SoqlDemo.getAccounts(3);
for (Account acc : accounts) {
    System.debug('Account Name: ' + acc.Name);
}

// If at least one account exists, retrieve its contacts
if (!accounts.isEmpty()) {
    List<Contact> relatedContacts = SoqlDemo.getContactsForAccount(accounts[0].Id);
    for (Contact c : relatedContacts) {
        System.debug('Contact: ' + c.FirstName + ' ' + c.LastName);
    }
}

// Demonstrate a LIKE query
List<Account> namedAcmes = SoqlDemo.findAccountsByName('Acme');
System.debug('Number of matching accounts: ' + namedAcmes.size());