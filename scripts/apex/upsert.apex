Account acc = new Account(Name = 'Test Account 1');
insert acc; //account id is set

Contact cont = new Contact(FirstName = 'Warren', LastName = 'Walters', AccountId = acc.Id);
insert cont; //id is set
cont.Title = 'Coder Person';

Contact cass = new Contact(FirstName = 'Casanova', LastName = 'Walters', AccountId = acc.Id);
cass.Title = 'Food Eater';

List<Contact> contactToUpdate = new List<Contact>{cont, cass};
system.debug(contactToUpdate);

upsert contactToUpdate;
system.debug(contactToUpdate);