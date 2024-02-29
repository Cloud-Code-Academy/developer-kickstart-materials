public class TestDataFactory {
	public static List<Lead> createLeads(Integer count, String email) {
		List<Lead> leads = new List<Lead>();
		for (Integer i = 0; i < count; i++) {
			leads.add(new Lead(LastName = 'TestLead' + i, Company = 'TestCompany' + i, Email = email));
		}
		return leads;
	}

	public static Contact createContact(Id accountId, String email) {
		Contact contact = new Contact(LastName = 'TestContact', Email = email, AccountId = accountId);
		insert contact;
		return contact;
	}

	public static Account createAccount(String name) {
		Account account = new Account(Name = name);
		insert account;
		return account;
	}
}
