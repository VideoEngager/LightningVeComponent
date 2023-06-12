class UtilityBarApi {
    component = undefined;

    constructor(component) {
        this.component = component;
    }
    _execute(methodName, methodArgs) {
        const event = new CustomEvent('utilityBarAPICall', {
            detail: {
                methodName,
                methodArgs
            }
        });

        if (this.component?.dispatchEvent) {
            this.component.dispatchEvent(event);
        }
    }
    disableUtilityPopOut(disabled, disabledText) {
        this._execute('disableUtilityPopOut', { disabled, disabledText });
    }

    minimizeUtility() {
        this._execute('minimizeUtility', null);
    }

    openUtility() {
        this._execute('openUtility', null);
    }

    setPanelHeaderIcon(icon) {
        this._execute('setPanelHeaderIcon', { icon });
    }

    setPanelHeaderLabel(label) {
        this._execute('setPanelHeaderLabel', { label });
    }

    setPanelHeight(heightPX) {
        this._execute('setPanelHeight', { heightPX });
    }

    setPanelWidth(widthPX) {
        this._execute('setPanelWidth', { widthPX });
    }

    setUtilityHighlighted(highlighted) {
        this._execute('setUtilityHighlighted', { highlighted });
    }

    setUtilityIcon(icon) {
        this._execute('setUtilityIcon', { icon });
    }

    setUtilityLabel(label) {
        this._execute('setUtilityLabel', { label });
    }

    toggleModalMode(enableModalMode) {
        this._execute('toggleModalMode', { enableModalMode });
    }
}

export { UtilityBarApi }