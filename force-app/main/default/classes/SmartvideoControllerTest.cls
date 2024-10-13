@IsTest
private class SmartvideoControllerTest {
    private class MockSmartvideoSettingService extends SmartvideoSettingService {        
        private Smartvideo_Setting__mdt mockSetting;

        public MockSmartvideoSettingService(Smartvideo_Setting__mdt mockSetting) {
            this.mockSetting = mockSetting;
        }

        public override Smartvideo_Setting__mdt getSettings() {
            return mockSetting;
        }
    }

    @IsTest
    static void getVideoAppUrlGenericTest() {
        Test.startTest();

        Smartvideo_Setting__mdt mockSetting = new Smartvideo_Setting__mdt(
            environment__c = 'generic',
            external_id__c = 'external-id-test-value',
            api_key__c = 'api-key-test-value',
            use_custom_permissions__c = false
        );

        String result = SmartvideoController.getVideoAppUrl(new MockSmartvideoSettingService(mockSetting));

        System.assertNotEquals(null, result, 'Video App Url should not be NULL');
        String expectedUrl = 'https://videome.leadsecure.com/nextjs/single/smartvideo/?environment=generic&externalId=external-id-test-value&pak=api-key-test-value&email='
            + EncodingUtil.urlEncode(SmartvideoController.getIdentifier(), 'UTF-8')
            + '&isPopup=true';

        System.assertEquals(expectedUrl, result, 'Unexpected App url value');
        
        Test.stopTest();
    }

    @IsTest
    static void getVideoAppUrlOtherTest() {
        Test.startTest();

        Smartvideo_Setting__mdt mockSetting = new Smartvideo_Setting__mdt(
            environment__c = 'environment-test-value',
            external_id__c = 'external-id-test-value',
            api_key__c = 'api-key-test-value',
            use_custom_permissions__c = false
        );

        String result = SmartvideoController.getVideoAppUrl(new MockSmartvideoSettingService(mockSetting));

        System.assertNotEquals(null, result, 'Video App Url should not be NULL');
        String expectedUrl = 'https://videome.leadsecure.com/nextjs/single/smartvideo/?environment=environment-test-value&isPopup=true';

        System.assertEquals(expectedUrl, result, 'Unexpected App url value');
        
        Test.stopTest();
    }

    @IsTest
    static void getVideoAppUrlNoSettingsTest() {
        Test.startTest();

        SmartvideoSettingService mockService = new MockSmartvideoSettingService(null);
        
        try {
            SmartvideoController.getVideoAppUrl(mockService);
            System.assert(false, 'Exception was expected but not thrown.');
        } catch (SmartvideoController.IncompleteSettingsException e) {
            System.assert(true, 'Incomplete settings exception was correctly thrown.');
        }

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
    static void hasAccessTest() {
        Test.startTest();

        Boolean result = SmartvideoController.hasAccess(
            new Smartvideo_Setting__mdt(
                environment__c = 'generic',
                external_id__c = 'external-id-test-value',
                api_key__c = 'api-key-test-value',
                use_custom_permissions__c = true
            )
        );

        System.assertNotEquals(null, result);

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