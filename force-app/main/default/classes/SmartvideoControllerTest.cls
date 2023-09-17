@IsTest
private class SmartvideoControllerTest {
    @IsTest
    static void getVideoAppUrlTest() {
        Test.startTest();

        String result = SmartvideoController.getVideoAppUrl();

        System.assertNotEquals(null, result, 'Video App Url should not be NULL');
        System.assertEquals('https://videome.leadsecure.com/nextjs/single/smartvideo/?environment=test+value', result, 'Unexpected App url value');

        Test.stopTest();
    }

    @IsTest
    static void getEnvironmentTest() {
        Test.startTest();

        String result = SmartvideoController.getEnvironment(null);

        System.assertNotEquals(null, result, 'Environment should not be NULL');
        System.assertEquals('', result, 'Environment must be empty string');

        result = SmartvideoController.getEnvironment('test');

        System.assertNotEquals(null, result, 'Environment should not be NULL');
        System.assertEquals('', result, 'Environment must be empty string');

        result = SmartvideoController.getEnvironment(SmartvideoController.SETTINGS_ENV);

        System.assertNotEquals(null, result, 'Environment should not be NULL');
        System.assertEquals('test value', result, 'Environment contain wrong value');

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