<jsp:include page="includes/header.jsp" />



<div class="modal fade" id="mdlDVInfo" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content" id="dvContentMdl">
      
  </div>
</div>

<jsp:include page="includes/footer.jsp" />

<script type="text/javascript">
	

	$(document).ready(function() {
		$.getJSON("/dashboard/data/dataviews.json", function( data ) {
			var source   = $("#tplDataViews").html();
			var template = Handlebars.compile(source);
			$("#container").append(template({ dataviews : data}));
			appendFooter();

			//Start binding UI events from here onwards
			$('#dvList a').click(function () {
				var dataview = $(this).attr('data-dataview');
				console.log("Loading DV content for " + dataview);
				renderDVContent(dataview);
			});

			//load the DVContent for first item in the list
			renderDVContent($("#dvList a:first-child").attr("data-dataview")); 
			
		});



	});

	function renderDVContent(dataview) {
		// var dv = {name:"foo",type:"bar",datasource:"bax",widgets:[{id:"1234ew",title:"Sales By Region"}]};
		var dv = {name:"foo",type:"bar",datasource:"bax",widgets:[]};
		var source   = $("#tplDVInfo").html();
		var template = Handlebars.compile(source);
		$("#dvContent").empty();
		$("#dvContent").append(template(dv));

		$("#dvTitle").empty().append(dataview + " Overview");
	};

	function appendFooter() {
		var source   = $("#footer").html();
		var template = Handlebars.compile(source);

		$("#container").append(template());
	};

	$('#mdlDVInfo').on('show.bs.modal', function (event) {
		  var button = $(event.relatedTarget) // Button that triggered the modal
		  var dataview = button.data('dataview') // Extract info from data-* attributes
		  // // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
		  // // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
		  // var modal = $(this)
		  // modal.find('.modal-title').text('New message to ' + recipient)
		  console.log("Modal has been loaded for " + dataview); 
		  var dv = {name:"foo",type:"bar",datasource:"bax",widgets:[{id:"1234ew",title:"Sales By Region"}]};
		  var source   = $("#tplDVInfo").html();
		  var template = Handlebars.compile(source);
		  $("#dvContent").empty();
		  $("#dvContent").append(template(dv));

		  $("#dashboardList li a").click(function(e) {
		  	var btn = $(e.relatedTarget);
		  	// var widgetId = $(e.relatedTarget).data('widget');
		  	console.log("Widget [ " + btn + "] has been selected.");
		  	//create a position and send this to   
		  	var dashboardId = $("#dashboardList option:selected").text();
		  	console.log(dashboardId); 
		  });

	});



</script>

<script id="tplDataViews" type="text/x-handlebars-template">
	<div class="panel panel-default">
		<div class="panel-heading">
		    <h2 class="panel-title">Explore DataViews</h2>
		  </div>
	    <div class="panel-body">
	    	{{#if dataviews}}
		        <div class="col-md-3">
		        	<div class="list-group" id="dvList">
		        		{{#each dataviews}}
			              <a class="list-group-item" href="#" data-dataview="{{name}}">
			              	<i class="fa fa-history fa-fw"></i>
			              	{{name}}
			               </a>
				        {{/each}}  
			        </div>
		        </div>
		        <div class="col-md-9">
		        	<div class="panel panel-default" id="dvInfo">
		        		<div class="panel-heading">
    				    	<h2 class="panel-title" id="dvTitle"></h2>
    				    </div>
    				    <div class="panel-body" id="dvContent"></div>
		        	</div>
		        </div>
		    {{else}}
		    	<div class="blank-slate-message">
		    	    <h2>You have not created any DataViews.</h2>
		    	    <p>Get started by creating a new DataView.</p>
		    	    <a href="#">
		    	        <button data-toggle="modal" data-target="#mdlDVInfo" type="button" class="btn btn-success">Create New DataView</button>
		    	    </a>
		    	</div>
		    {{/if}}

	    </div>
	</div>
</script>

<script id="tplDVInfo" type="text/x-handlebars-template">
	<h4>Properties</h4>
	<table class="table">
	      <tbody>
	        <tr>
	          <th scope="row">Name</th>
	          <td>{{name}}</td>
	        </tr>
	        <tr>
	          <th scope="row">Type</th>
	          <td>{{type}}</td>
	        </tr>
	        <tr>
	          <th scope="row">Datasource</th>
	          <td>{{datasource}}</td>
	        </tr>
	        <tr>
	          <th scope="row">Filter</th>
	          <td>{{filter}}</td>
	        </tr>
	        <tr>
	          <th scope="row">Columns</th>
	          <td>{{columns}}</td>
	        </tr>
	      </tbody>
	</table>
	{{#if widgets}}
		<h4>Associated Widgets</h4>
        <div class="row">
        	<div class="container-fluid">
        		{{#each widgets}}
		          <div class="col-sm-6 col-md-6">
		            <div class="thumbnail">
		              <div class="caption">
		                <h4>{{title}}</h4>

		                <button type="button" class="btn btn-default" id="btnTrash">
		                	<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
		                </button>
		                <button type="button" class="btn btn-default" id="btnCog">
		                	<span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
		                </button>

		                <div class="btn-group" role="group">
		                  <button type="button" class="btn btn-success dropdown-toggle" 
		                  data-toggle="dropdown" data-widget="{{id}}" aria-expanded="false">
		                    Add to Dashboard
		                    <span class="caret"></span>
		                  </button>
		                  <ul class="dropdown-menu" role="menu" id="dashboardList">
		                    <li><a href="#">Dropdown link</a></li>
		                  </ul>
		                </div>

		               </div>

		              </div>
		            </div>
		          </div>
		        {{/each}}  
        	</div>
        </div>
    {{else}}
    	<div class="blank-slate-message">
    	    <h4>DataView {{name}} has no widgets associated.</h4>
    	    <a href="#">
    	        <button data-toggle="modal" data-target="#mdlDVInfo" type="button" class="btn btn-success">Create New Widget</button>
    	    </a>
    	</div>
    {{/if}}
</script>

<script id="tplDataViews_" type="text/x-handlebars-template">
	<div class="panel panel-default">
		<div class="panel-heading">
		    <h2 class="panel-title">Explore DataViews</h2>
		  </div>
	    <div class="panel-body">
	    	{{#if dataviews}}
		        <div class="row">
		        	<div class="container-fluid">
		        		{{#each dataviews}}
				          <div class="col-sm-6 col-md-3">
				            <div class="thumbnail">
				            	<a href="#"><img src="http://placehold.it/300x120" class="img-responsive"/></a>
				              <div class="caption">
				                <h4>{{name}}</h4>
				                <div class="btn-group" role="group">
				                  <button type="button" class="btn btn-default">
				                  	<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
				                  </button>
				                  <button type="button" class="btn btn-default">
				                  	<span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
				                  </button>
				                  <button type="button" class="btn btn-success" role="button" data-toggle="modal" data-target="#mdlDVInfo" data-dataview="{{name}}">
				                  	Explore
				                  </button>
				                  
				                </div>

				              </div>
				            </div>
				          </div>
				        {{/each}}  
		        	</div>
		        </div>
		    {{else}}
		    	<div class="blank-slate-message">
		    	    <h2>You have not created any DataViews.</h2>
		    	    <p>Get started by creating a new DataView.</p>
		    	    <a href="#">
		    	        <button data-toggle="modal" data-target="#mdlDVInfo" type="button" class="btn btn-success">Create New DataView</button>
		    	    </a>
		    	</div>
		    {{/if}}

	    </div>
	</div>
</script>

<script id="tplDVInfo_" type="text/x-handlebars-template">
	  <div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	    <h4 class="modal-title" id="myModalLabel">Overview for {{name}}</h4>
	  </div>
	  <div class="modal-body">
    	<h4>Properties</h4>
    	<table class="table">
    	      <tbody>
    	        <tr>
    	          <th scope="row">Name</th>
    	          <td>{{name}}</td>
    	        </tr>
    	        <tr>
    	          <th scope="row">Type</th>
    	          <td>{{type}}</td>
    	        </tr>
    	        <tr>
    	          <th scope="row">Datasource</th>
    	          <td>{{datasource}}</td>
    	        </tr>
    	        <tr>
    	          <th scope="row">Filter</th>
    	          <td>{{filter}}</td>
    	        </tr>
    	        <tr>
    	          <th scope="row">Columns</th>
    	          <td>{{columns}}</td>
    	        </tr>
    	      </tbody>
    	</table>
    	{{#if widgets}}
    		<h4>Associated Widgets</h4>
            <div class="row">
            	<div class="container-fluid">
            		{{#each widgets}}
    		          <div class="col-sm-6 col-md-6">
    		            <div class="thumbnail">
    		              <div class="caption">
    		                <h4>{{title}}</h4>

    		                <button type="button" class="btn btn-default" id="btnTrash">
    		                	<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
    		                </button>
    		                <button type="button" class="btn btn-default" id="btnCog">
    		                	<span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
    		                </button>

    		                <div class="btn-group" role="group">
    		                  <button type="button" class="btn btn-success dropdown-toggle" 
    		                  data-toggle="dropdown" data-widget="{{id}}" aria-expanded="false">
    		                    Add to Dashboard
    		                    <span class="caret"></span>
    		                  </button>
    		                  <ul class="dropdown-menu" role="menu" id="dashboardList">
    		                    <li><a href="#">Dropdown link</a></li>
    		                  </ul>
    		                </div>

    		               </div>

    		              </div>
    		            </div>
    		          </div>
    		        {{/each}}  
            	</div>
            </div>
        {{else}}
        	<div class="blank-slate-message">
        	    <h4>DataView {{name}} has no widgets associated.</h4>
        	    <a href="#">
        	        <button data-toggle="modal" data-target="#mdlDVInfo" type="button" class="btn btn-success">Create New Widget</button>
        	    </a>
        	</div>
        {{/if}}
	  </div>
	  <div class="modal-footer">
	    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	    <button id="btnSave" type="button" class="btn btn-primary">Save</button>
	  </div>
	</div>
</script>



<script id="footer" type="text/x-handlebars-template">
	<hr>
	<p class="small text-muted">Built with &#9829; by <a href="https://wso2.com">WSO2</a></p>
</script>