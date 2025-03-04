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
            // deserialize the payload to a SmartVideoEvent object
            SmartVideoEvent payload = SmartVideoEvent.parse(event.Payload__c);
            System.debug(LoggingLevel.DEBUG, 'Payload: ' + payload);
            

            if (payload != null && payload.tabInfo != null && event.Name__c == 'FINISHED') {
                // create a new Task record for the call
                try {
                    Task callTask = new Task();
                    String objectName = payload.tabInfo.pageReference.attributes.objectApiName;
                    
                    if (objectName == 'Contact' || objectName == 'Lead') {
                        callTask.WhoId = payload.tabInfo.recordId;
                    } else {
                        callTask.WhatId = payload.tabInfo.recordId;
                    }

                    callTask.Subject = 'SmartVideo Call';
                    callTask.Description = 'SmartVideo Call with duration ' + payload.smartVideo.attributes.totalTalkTime + ' seconds';
                    callTask.Type = 'Call';
                    callTask.Status = 'Completed';
                    callTask.TaskSubtype = 'Call';
                    callTask.CallType = 'Outbound';

                    insert callTask;
                } catch (Exception e) {
                    System.debug(LoggingLevel.ERROR, 'Error creating Task: ' + e.getMessage());
                }
            }
        }

    }
}