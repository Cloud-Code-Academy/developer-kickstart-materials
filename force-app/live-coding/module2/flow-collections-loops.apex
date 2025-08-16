// Anonymous Apex: Illustrations of Flow Control, Loops (for/while/do-while), and Collections (List/Set/Map)
// Run in Developer Console → Debug → Open Execute Anonymous Window, or VS Code: SFDX: Execute Anonymous Apex

// ------------------------------------------------------------
// 1) FLOW CONTROL (if / else if / else)
// ------------------------------------------------------------
Integer score = 85;
if (score >= 90) {
    System.debug('Flow Control → Grade: A');
} else if (score >= 80) {
    System.debug('Flow Control → Grade: B');
} else if (score >= 70) {
    System.debug('Flow Control → Grade: C');
} else {
    System.debug('Flow Control → Grade: D/F');
}

// Nested condition example (e.g., feature flag + threshold)
Boolean featureEnabled = true;
Integer threshold = 10;
Integer value = 12;

if (featureEnabled) {
    if (value >= threshold) {
        System.debug('Flow Control (nested) → Feature ON and value meets threshold.');
    } else {
        System.debug('Flow Control (nested) → Feature ON but value below threshold.');
    }
} else {
    System.debug('Flow Control (nested) → Feature OFF.');
}

// Ternary operator for quick conditional assignment
String status = (Math.mod(value, 2) == 0) ? 'even' : 'odd';
System.debug('Flow Control (ternary) → Value is ' + status);

// ------------------------------------------------------------
// 2) LOOPS
//    - for (index-based)
//    - enhanced for-each
//    - while
//    - do-while
// ------------------------------------------------------------

// Prepare a collection for loop demos
List<String> fruits = new List<String>{ 'Apple', 'Banana', 'Cherry', 'Date' };

// 2a) for loop (index-based) over a List
for (Integer i = 0; i < fruits.size(); i++) {
    System.debug('Loop (for index) → fruits[' + i + ']: ' + fruits[i]);
}

// 2b) enhanced for-each loop over a List
for (String f : fruits) {
    System.debug('Loop (for-each) → ' + f);
}

// 2c) while loop (execute while condition remains true)
Integer counter = 0;
while (counter < 3) {
    System.debug('Loop (while) → counter: ' + counter);
    counter++;
}

// 2d) do-while loop (executes at least once)
Integer attempts = 0;
do {
    System.debug('Loop (do-while) → attempt #' + (attempts + 1));
    attempts++;
} while (attempts < 2);

// ------------------------------------------------------------
// 3) COLLECTIONS
//    - List: ordered, allows duplicates
//    - Set: unordered, unique elements
//    - Map: key → value lookups
// ------------------------------------------------------------

// 3a) LIST operations
List<Integer> nums = new List<Integer>();
nums.add(10);
nums.add(20);
nums.add(20); // duplicate allowed
nums.add(30);

System.debug('List → size: ' + nums.size());        // 4
System.debug('List → first element: ' + nums[0]);    // 10
System.debug('List → contains(20)? ' + nums.contains(20)); // true

// Remove by index
nums.remove(1); // removes the first 20
System.debug('List → after remove index 1: ' + nums);

// Iterate List (for-each)
Integer sum = 0;
for (Integer n : nums) {
    sum += n;
}
System.debug('List → sum: ' + sum);

// 3b) SET operations (unique values)
Set<String> tags = new Set<String>();
Boolean addedFoo1 = tags.add('foo');
Boolean addedFoo2 = tags.add('foo'); // duplicate ignored, returns false
tags.add('bar');

System.debug('Set → values: ' + tags);
System.debug('Set → added foo first? ' + addedFoo1 + ', added foo again? ' + addedFoo2);
System.debug('Set → contains("bar")? ' + tags.contains('bar'));

// Convert List → Set to deduplicate
Set<Integer> uniqueNums = new Set<Integer>(nums);
System.debug('Set (from List) → unique nums: ' + uniqueNums);

// 3c) MAP operations (key-value)
Map<String, Integer> inventory = new Map<String, Integer>();
inventory.put('Apples', 15);
inventory.put('Bananas', 8);
inventory.put('Cherries', 25);

// Overwrite a key
inventory.put('Bananas', 10); // update stock
System.debug('Map → Bananas stock: ' + inventory.get('Bananas'));
System.debug('Map → containsKey("Apples")? ' + inventory.containsKey('Apples'));

// Iterate keys
for (String itemName : inventory.keySet()) {
    System.debug('Map (keys) → ' + itemName + ' = ' + inventory.get(itemName));
}

// Iterate entries via keySet and values
System.debug('Map → keys: ' + inventory.keySet());
System.debug('Map → values: ' + inventory.values());

// Build a Map from a List (e.g., index → fruit)
Map<Integer, String> indexToFruit = new Map<Integer, String>();
for (Integer i = 0; i < fruits.size(); i++) {
    indexToFruit.put(i, fruits[i]);
}
System.debug('Map (from List) → ' + indexToFruit);

// Example: reverse lookup (value → index) using a Map
Map<String, Integer> fruitToIndex = new Map<String, Integer>();
for (Integer i = 0; i < fruits.size(); i++) {
    fruitToIndex.put(fruits[i], i);
}
System.debug('Map (reverse) → ' + fruitToIndex);
System.debug('Map (reverse) → index of "Cherry": ' + fruitToIndex.get('Cherry'));

// ------------------------------------------------------------
// Notes / Best Practices (contextual):
// - Avoid infinite loops (ensure loop conditions change).
// - Prefer Sets for uniqueness checks and fast membership tests.
// - Use Maps for O(1) average lookups by key.
// - When combining with SOQL/DML in real code, avoid SOQL/DML inside loops.
// ------------------------------------------------------------