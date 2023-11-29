/**
 * This trigger simply logs some details of each new SmartvideoEvent__e record (SmartVideo event) to the Salesforce debug console whenever a new record is inserted.
 * If this example is used with managed package of SmartVideo do not forget to add namespace prefix to the object and custom fields.
 */
trigger SmartVideoEventsTrigger on SmartvideoEvent__e (after insert) {
    for(SmartvideoEvent__e event: Trigger.new) {
        System.debug(LoggingLevel.DEBUG, 'UUID: ' + event.EventUuid);
        System.debug(LoggingLevel.DEBUG, 'Created by: ' + event.CreatedById);
        System.debug(LoggingLevel.DEBUG, 'Created date: ' + event.CreatedDate);
        System.debug(LoggingLevel.DEBUG, 'Name: ' + event.Name__c);
        System.debug(LoggingLevel.DEBUG, 'Payload: ' + event.Payload__c);

        if (event.Payload__c != null) {
            // deserialize the payload to a map
            Map<String, Object> payload = (Map<String, Object>)JSON.deserializeUntyped(event.Payload__c);
            System.debug(LoggingLevel.DEBUG, payload.get('email'));
        }

    }
}