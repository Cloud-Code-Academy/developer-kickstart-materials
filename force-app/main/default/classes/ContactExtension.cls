public class ContactExtension {
    private final Contact contactRecord;

    // Constructor for the extension, accepting the standard controller as argument
    public ContactExtension(ApexPages.StandardController stdController) {
        this.contactRecord = (Contact)stdController.getRecord();
    }

    // Method to perform some update on the contact record
    public void updateContactDetails() {
        // Example operation: Update a field of the contact record
        contactRecord.Description = 'Updated by the controller extension on ' + DateTime.now();
        
        // Perform the update operation
        update contactRecord;
    }
}
