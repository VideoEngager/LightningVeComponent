import {LightningElement, wire} from 'lwc';
import getVideoAppUrl from '@salesforce/apex/SmartvideoController.getVideoAppUrl';
import pushEvent from '@salesforce/apex/SmartvideoController.pushEvent';
import {UtilityBarApi} from "c/utilityBarApi";

export default class SmartvideoCore extends LightningElement {
    isInitialized = false;
    isLoading = true;
    appUrl = "";
    utilityBarApi = new UtilityBarApi(null);
    errorMessage = undefined;

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
                console.debug("Receiving message:", JSON.parse(JSON.stringify(evt.data || "")));
            }
        });
    }

    processAppMessage(message) {
        switch (message?.status) {
            case "PRE_CALL":
                this.utilityBarApi.openUtility();
                break;
            case "FINISHED":
                this.utilityBarApi.minimizeUtility();
                break;
        }

        // pass the message as platform event
        pushEvent({ name: message?.status, payload: JSON.stringify(message)}).catch(e => {
            console.debug('Unable to push event: ', message.status, JSON.parse(JSON.stringify(message)));
            console.debug('pushEvent error:', e);
        })
    }

    handleIframeOnLoad() {}
}