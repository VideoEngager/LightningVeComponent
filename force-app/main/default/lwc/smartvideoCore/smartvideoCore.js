import {LightningElement, wire} from 'lwc';
import getVideoAppUrl from '@salesforce/apex/SmartvideoController.getVideoAppUrl';
import pushEvent from '@salesforce/apex/SmartvideoController.pushEvent';
import {UtilityBarApi} from "c/utilityBarApi";

export default class SmartvideoCore extends LightningElement {
    isInitialized = false;
    isLoading = true;
    appUrl = "";
    errorMessage = undefined;
    utilityBarApi = new UtilityBarApi(null);

    @wire(getVideoAppUrl)
    getVideoAppUrl({ data, error }) {
        this.isLoading = false;

        if (data) {
            const targetElement = this.template.querySelector('iframe');

            if (targetElement) {
                targetElement.src = this.processUrl(data);
            }

            this.appUrl = data;
        } else if (error) {
            if (['SmartvideoController.UnavailableException', 'SmartvideoController.IncompleteSettingsException'].includes(error?.body?.exceptionType)) {
                this.errorMessage = error.body?.message || 'An unhandled error occurred';
            }

            console.log("Error in getVideoAppUrl", error);
        }
    }

    processUrl(url) {
        const urlObj = new URL(url);

        urlObj.searchParams.set('isPopup', 'true');
        urlObj.searchParams.set('enablePostMessage', 'true');

        return urlObj.toString();
    }
    connectedCallback() {
        this.oneTimeInitialization();
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