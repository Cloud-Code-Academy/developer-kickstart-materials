// ============================================================================
// Lesson 4 — Anonymous Apex Driver for DmlDemo (no local methods)
// Developer Console → Debug → Open Execute Anonymous Window → check “Open Log”
// ============================================================================

// 1) INSERT (single)
System.debug('================== INSERT single — START ==================');
try {
    DmlDemo.insertSingleAccount();
    System.debug('✅ INSERT single completed');
} catch (Exception e) {
    System.debug('❌ INSERT single failed: ' + e.getMessage());
}
System.debug('================== INSERT single — END ====================\n');

// 2) INSERT (bulk)
System.debug('================== INSERT bulk — START ====================');
try {
    DmlDemo.insertBulkContacts();
    System.debug('✅ INSERT bulk completed');
} catch (Exception e) {
    System.debug('❌ INSERT bulk failed: ' + e.getMessage());
}
System.debug('================== INSERT bulk — END ======================\n');

// 3) UPDATE (bulkified)
System.debug('================== UPDATE bulkified — START ===============');
try {
    DmlDemo.bulkUpdateAccounts();
    System.debug('✅ UPDATE bulkified completed');
} catch (Exception e) {
    System.debug('❌ UPDATE bulkified failed: ' + e.getMessage());
}
System.debug('================== UPDATE bulkified — END =================\n');

// 4) PARTIAL SUCCESS (Database.insert allOrNone=false)
System.debug('================== Partial Success insert — START =========');
try {
    DmlDemo.insertWithPartialSuccess();
    System.debug('✅ Partial Success insert completed');
} catch (Exception e) {
    System.debug('❌ Partial Success insert failed: ' + e.getMessage());
}
System.debug('================== Partial Success insert — END ===========\n');

// 5) UPSERT
System.debug('================== UPSERT by Id — START ===================');
try {
    DmlDemo.upsertAccount();
    System.debug('✅ UPSERT by Id completed');
} catch (Exception e) {
    System.debug('❌ UPSERT by Id failed: ' + e.getMessage());
}
System.debug('================== UPSERT by Id — END =====================\n');

// 6) ERROR HANDLING demo
System.debug('================== DML Error Handling — START =============');
try {
    DmlDemo.demoErrorHandling();
    System.debug('✅ DML Error Handling completed');
} catch (Exception e) {
    System.debug('❌ DML Error Handling failed: ' + e.getMessage());
}
System.debug('================== DML Error Handling — END ===============\n');

// Optional: quick governor limits peek (end-of-run snapshot)
System.debug('--- Limits Snapshot (end) ---');
System.debug('DML statements: ' + Limits.getDmlStatements());
System.debug('SOQL queries:   ' + Limits.getQueries());
System.debug('CPU time (ms):  ' + Limits.getCpuTime());
