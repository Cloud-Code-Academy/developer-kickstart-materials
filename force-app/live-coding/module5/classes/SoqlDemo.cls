public with sharing class SoqlDemo {
    /**
     * Retrieves a list of Account records limited by the provided parameter.
     * If the provided limit is null or non‑positive, a default of 5 records will be returned.
     *
     * @param limitSize The maximum number of Account records to retrieve.
     * @return A list of Account records.
     */
    public static List<Account> getAccounts(Integer limitSize) {
        Integer lim = (limitSize == null || limitSize <= 0) ? 5 : limitSize;
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT :lim];
        System.debug('Retrieved ' + accounts.size() + ' accounts');
        return accounts;
    }

    /**
     * Retrieves the contacts associated with a given Account.
     *
     * @param accountId The Id of the Account whose contacts should be retrieved.
     * @return A list of Contact records; an empty list if accountId is null.
     */
    public static List<Contact> getContactsForAccount(Id accountId) {
        if (accountId == null) {
            return new List<Contact>();
        }
        List<Contact> contacts = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE AccountId = :accountId];
        System.debug('Retrieved ' + contacts.size() + ' contacts for account ' + accountId);
        return contacts;
    }

    /**
     * Finds Account records where the Name field contains the supplied substring.
     *
     * @param name A full or partial name to search for.
     * @return A list of Account records with names matching the supplied value.
     */
    public static List<Account> findAccountsByName(String name) {
        if (String.isBlank(name)) {
            return new List<Account>();
        }
        String searchValue = '%' + name + '%';
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE :searchValue];
        System.debug('Found ' + accounts.size() + ' accounts matching ' + name);
        return accounts;
    }
}