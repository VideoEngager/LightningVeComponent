/**
 * @description Controller for serving Smartvideo LWC
 */
public with sharing class SmartvideoController {
    public static final String SETTINGS_ENV = 'environment';
    public static final String SETTINGS_EXT_ID = 'external_id';
    public static final String SETTINGS_API_KEY = 'api_key';
    public static final String ENV_GENERIC = 'generic';

    public class IncompleteSettingsException extends Exception {}

    /**
     * @description Retrieve Smartvideo App URL
     * @return String URL
     */
    @AuraEnabled(Cacheable=true)
    public static String getVideoAppUrl() {
        Map<String, String> settings = getSettings();
        if (!settings.containsKey(SETTINGS_ENV) || !settings.containsKey(SETTINGS_EXT_ID) || !settings.containsKey(SETTINGS_API_KEY)) {
            throw new IncompleteSettingsException('Incomplete settings');
        }

        Boolean isEnvGeneric = settings.get(SETTINGS_ENV).toLowerCase() == ENV_GENERIC;

        String apiKey = settings.get(SETTINGS_API_KEY);
        if (isEnvGeneric && (String.isBlank(apiKey) || apiKey.length() != 36)) {
            throw new IncompleteSettingsException('API key not set or invalid');
        }

        return 'https://videome.leadsecure.com/nextjs/single/smartvideo/?environment='
                + EncodingUtil.urlEncode(settings.get(SETTINGS_ENV), 'UTF-8')
                + (isEnvGeneric ? (
                    '&externalId='
                    + EncodingUtil.urlEncode(settings.get(SETTINGS_EXT_ID), 'UTF-8')
                    + '&pak='
                    + EncodingUtil.urlEncode(apiKey, 'UTF-8')
                    + '&email='
                    + EncodingUtil.urlEncode(getIdentifier(), 'UTF-8')
                ) : '') + '&isPopup=true';
    }

    /**
    * @description Generate unique identifier for every user in given Org
     * @return String URL
     */
    @TestVisible
    private static String getIdentifier() {
        String userEmail = UserInfo.getUserEmail();
        String orgId = UserInfo.getOrganizationId();

        return orgId + userEmail;
    }

    /**
     * @description Retrieve settings from custom metadata type Smartvideo_Setting
     * @return Map<String, String> - A map containing the settings with their respective values
     */
    @TestVisible
    private static Map<String, String> getSettings() {
        Map<String, String> result = new Map<String, String>();

        List<Smartvideo_Setting__mdt> settings = [
            SELECT DeveloperName, value__c
            FROM Smartvideo_Setting__mdt
            WITH SECURITY_ENFORCED
        ];

        if (Test.isRunningTest()) {
            settings.clear();
            settings.add(new Smartvideo_Setting__mdt(
                    Label = 'Environment',
                    DeveloperName = SETTINGS_ENV,
                    value__c = 'generic'
            ));
            settings.add(new Smartvideo_Setting__mdt(
                Label = 'External ID',
                DeveloperName = SETTINGS_EXT_ID,
                value__c = 'external-id-test-value'
            ));
            settings.add(new Smartvideo_Setting__mdt(
                Label = 'API Key',
                DeveloperName = SETTINGS_API_KEY,
                value__c = 'api-key-test-value-12345678901234567'
            ));
        }

        for(Smartvideo_Setting__mdt setting: settings) {
            result.put(setting.DeveloperName, setting.value__c);
        }

        return result;
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