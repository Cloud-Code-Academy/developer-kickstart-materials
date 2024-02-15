/*
 * Implementing the Schedulable Interface
 * Execute the ExampleBatch class using the Schedulable interface.
 */
global with sharing class ExampleSchedule implements Schedulable {
	global void execute(SchedulableContext sc) {
		// Create an instance of the 'ExampleBatch' class.
		// The 'ExampleBatch' class is a separate class that processes records in batches,
		// which is useful for processing large numbers of records without hitting governor limits.
		ExampleBatch batch = new ExampleBatch();

		// Use the 'Database.executeBatch' method to start the batch job.
		// This tells Salesforce to start processing the records using the logic defined in the 'ExampleBatch' class.
		Database.executeBatch(batch);
	}
}
