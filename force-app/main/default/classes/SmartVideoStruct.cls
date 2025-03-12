public class SmartVideoStruct {
    public String status;
    public String email;
    public String shortUrl;
    public String visitorId;
    public String pin;
    public String tennant_id;
    public String callerEmail;
    public SmartVideoEventAttributes attributes;

    public class SmartVideoEventAttributes {
        public Long interactionOfferedTimestamp;
        public Long totalSvInteractions;
        public Long totalVideoCalls;
        public Long totalScreenShareSessions;
        public Long totalScreenShareSessionsTime;
        public Long totalTalkTime;
        public Long connectivityDropsCount;
    }
}
