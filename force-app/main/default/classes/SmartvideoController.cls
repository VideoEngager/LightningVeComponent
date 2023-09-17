/**
 * @description Controller for serving Smartvideo LWC
 */
public with sharing class SmartvideoController {
    public static final String SETTINGS_ENV = 'environment';

    /**
     * @description Retrieve Smartvideo App URL
     * @return String URL
     */
    @AuraEnabled(Cacheable=true)
    public static String getVideoAppUrl() {
        String environmentParamValue = getEnvironment(SETTINGS_ENV);
        return 'https://videome.leadsecure.com/nextjs/single/smartvideo/?environment='
                + EncodingUtil.urlEncode(environmentParamValue, 'UTF-8');
    }

    /**
     * @description Retrieve stored in CMDT environment name
     *
     * @param settingName String - developer name of the record name in CMDT
     *
     * @return String - Empty if setting was not found else setting value
     */
    @TestVisible
    private static String getEnvironment(String settingName) {
        if (String.isBlank(settingName)) {
            return '';
        }

        List<Smartvideo_Setting__mdt> settings = [
                SELECT value__c
                FROM Smartvideo_Setting__mdt
                WHERE DeveloperName = :settingName
                WITH SECURITY_ENFORCED
                LIMIT 1
        ];

        if (Test.isRunningTest()) {
            settings.clear();
            if (settingName == SETTINGS_ENV) {
                settings.add(new Smartvideo_Setting__mdt(
                        Label = 'Environment',
                        DeveloperName = 'environment',
                        value__c = 'test value'
                ));
            }
        }

        if (settings.size() != 0) {
            return settings[0].value__c;
        }

        return '';
    }

    /**
     * @description pushEvent pushes platform event with specified name and payload.
     *               It is used from Smartvideo LWC to push every App event to Salesforce.
      *              Refer to the docs for list of available events.
     *
     * @param name String name of the platform event
     * @param payload String payload for the platform event in JSON
     *
     * @return Boolean - True if platform event has been send successfully or False on error.
     */
    @AuraEnabled
    public static Boolean pushEvent(String name, String payload) {
        if (String.isBlank(name) || String.isBlank(payload)) {
            return false;
        }

        SmartvideoEvent__e event = new SmartvideoEvent__e(
                Name__c = name,
                Payload__c = payload
        );

        Database.SaveResult result = EventBus.publish(event);

        if (!result.isSuccess()) {
            //logging database errors
            logError('Smartvideo push event error:', result.getErrors());
            return false;
        }

        return true;
    }

    /**
     * @description Logging database errors into system debug log
     *
     * @param name String of what we are about to log
     * @param errors List of Database.Error
     */
    @TestVisible
    @SuppressWarnings('PMD.AvoidDebugStatements')
    private static void logError(String name, List<Database.Error> errors) {
        System.debug(LoggingLevel.DEBUG, name);

        if (errors != null) {
            for (Database.Error error : errors) {
                System.debug(LoggingLevel.DEBUG, error.getStatusCode() + ' - ' + error.getMessage());
            }
        }

        System.debug(LoggingLevel.DEBUG, '-----------------------------');
    }
}