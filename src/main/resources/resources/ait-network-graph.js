var networkGraph = {
	
	alchemy: null,
	getParams: [],
	
	c: {
		dataSource: null,
		
		graph: {
			dataSource: null,
			divSelector: '#network-graph',
			backgroundColour: '#ffffff',
			directedEdges: false,
			initialScale: 1,
			scaleExtent: [0.5, 1.5],

			nodeClick: function(n, event) {
				networkGraph.showInformationPanel(event.pageX, event.pageY, 'node', n.getProperties());
			},
			nodeTypes: { "role": 
				["PATCH-PANEL", "SWITCH", "SERVER"] 
			}, 
			nodeStyle: {
				"all": {
					"borderColor": "#ff8f02",
					"borderWidth": function(d, radius) {
						return radius / 5
					},
					"color": function(d) { 
						return "rgba(127, 127, 127, 0.5)"
					}, 
					"radius": function(d) {
						if(d.getProperties().root)
						return 20; else return 10 
					},
					"captionOffset": 22
				},
				"PATCH-PANEL":{
					"borderColor": "#ff8f02",
					"color": "#ace9ff",
					"selected": {
						"color": "#333333",
					},                    
					"highlighted": {
						"color": "#005c96"
					}
				},
				"SWITCH":{
					"borderColor": "#ff8f02",
					"color": "#9bf896",
					"selected": {
						"color": "#333333",
					},                    
					"highlighted": {
						"color": "#409e43"
					},
					"radius": function(d) {
						return 15;
					}
				},
				"SERVER":{
					"borderColor": "#ff8f02",
					"color": "#fcf8e3",
					"selected": {
						"color": "#333333",
					},                    
					"highlighted": {
						"color": "#d3cfba"
					}
				}

			},
			curvedEdges: false,
			edgeClick: function(e, event){
				networkGraph.showInformationPanel(event.pageX, event.pageY, 'edge', e.getProperties());
			},
			edgeTypes: {"edgeType": ["gray", "black", "green", "blue", "red", "yellow", "aqua", "multiply"]},
			edgeStyle: {
				"all": {
					"color": "#333333",
					"width": 3
				},
				
				"gray": {
					"width": 3,
					"color": "rgba(128,128,128,1)",
					"opacity": 0.6,
					"selected": {
						"opacity": 1
					},
					"highlighted": {
						"opacity": 1
					}				
				},
				"black": {
					"width": 3,
					"color": "rgba(0,0,0,1)",
					"opacity": 0.6,
					"selected": {
						"opacity": 1
					},
					"highlighted": {
						"opacity": 1
					}
				},
				"green": {
					"width": 3,
					"color": "rgba(0,255,0,1)",
					"opacity": 0.6,
					"selected": {
						"opacity": 1
					},
					"highlighted": {
						"opacity": 1
					}
				},
				"blue": {
					"width": 3,
					"color": "rgba(0,0,255,1)",
					"opacity": 0.6,
					"selected": {
						"opacity": 1
					},
					"highlighted": {
						"opacity": 1
					}
				},
				"red": {
					"width": 3,
					"color": "rgba(255,0,0,1)",
					"opacity": 0.6,
					"selected": {
						"opacity": 1
					},
					"highlighted": {
						"opacity": 1
					}
				},
				"yellow": {
					"width": 3,
					"color": "rgba(255,255,0,1)",
					"opacity": 0.6,
					"selected": {
						"opacity": 1
					},
					"highlighted": {
						"opacity": 1
					}
				},
				"aqua": {
					"width": 3,
					"color": "rgba(96,196,212,1)",
					"opacity": 0.6,
					"selected": {
						"opacity": 1
					},
					"highlighted": {
						"opacity": 1
					}
				},				
				"multiply": {
					"width": function(e){
						if (e.getProperties().weight) return (e.getProperties().weight + 3)
						else return 3;
					},
					"color": "rgba(163,0,255,1)",
					"opacity": 0.6,
					"selected": {
						"opacity": 1
					},
					"highlighted": {
						"opacity": 1
					}
				}	
			}
		},
		
		markup: {
			
			lightwindow: '\
				<div class="wrapper" style="width: <#width#>; height: <#height#>; padding: <#padding#>">\
					<table width="100%" height="100%">\
						<tr>\
							<td colspan="2" height="40" class="center">\
								<div class="head">\
									<div class="title"><h1 id="graph-title"></h1></div>\
								</div>\
							</td>\
						</tr>\
						<tr>\
							<td><div id="network-graph" class="alchemy show-nodes-captions"></td>\
							<td width="200" bgcolor="#f6f6f6" class="top"><div id="network-graph-filter">\
								<fieldset class="row">\
									<legend>Captions</legend>\
									<div><label><input type="radio" name="captions" value="0" />Hide all</label></div>\
									<div><label><input type="radio" name="captions" value="1" />Show all</label></div>\
									<div><label><input type="radio" name="captions" value="2" checked />Show nodes captions</label></div>\
									<div><label><input type="radio" name="captions" value="3" />Show edges captions</label></div>\
								</fieldset>\
								<div class="filters"></div>\
							</div></td>\
						</tr>\
					</table>\
					<a class="closeButton graph" href="javascript:lightwindow.hide()">[X] Close</a>\
				</div>\
			',
			
			radioFilter: '\
				<fieldset class="row">\
					<legend><#title#></legend>\
					<#items#>\
				</fieldset>\
			',
			
			radioItem: '<div><label><input type="radio" name="<#name#>" value="<#value#>" <#checked#> /><#label#></label></div>',
			
			contextPanel: '<div class="context-panel <#cssClasses#>" id="context-menu" style="top: <#y#>px; left: <#x#>px"><#content#></div>',
				
			contextMenu: '\
					<div><a href="javascript:void(0)" onclick="networkGraph.setAsRoot(<#id#>)">Set as Root</a></div>\
					<div><a href="javascript:void(0)" onclick="networkGraph.goToDevice(<#id#>)">Go to device</a></div>\
			',				
			
		},
		
		label: {
			description: "Description:"
			
		}
	},
	
	init: function(c) {
		$.extend(true, this.c, c);
	},
	
	show: function(itemID) {
		
		var self = this;
		
		this.createLayer();
		
		this.initLayerControl();
		
		this.getParams = [];
		
		this.getParams = comParam.add(this.getParams, 'rootId', itemID);
		
		this.getData(this.getParams, function(data){
			self.onResponse(data);
		});
		
		
	},
	
	createLayer: function() {
		
		var markup = string.replacePlaceHolders(this.c.markup.lightwindow, {
			width: ($(window).width() - 30) + 'px',
			height: ($(window).height() - 30) + 'px',
			padding: '5px' 
		});
		lightwindow.options.lightwindowTopDelta = 0;
		lightwindow.show(markup);		
		
	},
	
	initLayerControl: function() {
		
		var self = this;
		
		var isEventSupported = function(eventName) {
			var el = document.createElement('div');
			eventName = 'on' + eventName;
			var isSupported = (eventName in el);
			if (!isSupported) {
				el.setAttribute(eventName, 'return;');
				isSupported = typeof el[eventName] == 'function';
			}
			el = null;
			return isSupported;
		};	
		
		
		$('#network-graph-filter input[name="captions"]').change(function(){
			
			switch (this.value) {
				
				case "0":
					$(self.c.graph.divSelector).removeClass('show-all-captions show-nodes-captions show-edges-captions');
				break;
				
				case "1":
					$(self.c.graph.divSelector).removeClass('show-all-captions show-nodes-captions show-edges-captions').addClass('show-all-captions');
				break;
				
				case "2":
					$(self.c.graph.divSelector).removeClass('show-all-captions show-nodes-captions show-edges-captions').addClass('show-nodes-captions');
				break;
				
				case "3":
					$(self.c.graph.divSelector).removeClass('show-all-captions show-nodes-captions show-edges-captions').addClass('show-edges-captions');
				break;
				
			}
			
		});
		
		$(self.c.graph.divSelector).bind('contextmenu', function(e){
			if (e.target.nodeName == 'circle') {
				e.preventDefault();
				self.showNodeContextMenu(e.pageX, e.pageY, e.target['__data__'].id);
				return false;
			}
			
		});
		$('body').bind('click', function(){
			self.hideContextPanel();
		});
		
		var wheelEvent = isEventSupported('mousewheel') ? 'mousewheel' : 'wheel';
		$(self.c.graph.divSelector).bind(wheelEvent, function(){
			self.hideContextPanel();
		});
		
		
	},

	getData: function(getParams, callback) {
		
		var self = this;
		
		if (this.c.dataSource == null) {
			alert('Error: No Data found.');
			return;
		}

		app.showLoader(0);
		
		$.ajax(this.c.dataSource+'?'+comParam.getRequestParamString(getParams),{
			dataType: 'json'
		})
		.done(function(data, textStatus, jqXHR) {
			callback(data);
			app.removeLoader();
		})
		.fail(function(e) {
			alert('AJAX-Error: ' + self.c.graph.dataSource);
			app.removeLoader();
		});		
		
	},
	
	onResponse: function(data) {
		
		$('#graph-title').html(data.comment);
		
		this.initFilters(data);
		
		this.initComParams(data);
		
		//create graph
		this.c.graph.dataSource = data;
		this.alchemy = new Alchemy(this.c.graph);		
		
	},
	
	initFilters: function(data) {
		
		var self = this,
			markup = this.getFiltersMarkup(data);
		
		$('#network-graph-filter .filters').html('').append(markup);
		
		//events
		//radio filter
		$('#network-graph-filter .filters input[type="radio"]').change(function(){
			
			self.alchemy = null;
			$(self.c.graph.divSelector).html('');
			
			this.getParams = comParam.change(self.getParams, this.name, this.value);
			
			self.getData(self.getParams, function(data){
				self.onResponse(data);
			});			
			
		});
		
	},
	
	getFiltersMarkup: function(data) {
		
		var filterData = data.filter,
			allFilters = '';
		
		for (var filter in filterData) {
			
			if (typeof(filterData[filter].config) == 'undefined') continue;
			if (typeof(filterData[filter].data) == 'undefined') continue;

			switch (filterData[filter].config.type) {
				
				case "radio":
				
					var itemsMarkup = '';
					for (var i=0; i<filterData[filter].data.length; i++) {
						
						var item = filterData[filter].data[i];
						
						var filterItemData = {
							name: filterData[filter].config.name,
							value: item.value,
							checked: ((item.active == true) && (item.value != '')) ? 'checked="checked"' : '',
							label: item.label
							
						};
						
						itemsMarkup += string.replacePlaceHolders(this.c.markup.radioItem, filterItemData);
					}					
					
					
					allFilters += string.replacePlaceHolders(this.c.markup.radioFilter, {
						title: filterData[filter].config.label,
						items: itemsMarkup
					});
				
				break;
			}
			
		}
		
		return allFilters;
	},
	
	initComParams: function(data) {
		var itemID = comParam.get(this.getParams, 'rootId');
		this.getParams = this.getComParams(data);
		this.getParams = comParam.add(this.getParams, 'rootId', itemID);
	},
	
	getComParams: function(data) {
		
		var getParams = [];
		
		//filter
		if (typeof(data.filter) != 'undefined') {
			for (var filter in data.filter) {
				
				switch (data.filter[filter].config.type) {
				
					case "radio":
						for (var i=0; i<data.filter[filter].data.length; i++) {
							
							var item = data.filter[filter].data[i];
							
							if (item.active) {
								comParam.add(getParams, data.filter[filter].config.name, item.value);
							}
						}
					break;
				}				
			}
		}
		
		return getParams;		
		
	},
	
	showNodeContextMenu: function(x,y,nodeId) {
		var content = string.replacePlaceHolders(this.c.markup.contextMenu, {
			id: "'"+nodeId+"'"
		});
		this.showContextPanel(x,y,content,'small');
	},
	
	showContextPanel: function(x,y,content,cssClasses) {
		
		this.hideContextPanel();
		var jPanel = $(string.replacePlaceHolders(this.c.markup.contextPanel, {
			x: x,
			y: y,
			content: content,
			cssClasses: (cssClasses)?cssClasses:''
		}));
		
		$('body').append(jPanel); 
		return jPanel;
	},	
	
	hideContextPanel: function() {
		$('.context-panel').remove();
	},
	
	setAsRoot: function(nodeId) {
		
		var self = this;
		
		this.hideContextPanel();
		
		this.getParams = [];
		this.getParams = comParam.add(this.getParams, 'rootId', nodeId);
		
		this.getData(this.getParams, function(data){
			self.onResponse(data);
		});
	},
	
	goToDevice: function(nodeId) {
		
		var prop = this.alchemy._nodes[nodeId]._properties;
		this.hideContextPanel();
		
		if ((typeof prop.url != 'undefined') && (prop.url != '')) {
			app.showLoader(0);
			location.href = prop.url;
		} else {
			alert("Error: URL is undefined." )
		}
		
	},
	
	showInformationPanel: function(x, y, type, prop) {
		this.hideContextPanel();
		switch (type) {
			case 'node':
			case 'edge':
				if ((typeof prop.description != 'undefined') && (prop.description != ''))
					this.showContextPanel(x,y, '<b>'+this.c.label.description+'</b><br/>'+prop.description);	
			break;
		}
	}
};

//communication parameter
var comParam = { 

	add: function(target, name, value){
		var param = new Array();
		param[name] = value;
		target.push(param);
		return target;
	},
	
	remove: function(target, name, value){
		
		var buffer = new Array();
		
		var isValuesEQ = function(targetValue, value){
			if (typeof(value) == 'undefined') return true;
			if (targetValue == value) return true;
			else return false;
		};
		
		for(var i in target){
			for (var paramName in target[i]) {
				
				if ((paramName == name) && isValuesEQ(target[i][paramName],value)) {
					continue;
				} else {
					var param = new Array();
					param[paramName] = target[i][paramName];
					buffer.push(param);
				}
				
			}
		}
		target = buffer;
		return target;
	},
	
	change: function(target, name, value) {
		
		var found = false;
		
		for(var i in target){
			for (var paramName in target[i]) {
				if (paramName == name) {
					target[i][paramName] = value;
					found = true;
				} 
			}
		}

		if (!found) comParam.add(target, name, value);
		
		return target;
	},
	
	get: function(target, name) {
		
		for(var i in target){
			for (var paramName in target[i]) {
				if (paramName == name) {
					return target[i][paramName];
				} 
			}
		}
		return null;
		
	},
	
	getRequestedState: function(){
		
		var state = new Array;

		var items = this.getUrlParams().split('&');
		if ((items.length == 1) && (items[0] == '')) return state;
		
		for (var i=0; i<items.length; i++) {
			var item = items[i].split('=');
			
			var param = new Array();
			param[item[0]] = decodeURIComponent(item[1].replace(/\+/g, '%20'));
			
			state.push(param);
		}
		
		return state;
	},
	
	getUrlParams: function() {
		
		var hash = window.location.hash;
		var params = window.location.search;
		
		if (typeof window.history.pushState == 'function') {
			if (jQuery.trim(params) != '') {
				return params.substring(1);
			}
		} else {
			if (jQuery.trim(hash) != '') {
				return hash.substring(1);
			} else {
				if (jQuery.trim(params) != '') {
					return params.substring(1);
				}				
			}
		}
		
		return '';
	
	},
	
	refreshBrowserGetParams: function(getParams){
		
		var searchString = comParam.getRequestParamString(getParams);
		var hash = window.location.hash;
		
		if (typeof window.history.pushState == 'function') {
			history.replaceState({}, 'Data Search', '?'+searchString);
			if (hash != '') window.location.hash = hash;
		} else {
			//as local anchor
			window.location.hash = '#'+searchString;
		}
		
	},
	
	getRequestParamString: function(source){

		var searchString  = '';
		var separator = '';
		
		for (var i in source) {
			
			for (var name in source[i]) {
				
				searchString += separator + name + '=' + encodeURIComponent(source[i][name]);
				separator = '&';
			}
		}
	
		return searchString;
	},
	
	getGetParamByName: function(name){
	
		var params = window.location.search;
		if( params != "") {
			params = params.substr(1,params.length-1);
			var arr_params = params.split('&');
			for (var i=0; i<arr_params.length; i++){
				var param = arr_params[i].split('=');
				if (param[0].toLowerCase() == name.toLowerCase()) return decodeURIComponent(param[1].replace(/\+/g, '%20'));
			}
			return null;
		} else return null;
	},

	getPathParamByNumber: function(num) {
		
		var foo = window.location.pathname.split('/');
		if (typeof(foo[num]) != 'undefined') return foo[num];
		return null;
		
	}
};