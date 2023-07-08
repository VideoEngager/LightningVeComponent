({
    isUtilityBarApiMethod: function (methodName) {
        // All methods and their parameters are available at
        // https://developer.salesforce.com/docs/component-library/bundle/lightning:utilityBarAPI/specification
        const availableMethods = [
            'disableUtilityPopOut', 'getAllUtilityInfo', 'getEnclosingUtilityId', 'getUtilityInfo', 'isUtilityPoppedOut',
            'minimizeUtility', 'onUtilityClick', 'openUtility', 'setPanelHeaderIcon', 'setPanelHeaderLabel',
            'setPanelHeight', 'setPanelWidth', 'setUtilityHighlighted', 'setUtilityIcon', 'setUtilityLabel',
            'toggleModalMode'
        ];

        return availableMethods.includes(methodName);
    }
});