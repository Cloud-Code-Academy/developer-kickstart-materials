
// ============================================================================
// Lesson 1 Anonymous Apex (Super Basic + Class Call)
// ============================================================================

// 1) Hello World direct
System.debug('Hello, Apex!');

// 2) Primitives / Core Types
String course = 'Apex 101';
Integer week = 1;
Boolean isActive = true;
Date today = Date.today();

System.debug('course=' + course + ', week=' + week);
System.debug('today=' + today + ', isActive? ' + isActive);

// 3) Collections
List<String> topics = new List<String>{ 'Variables', 'Types', 'Collections' };
topics.add('Debug Logs');
System.debug('topics=' + topics);

Set<String> tags = new Set<String>{ 'apex', 'intro', 'apex' };
System.debug('tags=' + tags);

Map<String, Integer> order = new Map<String, Integer>();
for (Integer i = 0; i < topics.size(); i++) {
    order.put(topics[i], i + 1);
}
System.debug('Order of "Collections" → ' + order.get('Collections'));

// 4) Call static method from HelloWorldClass
System.debug(HelloWorld.sayHello('Student'));
System.debug(HelloWorld.sayHello(null));