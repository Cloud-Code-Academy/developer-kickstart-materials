String companyName = 'Cloud Code';
Lead warren = new Lead(FirstName = 'Warren', LastName = 'Walters', Status = 'Open', LeadSource = 'Web', Phone = '9541231021');
warren.Company = companyName + ' LLC';

System.debug('Before Insert Lead: ' + warren);
insert warren;
System.debug('After Insert Lead: ' + warren);
System.debug('Lead Id: ' + warren.Id);

warren.FirstName = 'Darren';
update warren;

System.debug('After Update Lead: ' + warren);