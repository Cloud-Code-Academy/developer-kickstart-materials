public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT FirstName, LastName, Email, Account.Name FROM Contact LIMIT 100];
    }

    @AuraEnabled
    public static Contact saveContact(Contact contact) {
        upsert contact;
        return contact;
    }
}