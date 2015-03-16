<jsp:include page="includes/header.jsp" />



<div class="modal fade" id="mdlDashboard" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Create a new Dashboard</h4>
      </div>
      <div class="modal-body">
        <form>
          <div class="form-group">
            <label for="exampleInputEmail1">Dashboard Title</label>
            <input type="text" class="form-control" id="dashboardTitle">
          </div>
          <div class="form-group">
            <label for="exampleInputPassword1">Group</label>
            <input type="text" class="form-control" id="dashboardGroup">
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button id="btnSave" type="button" class="btn btn-primary">Save</button>
      </div>
    </div>
  </div>
</div>

<jsp:include page="includes/footer.jsp" />

<script type="text/javascript">

	$(document).ready(function() {
		$.getJSON("/dashboard/servlet/dashboard", function( data ) {
			if(data.length == 0) {
				console.log("No dashboards"); 
				showNoDashboards();
			} else {
				$("#container").remove();
				var source   = $("#tplDashboards").html();
				var template = Handlebars.compile(source);
				$("body").append(template());
				drawSidebar(data);

			}
				appendFooter();
		});
		//append the footer
	});

	$("#btnSave").on("click",function () {
		var request = {
			"action" : "addDashboard",
			"title" : $("#dashboardTitle").val(),
			"group" : $("#dashboardTitle").val()
		};
		$.post( "/dashboard/servlet/dashboard", request,function( data ) {
		  console.log("POST sent to server. Received data " + data); 
		  window.location.reload();
		  $('#mdlDashboard').modal('hide');
		});
		
	});

	function drawSidebar(data) {
		  var sidebar = $("#sidebar");
		  var listGroup = jQuery('<div/>', {
		      class: 'list-group'
		  });

	    data.forEach(function (dashboard,index) {
	      var item = jQuery('<a/>', {
	        class: 'list-group-item',
	        id: dashboard.id,
	        href: '#',
	        title: dashboard.title,
	        text: dashboard.title
	      }).appendTo(listGroup);

	      item.on('click',function (e) {
	          drawDashboard(dashboard.id);
	      });
	      if(index == 0 ) {
	        drawDashboard(dashboard.id);
	      }
	    });

	  	listGroup.appendTo(sidebar);
	};

    function drawDashboard(dashboardId) {
    	var request = {
    		"action" : "getDashboardById",
    		"dashboardId" : dashboardId
    	};
      	$.getJSON("/dashboard/servlet/dashboard",request,function (data) {
	        if(data.widgets && data.widgets.length!=0) {
        		var title = data.title;
	        	var widgets = data.widgets;
	        	//Remove the data from the #canvans so that we can redraw the widgets
	        	$("#canvas").empty();
	        	$("#canvas").removeData();

	        	var gridster = $("#canvas").gridster( {
	        	    widget_base_dimensions: [100, 100],
	        	    widget_margins: [5, 5],
	        	    min_cols: 1,
	        	    max_cols: 8,
	        	    avoid_overlapped_widgets: false,
	        	    autogenerate_stylesheet: true

	        	}).data('gridster');

	        	//draw each widget
	        	for (var i = 0; i < widgets.length; i++) {
	        	  var widget = new Widget(widgets[i]);
	        	  //draw a fucking canvas first
	        	  createCanvas(gridster,widget);
	        	  //then bind data
	        	  drawWidget(widget,gridster,bindingSource);
	        	};
	        } else {
	        	console.log("no wodgets");
	        	var source   = $("#tplNoWidgets").html();
	        	var template = Handlebars.compile(source);

	        	$("#widget-container").empty();
	        	$("#widget-container").append(template());
	        }

      });
    
    };

    function createCanvas(gridster,widget) {
      var canvas = $('#canvas');
      var container = jQuery('<li/>');

      var panel = jQuery('<div/>', {
//        class: 'panel panel-default'
      });

      var panelBody = jQuery('<div/>', {
//        class: 'panel-body',
        id: widget.id
      }).appendTo(panel);

      panel.appendTo(container);
      container.appendTo(canvas);

      gridster.add_widget(createPanelWithGadget('dummyDiv',container),widget.dimensions.width, widget.dimensions.height);

    }

    function createPanelWithGadget(divId, gadgetObject){
        var divPanel = $('<div>',{class:'panel panel-default',
            height:'auto'
        });

        var  width=gadgetObject.find('.marks').length;//attr('height');
        var height=gadgetObject.find('svg').attr('width');

        var divPanelHeading = $('<div>',{class:'panel-heading'});
        divPanelHeading.appendTo(divPanel);

        var divBtnGroup = $('<div>',{class:'btn-group pull-right'});
        divBtnGroup.appendTo(divPanelHeading);

        var aConfigs = $('<a>',{class:'btn-control'});
        var spanConfig = $('<span>',{class:'glyphicon glyphicon-cog btn'});
        spanConfig.appendTo(aConfigs);
        aConfigs.appendTo(divBtnGroup);

        aConfigs.on('click',function () { $('#myModal').modal({
            keyboard: true
        })});


        var aFullScreen = $('<a>',{class:'btn-control'});
        var spanFullScreen = $('<span>',{class:'glyphicon glyphicon-fullscreen btn'});
        spanFullScreen.appendTo(aFullScreen);
        aFullScreen.appendTo(divBtnGroup);


          aFullScreen.on('click',function(){

              var widget =  $(this).closest('.panel-default');
              var t = aFullScreen.find('span');

              if(widget.hasClass('maximized')){
                  widget.removeClass('maximized');
                  $('.panel-default').show();
                  widget.attr('data-sizex', 4);
                  widget.attr('data-sizey', 4);
                  t.addClass('glyphicon-fullscreen');
                  t.removeClass('glyphicon-resize-small')
              }
              else{
                  $('.panel-default').hide();
                  widget.show();
                  widget.attr('data-sizex', 5);
                  widget.attr('data-sizey', 5);
                  widget.addClass('maximized');

                  t.removeClass('glyphicon-fullscreen');
                  t.addClass('glyphicon-resize-small');

                  var m = divPanel.height();
                  var h = gadgetObject.find('svg').attr('height', 600);
                  console.log('h : ' + divPanel.height());

                  //console.log('t: ' + t);



              }
              var l = $(this).parents('.panel-default').length;

              console.log('len : ' + l);
          });



        var aRemove = $('<a>',{class:'btn-control'});
        var spanRemove = $('<span>',{class:'glyphicon glyphicon-remove btn'});
        spanRemove.appendTo(aRemove);
        aRemove.appendTo(divBtnGroup);

        aRemove.on('click',function(){
            $(this).closest('.panel-default').remove();
        });

        var h1PanelTitle = $('<h1>',{class:'panel-title', text:'title'});
        h1PanelTitle.appendTo(divPanelHeading);

        var divClearFix = $('<div>',{class:'clearfix'});
        divClearFix.appendTo(divPanelHeading);

        var divPanelBody = $('<div>',{class:'panel-body', id:divId});
        divPanelBody.appendTo(divPanel);

        gadgetObject.appendTo(divPanelBody);

        return divPanel;
    }

    function drawWidget(widget) {
      console.log("drawing widget " + widget.id); 
      $.getJSON("data/widgets/" + widget.id + ".json",function (data) {
        var dataTable = new igviz.DataTable();
        data.columns.forEach(function (element,index) {
            var tokens = element.split(":");
            dataTable.addColumn(tokens[0],tokens[1]);
        });

        //do some width hiegth manipulation
        data.widget.config.width = widget.dimensions.width * 100;        
        data.widget.config.height = widget.dimensions.height * 100;     

        // var chart = igviz.plot("#" + widget.id,data.widget.config,dataTable);
        var chart = igviz.setUp("#" + widget.id,data.widget.config,dataTable);
        bindingSource.addWidget(widget.dataview,chart);

        //check for widgets type and set the data access strategy.
        //E.g Poll if type set to batch, subscribe for WS if type set to realtime
        //request data for this widget and register a callback to process them later
        $.getJSON("data/data/" + data.name + ".json",function (d) {
          handleWidgetData(d);
        });
        
      });

    };

	function showNoDashboards() {
		var source   = $("#tplNoDashboards").html();
		var template = Handlebars.compile(source);

		$("#container").append(template());
	}

	function appendFooter() {
		var source   = $("#footer").html();
		var template = Handlebars.compile(source);

		$("#container").append(template());
	}






</script>

<script id="tplDashboards" type="text/x-handlebars-template">
	<div id="wrapper">

	  <!-- Sidebar -->
	  <div id="sidebar-wrapper">

	      <div class="panel panel-default">
	        <div class="panel-body" id="sidebar">

	        </div>
	      </div>
	  </div>
	  <!-- /#sidebar-wrapper -->

	  <!-- Page Content -->
	  <div id="page-content-wrapper">
	      <div class="container-fluid">
	          <div class="row" id="widget-container">

	              <div  class="gridster">
	                <ul id="canvas"></ul>
	              </div>

	          </div>
	          <!-- /row -->

	         

	      </div>  
	      <!-- /container -->
	  </div>
	  <!-- /#page-content-wrapper -->


	</div>
	<!-- /wrapper -->
</script>

<script id="tplNoDashboards" type="text/x-handlebars-template">
  <div class="panel panel-default">
      <div class="panel-body">
          <div class="blank-slate-message">
              <h2>You haven't created any Dashboards yet.</h2>
              <p>Get started by creating a new Dashboard.</p>
              <a href="#">
                  <button data-toggle="modal" data-target="#mdlDashboard" type="button" class="btn btn-success">Create New Dashboard</button>
              </a>
          </div>

      </div>
  </div>
</script>

<script id="tplNoWidgets" type="text/x-handlebars-template">
  <div class="panel panel-default">
      <div class="panel-body">
          <div class="blank-slate-message">
              <h2>This Dashboard has no widgets.</h2>
              <p>Browse for widgets and add to Dashboard.</p>
              <a href="dataviews.jsp">
                  <button type="button" class="btn btn-success">Add Widget</button>
              </a>
          </div>

      </div>
  </div>
</script>

<script id="footer" type="text/x-handlebars-template">
	<hr>
	<p class="small text-muted">Built with &#9829; by <a href="https://wso2.com">WSO2</a></p>
</script>