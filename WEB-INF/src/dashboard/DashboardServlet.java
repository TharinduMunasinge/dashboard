package dashboard;/*
* Licensed to the Apache Software Foundation (ASF) under one or more
* contributor license agreements.  See the NOTICE file distributed with
* this work for additional information regarding copyright ownership.
* The ASF licenses this file to You under the Apache License, Version 2.0
* (the "License"); you may not use this file except in compliance with
* the License.  You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response) {
        try {
            String action = request.getParameter("action");
            DashboardStore store = new DashboardStore(request.getSession());
            response.setContentType("application/json");
            Gson gson = new Gson();
            if (action == null) {
                if (store.getDashboardList().isEmpty()) {
                    response.getWriter().write("[]");
                } else {
                    List<Dashboard> dashboards = store.getDashboardList();
                    response.getWriter().write(gson.toJson(dashboards));
                }
            } else if(action.equalsIgnoreCase("getDashboardById")){
                String dashboardId = request.getParameter("dashboardId");
                Dashboard dashboard = store.getDashboardById(dashboardId);
                if (dashboard != null) {
                    response.getWriter().write(gson.toJson(dashboard));
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action.equalsIgnoreCase("addDashboard")) {
            createDashboard(req);
        } else if (action.equalsIgnoreCase("addWidget")) {
           addWidget(req);
        }
    }

    private void createDashboard(HttpServletRequest request) {
        DashboardStore store = new DashboardStore(request.getSession());
        Dashboard dashboard = new Dashboard(
                String.valueOf(System.currentTimeMillis()),
                request.getParameter("title"),
                request.getParameter("group")
        );
        store.addDashboard(dashboard);

        System.out.println("Dashboard created");
    }

    private void addWidget(HttpServletRequest request) {
        DashboardStore store = new DashboardStore(request.getSession());
        String dashboardId =  request.getParameter("dashboardId");
        String widgetId =  request.getParameter("widgetId");
        Dashboard dashboard = store.getDashboardById(dashboardId);
        if (dashboard != null) {
            WidgetAndDimension widget = new WidgetAndDimension(widgetId,new Dimension(1,1,4,4));
            dashboard.getWidgets().add(widget);
            System.out.println("Widget added to dashboard");
        }
    }
}
