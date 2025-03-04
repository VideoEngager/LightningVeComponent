@IsTest
public class SmartVideoEventTest {

    @IsTest
    static void testParsePreCall() {
        String preCallJson = '{'
            + '"smartVideo": {'
            + '    "status": "PRE_CALL",'
            + '    "email": "first@example.com",'
            + '    "shortUrl": "https://example.com/precall",'
            + '    "visitorId": "visitor-123",'
            + '    "pin": "1111",'
            + '    "tennant_id": "Tenant123",'
            + '    "callerEmail": "caller@example.com",'
            + '    "attributes": {'
            + '        "interactionOfferedTimestamp": 1737891645822,'
            + '        "totalSvInteractions": 1,'
            + '        "totalVideoCalls": 0,'
            + '        "totalScreenShareSessions": 0,'
            + '        "totalScreenShareSessionsTime": 0,'
            + '        "totalTalkTime": 0,'
            + '        "connectivityDropsCount": 0'
            + '    }'
            + '},'
            + '"tabInfo": {'
            + '    "tabId": "ctab0_1",'
            + '    "url": "https://example.com/tabUrl",'
            + '    "pinned": true,'
            + '    "closeable": true,'
            + '    "title": "Sample Title",'
            + '    "icon": "standard:account",'
            + '    "iconAlt": "Account",'
            + '    "highlighted": false,'
            + '    "pageReference": {'
            + '        "type": "standard__recordPage",'
            + '        "attributes": {'
            + '            "objectApiName": "Account",'
            + '            "recordId": "001xx000003DGmqAAG",'
            + '            "actionName": "view"'
            + '        },'
            + '        "state": {'
            + '            "ws": "/lightning/r/Account/001xx000003DGmqAAG/view"'
            + '        }'
            + '    },'
            + '    "isSubtab": false,'
            + '    "parentTabId": "ctab0",'
            + '    "focused": true,'
            + '    "recordId": "001xx000003DGmqAAG"'
            + '}'
            + '}';

        SmartVideoEvent eventObj = SmartVideoEvent.parse(preCallJson);

        System.assertNotEquals(null, eventObj, 'SmartVideoEvent should not be null.');
        System.assertNotEquals(null, eventObj.smartVideo, 'SmartVideo object should not be null.');
        System.assertEquals('PRE_CALL', eventObj.smartVideo.status, 'Status should match PRE_CALL.');

        System.assertEquals('first@example.com', eventObj.smartVideo.email, 'Email mismatch.');
        System.assertEquals('visitor-123', eventObj.smartVideo.visitorId, 'VisitorId mismatch.');
        System.assertEquals(1737891645822L, eventObj.smartVideo.attributes.interactionOfferedTimestamp, 'Timestamp mismatch.');

        System.assertNotEquals(null, eventObj.tabInfo, 'tabInfo should not be null.');
        System.assertEquals('ctab0_1', eventObj.tabInfo.tabId, 'tabId mismatch.');
        System.assertEquals(true, eventObj.tabInfo.pinned, 'Pinned should be true.');
        System.assertEquals('Account', eventObj.tabInfo.iconAlt, 'iconAlt mismatch.');
        System.assertEquals('/lightning/r/Account/001xx000003DGmqAAG/view', eventObj.tabInfo.pageReference.state.ws, 'PageReference ws mismatch.');
    }

    @IsTest
    static void testParseFinished() {
        String finishedJson = '{'
            + '"smartVideo": {'
            + '    "status": "FINISHED",'
            + '    "email": "second@example.com",'
            + '    "shortUrl": "https://example.com/finished",'
            + '    "visitorId": "visitor-789",'
            + '    "pin": "2222",'
            + '    "tennant_id": "TenantABC",'
            + '    "callerEmail": "caller2@example.com",'
            + '    "attributes": {'
            + '        "interactionOfferedTimestamp": 1737891646000,'
            + '        "totalSvInteractions": 2,'
            + '        "totalVideoCalls": 1,'
            + '        "totalScreenShareSessions": 1,'
            + '        "totalScreenShareSessionsTime": 120,'
            + '        "totalTalkTime": 80,'
            + '        "connectivityDropsCount": 0'
            + '    }'
            + '},'
            + '"tabInfo": {'
            + '    "tabId": "ctab1_2",'
            + '    "url": "https://example.com/anotherTabUrl",'
            + '    "pinned": false,'
            + '    "closeable": true,'
            + '    "title": "Another Title",'
            + '    "icon": "standard:opportunity",'
            + '    "iconAlt": "Opportunity",'
            + '    "highlighted": true,'
            + '    "pageReference": {'
            + '        "type": "standard__recordPage",'
            + '        "attributes": {'
            + '            "objectApiName": "Contact",'
            + '            "recordId": "003xx000004T6UUAA0",'
            + '            "actionName": "view"'
            + '        },'
            + '        "state": {'
            + '            "ws": "/lightning/r/Contact/003xx000004T6UUAA0/view"'
            + '        }'
            + '    },'
            + '    "isSubtab": true,'
            + '    "parentTabId": "ctab1",'
            + '    "focused": false,'
            + '    "recordId": "003xx000004T6UUAA0"'
            + '}'
            + '}';

        SmartVideoEvent eventObj = SmartVideoEvent.parse(finishedJson);

        System.assertNotEquals(null, eventObj, 'SmartVideoEvent should not be null.');
        System.assertNotEquals(null, eventObj.smartVideo, 'SmartVideo object should not be null.');
        System.assertEquals('FINISHED', eventObj.smartVideo.status, 'Status should be FINISHED.');

        System.assertEquals('second@example.com', eventObj.smartVideo.email, 'Email mismatch.');
        System.assertEquals('visitor-789', eventObj.smartVideo.visitorId, 'VisitorId mismatch.');
        System.assertEquals(1737891646000L, eventObj.smartVideo.attributes.interactionOfferedTimestamp, 'Timestamp mismatch.');

        System.assertNotEquals(null, eventObj.tabInfo, 'tabInfo should not be null.');
        System.assertEquals('ctab1_2', eventObj.tabInfo.tabId, 'tabId mismatch.');
        System.assertEquals(false, eventObj.tabInfo.pinned, 'Pinned should be false.');
        System.assertEquals('Opportunity', eventObj.tabInfo.iconAlt, 'iconAlt mismatch.');
        System.assertEquals('/lightning/r/Contact/003xx000004T6UUAA0/view', eventObj.tabInfo.pageReference.state.ws, 'PageReference ws mismatch.');
    }

    @IsTest
    static void testParsePartialData() {
        String partialJson = '{'
            + '"smartVideo": {'
            + '    "status": "PRE_CALL"'
            + '},'
            + '"tabInfo": null'
            + '}';

        SmartVideoEvent eventObj = SmartVideoEvent.parse(partialJson);

        System.assertNotEquals(null, eventObj, 'SmartVideoEvent should not be null.');
        System.assertNotEquals(null, eventObj.smartVideo, 'SmartVideo object should not be null.');
        System.assertEquals('PRE_CALL', eventObj.smartVideo.status, 'Status should be PRE_CALL.');

        System.assertEquals(null, eventObj.smartVideo.email, 'Email should be null for partial data.');
        System.assertEquals(null, eventObj.tabInfo, 'tabInfo should be null');
    }
}