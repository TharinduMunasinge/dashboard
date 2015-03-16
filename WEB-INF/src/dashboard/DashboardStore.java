package dashboard;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

public class DashboardStore {

    private List<Dashboard> dashboardList;
    HttpSession session;

    public DashboardStore(HttpSession session) {
        this.session = session;
        this.populateDashboardList(session);
    }

    public List<Dashboard> getDashboardList() {
        return this.dashboardList;
    }

    public void addDashboard(Dashboard dashboard) {
        this.dashboardList.add(dashboard);
        session.setAttribute("dashboards",this.dashboardList);
    }

    public Dashboard getDashboardById(String dashboardId) {
        Dashboard dashboard = null;
        for(Dashboard d : this.dashboardList) {
            if(d.getId().equals(dashboardId)) {
                dashboard = d;
                break;
            }
        }
        return dashboard;
    }

    private void populateDashboardList(HttpSession session) {
        if(session.getAttribute("dashboards") != null) {
           this.dashboardList = (ArrayList<Dashboard>)session.getAttribute("dashboards");
        } else {
            this.dashboardList = new ArrayList<Dashboard>();
            session.setAttribute("dashboards",this.dashboardList);
        }
    }
}
