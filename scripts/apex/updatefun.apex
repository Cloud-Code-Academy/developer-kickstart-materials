String recordId = '0014T00000FDZskQAH';
Account myAccount = new Account();
myAccount.Id = recordId;
System.debug('Before update' + myAccount);
myAccount.Name = 'Cloud Code';
myAccount.Type = 'LMS';
myAccount.Industry = 'Coding';

update myAccount;
System.debug('After update' + myAccount);
