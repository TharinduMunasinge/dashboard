package dashboard;

import java.io.Serializable;

public class WidgetAndDimension implements Serializable {

    private static final long serialVersionUID = -7726934207728022189L;
    private String id;
    private Dimension dimension;

    public WidgetAndDimension(String id, Dimension dimension) {
        this.id = id;
        this.dimension = dimension;
    }

    public Dimension getDimension() {
        return dimension;
    }

    public void setDimension(Dimension dimension) {
        this.dimension = dimension;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
