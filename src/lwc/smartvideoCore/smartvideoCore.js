import {LightningElement, wire} from 'lwc';
import getVideoAppUrl from '@salesforce/apex/SmartvideoController.getVideoAppUrl';
import pushEvent from '@salesforce/apex/SmartvideoController.pushEvent';
import {UtilityBarApi} from "c/utilityBarApi";

export default class SmartvideoCore extends LightningElement {
    isInitialized = false;
    isLoading = true;
    appUrl = "";
    utilityBarApi = new UtilityBarApi(null);

    @wire(getVideoAppUrl)
    getVideoAppUrl({ data, error }) {
        this.isLoading = false;

        if (data) {
            console.log("getVideoAppUrl = ", data);
            const targetElement = this.template.querySelector('iframe');

            if (targetElement) {
                targetElement.src = data;
            }

            this.appUrl = data;
        } else if (error) {
            console.log("Error in getVideoAppUrl", error);
        }
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
                console.log("Receiving message:", JSON.parse(JSON.stringify(evt.data || "")));
            }
        });
    }

    processAppMessage(message) {
        switch (message?.status) {
            case "CALL_STARTED":
                this.utilityBarApi.openUtility();
                break;
            case "CALL_ENDED":
                this.utilityBarApi.minimizeUtility();
                break;
        }

        // pass the message as platform event
        pushEvent({ name: message?.status, payload: JSON.stringify(message)}).catch(e => {
            console.log('Unable to push event: ', message.status, JSON.parse(JSON.stringify(message)));
            console.log('pushEvent error:', e);
        })
    }

    handleIframeOnLoad() {
        console.log("Iframe has been loaded");
    }
}