trigger ExampleAccountTrigger on Account(before insert, after insert, after update) {
	if (Trigger.isBefore && Trigger.isInsert) {
		for (Account acc : Trigger.new) {
			if (acc.Type == null) {
				acc.Type = 'Prospect';
			}
		}
	}

	if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
		// Find Accounts that already have related Cases
		Set<Id> accountsWithCases = new Set<Id>();
		for (Case c : [SELECT AccountId FROM Case WHERE AccountId IN :Trigger.newMap.keyset()]) {
			accountsWithCases.add(c.AccountId);
		}

		// Prepare Cases for Accounts without existing Cases
		List<Case> casesToInsert = new List<Case>();
		for (Account acc : Trigger.new) {
			if (!accountsWithCases.contains(acc.Id)) {
				casesToInsert.add(
					new Case(AccountId = acc.Id, Subject = 'Default Case', Status = 'New', Priority = 'Medium')
				);
			}
		}

		// Insert new Cases
		if (!casesToInsert.isEmpty()) {
			insert casesToInsert;
		}
	}

}
