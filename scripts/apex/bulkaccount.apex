List<Account> accountsToInsert = new List<Account>();
for (Integer i = 10; i < 15; i++){
    accountsToInsert.add(new Account(Name = 'Account Name ' + i, Website = 'test@test.com'));
}

accountsToInsert[0].Name = null;

// insert accountsToInsert; 
Database.insert(accountsToInsert,false);
System.debug(accountsToInsert);