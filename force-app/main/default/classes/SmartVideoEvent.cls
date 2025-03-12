/**
 * This class is a structure for unpacking the SmartVideo event data
 */
public class SmartVideoEvent {
    public SmartVideoStruct smartVideo;
    public FocusedTabInfo tabInfo;  

    public static SmartVideoEvent parse(String jsonData) {
        return (SmartVideoEvent) JSON.deserialize(jsonData, SmartVideoEvent.class);
    }
}