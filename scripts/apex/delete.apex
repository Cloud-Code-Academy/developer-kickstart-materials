List<id> ids = new List<Id>();
ids.add('0034T00000IjH0JQAV');
ids.add('0034T00000IjH0EQAV');

List<Contact> contactsToDelete = new List<Contact>();
//Not bulkified code
for (Id existingIds : ids){
    Contact tempContact = new Contact(Id = existingIds); //DML inside for loop bad practice | DML 150 governor limit
    contactsToDelete.add(tempContact);
}

//bulkified code
delete contactsToDelete;