// Run this in the Developer Console (Execute Anonymous Window)

// Hello World in Apex
System.debug('Hello, World!');

// ---- Data Types ----

// Integer
Integer myInt = 42;
System.debug('Integer: ' + myInt);

// Decimal (for numbers with fractions)
Decimal myDecimal = 3.14159;
System.debug('Decimal: ' + myDecimal);

// Boolean
Boolean isLearning = true;
System.debug('Boolean: ' + isLearning);

// String
String myString = 'Apex is fun!';
System.debug('String: ' + myString);

// Date
Date today = Date.today();
System.debug('Date: ' + today);

// Datetime
Datetime now = Datetime.now();
System.debug('Datetime: ' + now);

// ---- Basic Math ----
Integer a = 10;
Integer b = 3;

Integer sum = a + b;
Integer difference = a - b;
Integer product = a * b;
Decimal quotient = Decimal.valueOf(a) / b;

System.debug('Math -> Sum: ' + sum + 
             ', Difference: ' + difference + 
             ', Product: ' + product + 
             ', Quotient: ' + quotient);

// ---- String Concatenation ----
String firstName = 'Alexander';
String lastName = 'Steele';
String fullName = firstName + ' ' + lastName;

System.debug('Full Name: ' + fullName);