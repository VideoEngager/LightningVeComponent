public without sharing class SmartvideoController {
    public static final String SETTINGS_ENV = 'environment';
    @AuraEnabled(Cacheable=true)
    public static String getVideoAppUrl() {
        String environmentParamValue = getEnvironment(SETTINGS_ENV);
        return 'https://videome.leadsecure.com/nextjs/single/smartvideo/?environment='
                + EncodingUtil.urlEncode(environmentParamValue, 'UTF-8');
    }

    @TestVisible
    private static String getEnvironment(String settingName) {
        if (String.isNotBlank(settingName)) {
            List<Smartvideo_setting__mdt> settings = [
                    SELECT value__c
                    FROM Smartvideo_Setting__mdt
                    WHERE DeveloperName = :settingName
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
        }

        return '';
    }

    @AuraEnabled
    public static Boolean pushEvent(String name, String payload) {
        if (String.isNotBlank(name) && String.isNotBlank(payload)) {
            SmartvideoEvent__e event = new SmartvideoEvent__e(
                    Name__c = name,
                    Payload__c = payload
            );
            System.debug(LoggingLevel.DEBUG, 'Smartvideo pushing event: ' + name);
            System.debug(LoggingLevel.DEBUG, payload);

            Database.SaveResult result = EventBus.publish(event);

            if (!result.isSuccess()) {
                logError('Smartvideo push event error:', result.getErrors());
                return false;
            }

            return true;
        }

        return false;
    }

    @TestVisible
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