({
    handleUtilityBarApiCall: function (cmp, evt, helper) {
        const utilityAPI = cmp.find("UtilityBarApi");

        if (utilityAPI) {
            const methodName = evt.getParam('methodName');
            const methodArgs = evt.getParam('methodArgs');

            if (!methodName) {
                return;
            }

            if (!helper.isUtilityBarApiMethod(methodName)) {
                console.log(`${methodName} is not an UtilityBar API method`);
                return;
            }

            try {
                utilityAPI[methodName](methodArgs);
            } catch (e) {
                console.error(e);
            }

            return;
        }

        console.log("Utility Bar API was not found");
    }
});