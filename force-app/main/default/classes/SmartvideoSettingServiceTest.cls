@isTest
private class SmartvideoSettingServiceTest {
    @isTest
    static void getSettingsTest() {
        Test.startTest();

        SmartvideoSettingService service = new SmartvideoSettingService();
        SmartVideoSetting__mdt result = service.getSettings();

        System.assertNotEquals(null, result);

        Test.stopTest();
    }
}