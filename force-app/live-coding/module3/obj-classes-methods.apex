// Anonymous Apex: Lesson 3 Coding Topics — Objects, Classes, and Methods
// Run in Developer Console → Debug → Open Execute Anonymous Window, or VS Code: SFDX: Execute Anonymous Apex
//
// NOTE: Most orgs allow declaring classes in Anonymous Apex for quick demos.
// If your org disallows it, first create these classes in your org (same code below),
// then run only the "USAGE / DEMO" section at the bottom.

// ============================================================
// CLASSES
// ============================================================

// --- Example 1: A simple class with fields, constructor, and instance methods
public class Car {
    // Encapsulated fields (with getters/setters)
    private String make;
    private String model;
    private Integer year;
    private Integer odometer = 0;

    // Constructor
    public Car(String make, String model, Integer year) {
        this.make  = make;
        this.model = model;
        this.year  = year;
    }

    // Instance method: mutate state
    public void drive(Integer miles) {
        if (miles == null || miles <= 0) return;
        odometer += miles;
    }

    // Instance method: compute and return a value
    public String getDescription() {
        return year + ' ' + make + ' ' + model + ' (mi: ' + odometer + ')';
    }

    // Getters/Setters (encapsulation)
    public String getMake()  { return make;  }
    public String getModel() { return model; }
    public Integer getYear() { return year;  }

    public void setYear(Integer y) {
        if (y != null && y > 1900) year = y;
    }

    // Static utility method (class-level method, no instance required)
    public static Car newerOf(Car a, Car b) {
        if (a == null) return b;
        if (b == null) return a;
        return (a.year == null || b.year == null) ? a : (a.year >= b.year ? a : b);
    }
}

// --- Example 2: Method overloading and static helpers
public class MathUtil {
    public static Integer add(Integer a, Integer b) {
        return (a == null ? 0 : a) + (b == null ? 0 : b);
    }
    public static Decimal add(Decimal a, Decimal b) {
        return (a == null ? 0 : a) + (b == null ? 0 : b);
    }
    public static Decimal average(List<Decimal> values) {
        if (values == null || values.isEmpty()) return 0;
        Decimal total = 0;
        for (Decimal v : values) total += (v == null ? 0 : v);
        return total / values.size();
    }
}

// --- Example 3: Instance vs. static, parameters, return values
public class Greeter {
    private String defaultGreeting;

    // Constructors (overloaded)
    public Greeter() {
        this.defaultGreeting = 'Hello';
    }
    public Greeter(String greeting) {
        this.defaultGreeting = String.isBlank(greeting) ? 'Hello' : greeting;
    }

    // Instance method
    public String greet(String name) {
        return defaultGreeting + ', ' + (String.isBlank(name) ? 'there' : name) + '!';
    }

    // Overloaded instance method
    public List<String> greet(String name, Integer times) {
        List<String> outs = new List<String>();
        Integer n = (times == null || times <= 0) ? 1 : times;
        for (Integer i = 0; i < n; i++) outs.add(greet(name));
        return outs;
    }

    // Static factory
    public static Greeter friendly() {
        return new Greeter('Hey');
    }
}

// --- Example 4: A small domain class showing methods that transform data
public class Person {
    public String name;
    public Integer age;

    public Person(String n, Integer a) {
        name = n;
        age = a == null ? 0 : a;
    }

    public void birthday() {
        age++;
    }

    public String describe() {
        return name + ' (age ' + age + ')';
    }

    public static Person of(String n, Integer a) {
        return new Person(n, a);
    }
}

// ============================================================
// USAGE / DEMO
// ============================================================

// 1) Create objects and call instance methods
Car c1 = new Car('Tesla', 'Model 3', 2024);
Car c2 = new Car('Toyota', 'Corolla', 2018);

c1.drive(42);
c2.drive(10);
System.debug('Car 1: ' + c1.getDescription());
System.debug('Car 2: ' + c2.getDescription());

// 2) Call a static method on a class
Car newer = Car.newerOf(c1, c2);
System.debug('Newer car: ' + (newer == null ? 'None' : newer.getDescription()));

// 3) Use overloaded methods & static utilities
System.debug('MathUtil.add(Integer): ' + MathUtil.add(5, 7));              // 12
System.debug('MathUtil.add(Decimal): ' + MathUtil.add(5.25, 2.75));        // 8.00
System.debug('MathUtil.average: ' + MathUtil.average(new List<Decimal>{10, 20, 30})); // 20

// 4) Create objects via constructors and call methods
Greeter g1 = new Greeter();             // uses default "Hello"
Greeter g2 = new Greeter('Welcome');    // custom greeting
Greeter g3 = Greeter.friendly();        // static factory ("Hey")

System.debug(g1.greet('Admin'));
System.debug(g2.greet('Developer'));
System.debug(g3.greet('Team'));
System.debug('Greeter x3: ' + g1.greet('All', 3));

// 5) Another object example with simple behavior
Person p = Person.of('Apex Student', 20);
System.debug('Before birthday: ' + p.describe());
p.birthday();
System.debug('After birthday: ' + p.describe());

// 6) Show parameter passing (by value for primitives)
// (In Apex, primitives are passed by value; object references are passed by reference)
Integer base = 10;
Integer inc  = 5;
Integer result = MathUtil.add(base, inc); // base remains 10
System.debug('base: ' + base + ', inc: ' + inc + ', result: ' + result);

// 7) Quick tie-in to Salesforce objects (no DML): construct, set fields, call methods
// (SObjects are also objects; here we just demonstrate instantiation and field usage)
Account tmp = new Account();
tmp.Name = 'Demo Account';
System.debug('SObject instance → Account Name: ' + tmp.Name);

// End of demo
