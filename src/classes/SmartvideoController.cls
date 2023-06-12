public with sharing class SmartvideoController {
    @AuraEnabled(Cacheable=true)
    public static String getVideoAppUrl() {
        return 'https://videome.leadsecure.com/nextjs/single/smartvideo/?environment=mypurecloud.com';
        //return 'https://018a-176-12-56-149.ngrok-free.app';
    }

    @AuraEnabled
    public static void pushEvent(String name, String payload) {
        System.debug('pushEvent: ');
        System.debug(name);
        System.debug(payload);
    }
}