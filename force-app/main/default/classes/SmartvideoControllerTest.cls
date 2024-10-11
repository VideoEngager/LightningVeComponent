@IsTest
private class SmartvideoControllerTest {
    @IsTest
    static void getVideoAppUrlTest() {
        Test.startTest();

        String result = SmartvideoController.getVideoAppUrl();

        System.assertNotEquals(null, result, 'Video App Url should not be NULL');
        String expectedUrl = 'https://videome.leadsecure.com/nextjs/single/smartvideo/?environment=generic&externalId=external-id-test-value&pak=api-key-test-value&email='
            + EncodingUtil.urlEncode(SmartvideoController.getIdentifier(), 'UTF-8')
            + '&isPopup=true';

        System.assertEquals(expectedUrl, result, 'Unexpected App url value');
        
        Test.stopTest();
    }

    @IsTest
    static void getSettingsTest() {
        Test.startTest();

        Map<String, String> result = SmartvideoController.getSettings();
        System.assertNotEquals(null, result, 'Settings should not be NULL');

        System.assertNotEquals(null, result.get(SmartvideoController.SETTINGS_ENV), 'Environment Settings should not be NULL');
        System.assertNotEquals(null, result.get(SmartvideoController.SETTINGS_EXT_ID), 'External ID Settings should not be NULL');
        System.assertNotEquals(null, result.get(SmartvideoController.SETTINGS_API_KEY), 'API Key Settings should not be NULL');

        System.assertEquals(3, result.size(), 'Settings should contain 3 entries');

        Test.stopTest();
    }

    @IsTest
    static void getIdentifierTest() {
        Test.startTest();

        String result = SmartvideoController.getIdentifier();

        System.assertNotEquals(null, result, 'Identifier should not be NULL');
        System.assertEquals(UserInfo.getOrganizationId() + UserInfo.getUserEmail(), result, 'Identifier has unexpected value');

        Test.stopTest();
    }

    @IsTest
    static void pushEventTest() {
        Test.startTest();

        Boolean result = SmartvideoController.pushEvent(null, null);

        System.assertEquals(false, result, 'Pushing NULL event with NULL payload should not succeed');

        result = SmartvideoController.pushEvent('test', null);

        System.assertEquals(false, result, 'Pushing event with NULL payload should not succeed');

        result = SmartvideoController.pushEvent('test', '{id:123}');

        System.assertEquals(true, result, 'Pushing event with proper payload should succeed');

        Test.stopTest();
    }

    @IsTest
    static void logErrorTest() {
        Test.startTest();

        Boolean hasExeption = false;
        User testRecord = new User();
        Database.SaveResult sr = Database.insert(testRecord, false);

        try {
            SmartvideoController.logError('test', null);
            SmartvideoController.logError(null, null);
            SmartvideoController.logError('test', new List<Database.Error>());
            SmartvideoController.logError('test', sr.getErrors());
        } catch (Exception e) {
            hasExeption = true;
        }

        System.assertEquals(false, hasExeption, 'Logging error should not produce exceptions');

        Test.stopTest();
    }
}