package dashboard;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Dashboard implements Serializable {

    private static final long serialVersionUID = 7526472295622776147L;

    private String id;
    private String title;
    private String group;
    private List<WidgetAndDimension> widgets;

    public Dashboard(String id, String title, String group) {
        this.id = id;
        this.title = title;
        this.group = group;
        this.widgets = new ArrayList<WidgetAndDimension>();
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

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public List<WidgetAndDimension> getWidgets() {
        return widgets;
    }

    public void setWidgets(List<WidgetAndDimension> widgets) {
        this.widgets = widgets;
    }
}
