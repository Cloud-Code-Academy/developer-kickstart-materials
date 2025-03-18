/**
 * QUEUEABLE APEX EXAMPLE
 * 
 * This example demonstrates:
 * - Implementing the Queueable interface
 * - Chaining jobs together
 * - Processing records in sequence
 * - Managing complex data processing
 */
public class OpportunityTeamAssigner implements Queueable {
    
    // Instance variables
    private List<Opportunity> opportunities;
    private Map<Id, List<Id>> userAssignments;
    private Integer batchSize;
    private Integer currentBatchPosition = 0;
    private Integer maxChainDepth;
    private Integer currentChainDepth = 1;
    
    /**
     * Constructor for initial job creation
     */
    public OpportunityTeamAssigner(List<Opportunity> opps, Map<Id, List<Id>> userAssignmentMap, 
                                   Integer processingBatchSize, Integer maxChain) {
        this.opportunities = opps;
        this.userAssignments = userAssignmentMap;
        this.batchSize = processingBatchSize;
        this.maxChainDepth = maxChain;
    }
    
    /**
     * Constructor for chained job creation
     */
    public OpportunityTeamAssigner(List<Opportunity> opps, Map<Id, List<Id>> userAssignmentMap, 
                                   Integer processingBatchSize, Integer maxChain, 
                                   Integer chainDepth, Integer batchPosition) {
        this(opps, userAssignmentMap, processingBatchSize, maxChain);
        this.currentChainDepth = chainDepth;
        this.currentBatchPosition = batchPosition;
    }
    
    /**
     * Execute method that processes a batch of opportunities
     */
    public void execute(QueueableContext context) {
        // Determine the records to process in this batch
        Integer endPosition = Math.min(currentBatchPosition + batchSize, opportunities.size());
        List<Opportunity> currentBatch = new List<Opportunity>();
        
        // Get the current batch of opportunities
        if (currentBatchPosition < opportunities.size()) {
            currentBatch = opportunities.subList(currentBatchPosition, endPosition);
        }
        
        if (!currentBatch.isEmpty()) {
            processOpportunityTeamMembers(currentBatch);
            
            // Check if there are more records to process
            if (endPosition < opportunities.size() && currentChainDepth < maxChainDepth) {
                // Chain next job if we haven't reached max chain depth
                OpportunityTeamAssigner nextJob = new OpportunityTeamAssigner(
                    opportunities, userAssignments, batchSize, maxChainDepth, 
                    currentChainDepth + 1, endPosition
                );
                
                System.enqueueJob(nextJob);
                System.debug('Chained next job processing opportunities from position: ' + endPosition);
            } else if (endPosition < opportunities.size()) {
                // We've hit max chain depth but have more records
                System.debug('Reached maximum chain depth of ' + maxChainDepth + 
                            '. Remaining records will not be processed automatically.');
            }
        }
    }
    
    /**
     * Helper method to process team members for opportunities
     */
    private void processOpportunityTeamMembers(List<Opportunity> oppsToProcess) {
        List<OpportunityTeamMember> teamMembersToInsert = new List<OpportunityTeamMember>();
        
        for (Opportunity opp : oppsToProcess) {
            // Check if we have user assignments for this opportunity
            if (userAssignments.containsKey(opp.Id)) {
                List<Id> userIds = userAssignments.get(opp.Id);
                
                for (Id userId : userIds) {
                    OpportunityTeamMember member = new OpportunityTeamMember(
                        OpportunityId = opp.Id,
                        UserId = userId,
                        TeamMemberRole = 'Sales Representative'
                    );
                    teamMembersToInsert.add(member);
                }
            }
        }
        
        // Insert team members with error handling
        if (!teamMembersToInsert.isEmpty()) {
            try {
                insert teamMembersToInsert;
                System.debug('Inserted ' + teamMembersToInsert.size() + ' opportunity team members');
            } catch (Exception e) {
                System.debug('Error inserting opportunity team members: ' + e.getMessage());
                // In a production environment, implement proper error logging
            }
        }
    }
    
    /**
     * Static method to start processing opportunities
     */
    public static void processOpportunities(List<Id> opportunityIds, Map<Id, List<Id>> userAssignments) {
        if (opportunityIds == null || opportunityIds.isEmpty()) {
            return;
        }
        
        // Query opportunities
        List<Opportunity> opportunities = [
            SELECT Id, Name, OwnerId, StageName, CloseDate 
            FROM Opportunity 
            WHERE Id IN :opportunityIds
        ];
        
        if (!opportunities.isEmpty()) {
            // Start the queueable chain
            OpportunityTeamAssigner job = new OpportunityTeamAssigner(
                opportunities, userAssignments, 20, 5 // Process 20 records at a time, max 5 chains
            );
            System.enqueueJob(job);
        }
    }
    
    /**
     * Example usage from Anonymous Apex:
     * 
     * // Create a map of opportunity IDs to user IDs to assign
     * Map<Id, List<Id>> assignments = new Map<Id, List<Id>>();
     * assignments.put('0061x00000XYZ123', new List<Id>{'0051x00000ABC456', '0051x00000DEF789'});
     * 
     * // Start the queueable process
     * OpportunityTeamAssigner.processOpportunities(new List<Id>(assignments.keySet()), assignments);
     */
}