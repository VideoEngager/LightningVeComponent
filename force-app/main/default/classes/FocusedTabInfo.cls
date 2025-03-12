public class FocusedTabInfo {
    public String tabId;
    public String url;
    public Boolean pinned;
    public Boolean closeable;
    public String title;
    public String icon;
    public String iconAlt;
    public Boolean highlighted;
    public PageReference pageReference;
    public Boolean isSubtab;
    public String parentTabId;
    public Boolean focused;
    public String recordId;

    public class PageReference {
        public String type;
        public Attributes attributes;
        public State state;
    }

    public class Attributes {
        public String objectApiName;
        public String recordId;
        public String actionName;
    }

    public class State {
        public String ws;
    }
}
