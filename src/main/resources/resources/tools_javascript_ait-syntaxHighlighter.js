var syntaxHighlighter = {
	
	jSelectedLine: null,
	selectedLine: null,
	dataUrl: null,
	dataId: null,
	c: {
		containerSelector: '.envtreeScroll'
	},

	init: function(){
		var browser = new String(navigator.appVersion);
		if ((jQuery('pre').length == 0) || ((browser.search("MSIE") != -1) && (browser.substr(browser.search("MSIE")+5,1) < 8))) return;

		SyntaxHighlighter.highlight();

		this.initOutput();
		this.initLines();
		
	},
	
	initGlobal: function(){
		
		var self = this;
		
		var browser = new String(navigator.appVersion);
		if ((jQuery('pre').length == 0) || ((browser.search("MSIE") != -1) && (browser.substr(browser.search("MSIE")+5,1) < 8))) return;
		
		this.init();
		
		//GET-Parameters lesen
		this.selectedLine  = this.getGetParameter('sh_selectedline');
		this.selectedLine = (this.selectedLine == '') ? null : this.selectedLine;

		this.dataUrl = this.getGetParameter('sh_dataurl');
		this.dataUrl = (this.dataUrl == '') ? null : this.dataUrl;
		
		this.dataId = this.getGetParameter('sh_dataid');
		this.dataId = (this.dataId == '') ? null : this.dataId;

		this.dataType = this.getGetParameter('sh_datatype');
		this.dataType = (this.dataType == '') ? 'xml' : this.dataType;

		//goToLine
		if ((this.selectedLine != null) && (this.dataUrl == null) && (this.dataId == null)) this.goToLine(this.selectedLine);
		
		//Lightwindow
		if ((this.dataUrl != null) && (this.dataId != null)) 
			window.setTimeout(function(){
				app.showExternalContent({url:self.dataUrl, contentId: self.dataId, type: self.dataType, callback: function(){self.goToLine(self.selectedLine);}});
			}, 10);
		
	},
	
	initOutput: function(){
		var jOutputItems = jQuery(this.c.containerSelector+'[rel!="initialized"]');
		for(var i=0; i<jOutputItems.length; i++) {
			jQuery(jOutputItems.get(i)).attr('rel','initialized');
			jQuery(jOutputItems.get(i)).wrap('<div class="envtree_wrapper"></div>');
			jQuery(jOutputItems.get(i)).parents('.envtree_wrapper').prepend('<div class="selected-line"></div>');
		}
	},
	
	initLines: function(){
		var self = this;
		jQuery('.syntaxhighlighter[rel!="initialized"]').each(function(){
			var parentId = jQuery(this).parents(self.c.containerSelector).attr('id');
			jQuery(this).find('.code .line').each(function(){
			
				var classes = jQuery(this).attr('class');
				var posNumberStart = classes.indexOf('number');
				var lineNumber = classes.substring(posNumberStart, classes.length);
				var posNumberEnd = lineNumber.indexOf(' ');
				lineNumber = lineNumber.substring(0,posNumberEnd);
				
				jQuery(this).attr('id',parentId+'_'+lineNumber);
				
				self.initLineEvents(this);
			});
			jQuery('.syntaxhighlighter').attr('rel', 'initialized');
		});
	},
	
	initLineEvents: function(obj){
		
		var self = this;
		
		jQuery(obj).on('mouseover', function(){
			jQuery(obj).addClass('active');
		});
		
		jQuery(obj).on('mouseout', function(){
			jQuery(obj).removeClass('active');
		});									
	
		jQuery(obj).on('click', function(){
			
			if (self.jSelectedLine != null) self.jSelectedLine.removeClass('selected');
			else jQuery(self.c.containerSelector).find('.line').removeClass('selected');
			
			self.jSelectedLine = jQuery(obj);
			
			self.jSelectedLine.addClass('selected');
			var dataAttr = self.jSelectedLine.parents(self.c.containerSelector).attr('data-url');
			var dataId = self.jSelectedLine.parents(self.c.containerSelector).attr('data-id');
			var dataType = self.jSelectedLine.parents(self.c.containerSelector).attr('data-type');
			
			var lineURL = self.addGetParametersInCurrentUrl(new Array(
				{name: 'sh_selectedline', value: obj.id},
				{name: 'sh_dataurl', value: dataAttr?dataAttr:''},
				{name: 'sh_dataid', value: dataId?dataId:''},
				{name: 'sh_datatype', value: dataType?dataType:''}
			));
			
			jQuery('.selected-line').html('');
			self.jSelectedLine.parents('.envtree_wrapper').find('.selected-line').html(lineURL);
			
		});									
	
	},
	
	addGetParametersInCurrentUrl: function(newParameters){

		var arrayParametersName = new Array();
		for(var i in newParameters) {
			arrayParametersName.push(newParameters[i].name);
		}
	
		var currentLocation = window.location.href;
		
		var address = currentLocation;
		if (currentLocation.indexOf('#') != -1) address = currentLocation.substring(0,currentLocation.indexOf('#'));
		if (window.location.search != '') address = currentLocation.substring(0,currentLocation.indexOf(window.location.search));
		
		var parameters = window.location.search;
		
		if ( parameters != '') { //es gibt schon GET-Parameter
			parameters = parameters.substr(1,parameters.length-1);
			
			var arr_params = parameters.split('&');
			var paramName = '';
			
			parameters = '';
			for (var i=0; i<arr_params.length; i++){
				paramName = arr_params[i].substring(0,arr_params[i].indexOf('='));
				if (jQuery.inArray(paramName, arrayParametersName) == -1) parameters += '&'+arr_params[i];
			}
		} 
		
		//neue Parameter einfuegen
		for(var i in newParameters) {
			parameters += '&'+newParameters[i].name+'='+newParameters[i].value;
		}
		
		//&-, ?+
		parameters = '?'+parameters.substr(1,parameters.length-1);
		
		 
		return  address+parameters+window.location.hash;
	},
	
	getGetParameter: function(name){
		var params = window.location.search;
		if( params != "") {
			params = params.substr(1,params.length-1);
			var arr_params = params.split('&');
			for (var i=0; i<arr_params.length; i++){
				var param = arr_params[i].split('=');
				if (param[0].toLowerCase() == name.toLowerCase()) return param[1];
			}
			return null;
		} else return null;
	},
	
	goToLine: function(id) {
		window.location.hash = '#'+id;
		jQuery('#'+id).addClass('selected');
		
		if ((this.dataUrl != null) && (this.dataId != null) && (!$.browser.msie)) window.location.hash = '#';
	},
	
	getCurrentYPos: function() {
		if (document.body && document.body.scrollTop)
		return document.body.scrollTop;
		if (document.documentElement && document.documentElement.scrollTop)
		return document.documentElement.scrollTop;
		if (window.pageYOffset)
		return window.pageYOffset;
		return 0;
	}
	
};
jQuery(document).ready(function(){
	syntaxHighlighter.initGlobal();
});

