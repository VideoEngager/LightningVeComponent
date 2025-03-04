import {LightningElement} from 'lwc';
import getVideoAppUrl from '@salesforce/apex/SmartvideoController.getVideoAppUrl';
import pushEvent from '@salesforce/apex/SmartvideoController.pushEvent';
import {UtilityBarApi} from "c/utilityBarApi";
import { getFocusedTabInfo } from 'lightning/platformWorkspaceApi';

export default class SmartvideoCore extends LightningElement {
    isInitialized = false;
    isLoading = true;
    appUrl = "";
    utilityBarApi = new UtilityBarApi(null);
    errorMessage = undefined;
    infoMap = new Map();

    setVideoAppUrl(url) {
        if (url) {
            const targetElement = this.template.querySelector('iframe');

            if (targetElement) {
                targetElement.src = this.processUrl(url);
            }

            this.appUrl = url;
        }

        this.isLoading = false;
    }

    processUrl(url) {
        const urlObj = new URL(url);

        urlObj.searchParams.set('isPopup', 'true');
        urlObj.searchParams.set('enablePostMessage', 'true');

        return urlObj.toString();
    }
    connectedCallback() {
        this.isLoading = true;
        this.oneTimeInitialization();

        getVideoAppUrl().then(resultUrl => {
            this.setVideoAppUrl(resultUrl)
        }).catch(error => {
            this.errorMessage = error.body?.message || 'An unhandled error occurred';
            console.log("Error in getVideoAppUrl", error, error?.body?.exceptionType);
        });
    }

    oneTimeInitialization() {
        if (!this.isInitialized) {
            this.initializeUtilityBarApi();
            this.attachEventListener();

            this.isInitialized = true;
        }
    }

    initializeUtilityBarApi() {
        this.utilityBarApi = new UtilityBarApi(this);
    }

    attachEventListener() {
        window.addEventListener("message", (evt) => {
            if (this.appUrl.startsWith(evt.origin)) {
                this.processAppMessage(evt.data);
            }
        });
    }

    async processAppMessage(message) {
        let focusedTabInfo = null;

        switch (message?.status) {
            case "PRE_CALL":
                try {
                    this.utilityBarApi.openUtility();
                } catch (e) {};
                // get current tab info
                focusedTabInfo = await getFocusedTabInfo();
                // store it in a key  - visitorId
                this.infoMap.set(message.visitorId, focusedTabInfo);

                break;
            case "FINISHED":
                try {
                    this.utilityBarApi.minimizeUtility();
                } catch (e) {};

                // retrieve tab info from visitorId key
                focusedTabInfo = this.infoMap.get(message.visitorId);
                break;
        }

        // pass the data as platform event
        const payload = JSON.stringify({
            smartVideo: message,
            tabInfo: focusedTabInfo
        });
        pushEvent({ name: message?.status, payload}).catch(e => {
            console.debug('Unable to push event: ', message.status, JSON.stringify(payload));
            console.debug('pushEvent error:', e);
        })
    }

    handleIframeOnLoad() {}
}