@IsTest
private class SmartvideoControllerTest {
    @IsTest
    static void getVideoAppUrlTest() {
        Test.startTest();

        String result = SmartvideoController.getVideoAppUrl();

        System.assertNotEquals(null, result);
        System.assertEquals('https://videome.leadsecure.com/nextjs/single/smartvideo/?environment=test+value', result);

        Test.stopTest();
    }

    @IsTest
    static void getEnvironmentTest() {
        Test.startTest();

        String result = SmartvideoController.getEnvironment(null);

        System.assertNotEquals(null, result);
        System.assertEquals('', result);

        result = SmartvideoController.getEnvironment('test');

        System.assertNotEquals(null, result);
        System.assertEquals('', result);

        result = SmartvideoController.getEnvironment(SmartvideoController.SETTINGS_ENV);

        System.assertNotEquals(null, result);
        System.assertEquals('test value', result);

        Test.stopTest();
    }

    @IsTest
    static void pushEventTest() {
        Test.startTest();

        Boolean result = SmartvideoController.pushEvent(null, null);

        System.assertEquals(false, result);

        result = SmartvideoController.pushEvent('test', null);

        System.assertEquals(false, result);

        result = SmartvideoController.pushEvent('test', '{id:123}');

        System.assertEquals(true, result);

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

        System.assertEquals(false, hasExeption);

        Test.stopTest();
    }
}