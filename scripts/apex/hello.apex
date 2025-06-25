Contact c = new Contact();
c.FirstName = 'John';
c.LastName = 'Doe';
c.Email = 'john.doe@example.com';
// insert c;

List<Contact> contacts = new List<Contact>{c};
// List<Contact> contacts = new List<Contact>();
// contacts.add(c);
ContactTriggerHandler.handleBeforeInsert(contacts);