package dashboard;

import java.io.Serializable;

public class Widget implements Serializable {

    private static final long serialVersionUID = -1809097406620474209L;
    private String id;
    private String title;

    public Widget(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
