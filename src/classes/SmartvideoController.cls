public with sharing class SmartvideoController {
    public static final String SETTINGS_ENV = 'environment';
    @AuraEnabled(Cacheable=true)
    public static String getVideoAppUrl() {
        String environmentParamValue = getEnvironment(SETTINGS_ENV);
        return 'https://videome.leadsecure.com/nextjs/single/smartvideo/?environment='
                + EncodingUtil.urlEncode(environmentParamValue, 'UTF-8');
    }

    public static String getEnvironment(String settingName) {
        List<Smartvideo_setting__mdt> settings = [
                SELECT value__c FROM Smartvideo_Setting__mdt WHERE DeveloperName = :settingName LIMIT 1
        ];

        if (Test.isRunningTest()) {
            settings.clear();
            settings.add(new Smartvideo_Setting__mdt(
                    Label = 'Environment',
                    DeveloperName = 'environment',
                    value__c = 'test-value'
            ));
        }

        if (settings.size() != 0) {
            return settings[0].value__c;
        }

        return '';
    }

    @AuraEnabled
    public static void pushEvent(String name, String payload) {
        System.debug('pushEvent: ');
        System.debug(name);
        System.debug(payload);
    }
}