public virtual class SmartvideoSettingService {
    /**
     * @description Retrieve settings from custom metadata type Smartvideo_Setting__mdt object
     * @return Smartvideo_Setting__mdt - A record containing the settings
     */
    public virtual Smartvideo_Setting__mdt getSettings() {
        List<Smartvideo_Setting__mdt> result = [
            SELECT api_key__c, environment__c, external_id__c, use_custom_permissions__c  FROM Smartvideo_Setting__mdt LIMIT 1
        ];

        if (Test.isRunningTest()) {
            result.clear();
            result.add(
                new Smartvideo_Setting__mdt(
                    environment__c = 'generic',
                    external_id__c = 'external-id-test-value',
                    api_key__c = 'api-key-test-value',
                    use_custom_permissions__c = false
                )
            );
        }

        if (result.IsEmpty()) {
            return null;
        }

        return result.get(0);
    }
}
