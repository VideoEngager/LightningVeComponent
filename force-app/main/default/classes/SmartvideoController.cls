/**
 * @description Controller for serving Smartvideo LWC
 */
public with sharing class SmartvideoController {
    public static final String ENV_GENERIC = 'generic';

    public class IncompleteSettingsException extends Exception {}
    public class UnavailableException extends Exception {}

    /**
     * @description Retrieve Smartvideo App URL
     * @return String URL
     */
    @AuraEnabled(Cacheable=true)
    public static String getVideoAppUrl(SmartvideoSettingService settingService) {
        Smartvideo_Setting__mdt settings = settingService == null ? (new SmartvideoSettingService()).getSettings() : settingService.getSettings();

        if (settings == null) {
            throw new IncompleteSettingsException('Incomplete settings. Please contact your Salesforce administrator.');
        }

        Boolean isEnvGeneric = settings.environment__c.toLowerCase() == ENV_GENERIC;

        if (!hasAccess(settings)) {
            throw new UnavailableException('This tool is not available for you. Please contact your Salesforce administrator.');
        }

        return 'https://videome.leadsecure.com/nextjs/single/smartvideo/?environment='
                + EncodingUtil.urlEncode(settings.environment__c, 'UTF-8')
                + (isEnvGeneric ? (
                    '&externalId='
                    + EncodingUtil.urlEncode(settings.external_id__c, 'UTF-8')
                    + '&pak='
                    + EncodingUtil.urlEncode(settings.api_key__c, 'UTF-8')
                    + '&email='
                    + EncodingUtil.urlEncode(getIdentifier(), 'UTF-8')
                ) : '') + '&isPopup=true';
    }

    @TestVisible
    private static Boolean hasAccess(Smartvideo_Setting__mdt settings) {
        if (settings.use_custom_permissions__c) {
            return System.FeatureManagement.checkPermission('CanUseSmartVideo');
        }

        return true;
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