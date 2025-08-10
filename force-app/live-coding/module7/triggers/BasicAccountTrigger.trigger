/**
 * BasicAccountTrigger - Lesson 7: Trigger Basics
 *
 * This trigger demonstrates a simple before insert trigger that sets a default name
 * when the Name field is blank or null. It avoids custom fields or external dependencies
 * so that students can run it safely in a fresh Developer Edition org.
 *
 * @author Cloud Code Academy
 * @since 2025
 */
trigger BasicAccountTrigger on Account (before insert) {
    for (Account acc : Trigger.new) {
        if (String.isBlank(acc.Name)) {
            acc.Name = 'Default Account Name';
        }
    }
}