ExampleFuture.updateAllNextStep();

ExampleBatch batch = new ExampleBatch();
Database.executeBatch(batch, 10);

ExampleQueueable.enqueueJob();
