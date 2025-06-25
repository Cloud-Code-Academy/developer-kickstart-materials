# Lesson 8: Apex Transactions - Study Materials

## Overview

This folder contains comprehensive code examples for understanding **Apex Transactions** as part of your PD1 study session. The examples are designed to be very basic with extensive comments to help you understand the core concepts.

## Key Concepts Covered

### 1. What is an Apex Transaction?

An Apex transaction represents a set of operations that are executed as a single unit. All operations within a transaction either succeed together or fail together (rollback).

### 2. Transaction Boundaries

-   **Start**: When Apex code begins executing (trigger, anonymous Apex, etc.)
-   **End**: When the code completes successfully (commit) or fails (rollback)
-   **Scope**: All operations within the transaction share the same context

### 3. Static Variables in Transactions

Static variables persist for the entire lifetime of a transaction and are shared across all method calls within that transaction.

### 4. Governor Limits Monitoring

The `Limits` class allows you to monitor current governor limit usage at any point during a transaction.

### 5. Asynchronous Apex and Separate Transactions

Asynchronous Apex (like Queueable) creates separate transactions with fresh governor limits.

## Demo Classes

### 1. TransactionBasicsDemo.cls

**Purpose**: Demonstrates fundamental transaction concepts

**Key Methods**:

-   `basicTransactionExample()` - Shows multiple operations in one transaction
-   `transactionRollbackExample()` - Demonstrates rollback when exceptions occur
-   `multipleMethodsInTransaction()` - Shows Method A → Method B → Method C in same transaction
-   `queryWithinTransaction()` - Shows visibility of uncommitted changes

**How to Run**:

```apex
// Execute in Anonymous Apex
TransactionBasicsDemo.basicTransactionExample();
TransactionBasicsDemo.transactionRollbackExample();
TransactionBasicsDemo.multipleMethodsInTransaction();
TransactionBasicsDemo.queryWithinTransaction();
```

### 2. StaticVariablesInTransactionDemo.cls

**Purpose**: Demonstrates how static variables behave within transactions

**Key Methods**:

-   `demonstrateStaticVariablePersistence()` - Shows static variables persisting across method calls
-   `preventDuplicateProcessingExample()` - Practical use case for preventing duplicate processing
-   `triggerRecursionPreventionExample()` - Shows preventing recursive trigger execution
-   `transactionCountersExample()` - Demonstrates transaction-wide counters

**How to Run**:

```apex
// Execute in Anonymous Apex
StaticVariablesInTransactionDemo.demonstrateStaticVariablePersistence();
StaticVariablesInTransactionDemo.preventDuplicateProcessingExample();
StaticVariablesInTransactionDemo.triggerRecursionPreventionExample();
StaticVariablesInTransactionDemo.transactionCountersExample();
```

### 3. GovernorLimitsDemo.cls

**Purpose**: Demonstrates monitoring and managing governor limits

**Key Methods**:

-   `basicLimitMonitoring()` - Shows how to check various limits during execution
-   `limitBasedDecisionMaking()` - Demonstrates making decisions based on current limits
-   `cpuTimeManagement()` - Shows breaking up CPU-intensive work
-   `heapSizeMonitoring()` - Demonstrates memory usage monitoring
-   `bulkOperationLimitChecking()` - Shows calculating safe batch sizes

**How to Run**:

```apex
// Execute in Anonymous Apex
GovernorLimitsDemo.basicLimitMonitoring();
GovernorLimitsDemo.limitBasedDecisionMaking();
GovernorLimitsDemo.cpuTimeManagement();
GovernorLimitsDemo.heapSizeMonitoring();
GovernorLimitsDemo.bulkOperationLimitChecking();

// Get current limits summary
System.debug(GovernorLimitsDemo.getLimitsSummary());
```

### 4. AsyncApexTransactionDemo.cls

**Purpose**: Demonstrates asynchronous Apex and separate transactions

**Key Methods**:

-   `demonstrateAsyncTransactionBoundary()` - Shows sync vs async transaction boundaries
-   `governorLimitAsyncExample()` - Shows using async when approaching limits
-   `demonstrateJobChaining()` - Shows chaining jobs across multiple transactions

**How to Run**:

```apex
// Execute in Anonymous Apex
AsyncApexTransactionDemo.demonstrateAsyncTransactionBoundary();
AsyncApexTransactionDemo.governorLimitAsyncExample();
AsyncApexTransactionDemo.demonstrateJobChaining();
```

### 5. SimpleAsyncWorker.cls

**Purpose**: Working example of a Queueable class for async processing

**Key Features**:

-   Runs in separate transaction with fresh limits
-   Can perform different types of work based on parameters
-   Demonstrates accessing data from synchronous transaction

**How to Use**:

```apex
// Create an account first
Account testAccount = new Account(Name = 'Test Account for Async');
insert testAccount;

// Enqueue different types of work
SimpleAsyncWorker contactWorker = new SimpleAsyncWorker(testAccount.Id, 'CREATE_CONTACTS');
System.enqueueJob(contactWorker);

SimpleAsyncWorker oppWorker = new SimpleAsyncWorker(testAccount.Id, 'CREATE_OPPORTUNITIES');
System.enqueueJob(oppWorker);

SimpleAsyncWorker updateWorker = new SimpleAsyncWorker(testAccount.Id, 'UPDATE_ACCOUNT');
System.enqueueJob(updateWorker);
```

## Study Tips

### 1. Transaction Boundaries

-   Remember: One transaction = one commit or rollback
-   Multiple method calls = still one transaction
-   Async Apex = separate transaction

### 2. Static Variables

-   Persist for entire transaction lifetime
-   Reset when new transaction begins
-   Useful for preventing recursion and duplicate processing

### 3. Governor Limits

-   Always check limits before performing bulk operations
-   Use `Limits` class to monitor usage
-   Consider async processing when approaching limits

### 4. Order of Execution

-   Triggers, workflows, and processes all run within the same transaction
-   Understand when the transaction commits vs. when it rolls back

## Common Exam Questions

1. **Q**: How many transactions occur when a trigger updates a record that fires another trigger?
   **A**: One transaction (unless async Apex is involved)

2. **Q**: When do static variables reset?
   **A**: When a new transaction begins

3. **Q**: What happens to uncommitted changes when an exception occurs?
   **A**: All changes in the transaction are rolled back

4. **Q**: How do you get fresh governor limits?
   **A**: Use asynchronous Apex (Queueable, Batch, Future)

## Practice Exercises

1. **Basic Transaction**: Create a method that inserts an Account, Contact, and Opportunity. Make one operation fail and observe the rollback.

2. **Static Variables**: Create a trigger handler that uses static variables to prevent recursive execution.

3. **Limit Monitoring**: Write code that processes records in batches and monitors SOQL query limits.

4. **Async Processing**: Create a scenario where you approach governor limits and use Queueable to handle remaining work.

## Debug Logs

When running these examples, pay attention to:

-   Transaction start/end markers in debug logs
-   Static variable values across method calls
-   Governor limit usage throughout execution
-   Separate log entries for async jobs

## Additional Notes

-   All examples include extensive comments explaining each concept
-   Code is designed to be educational rather than production-ready
-   Focus on understanding the concepts rather than memorizing syntax
-   Practice with different scenarios to reinforce learning

## Next Steps

After studying these examples:

1. Practice writing your own transaction-aware code
2. Understand how triggers fit into the transaction model
3. Learn about bulk processing patterns
4. Study asynchronous processing patterns for handling large data volumes
