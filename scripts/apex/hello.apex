List<Opportunity> opps = List<Opportunity>();
opps.add(new Opportunity(Name='Test Opp 1', StageName='Prospecting', CloseDate=Date.today()));
opps.add(new Opportunity(Name='Test Opp 2', StageName='Prospecting', CloseDate=Date.today()));
insert opps;