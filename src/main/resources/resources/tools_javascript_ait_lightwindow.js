var lightwindow = {

	options: {
		overlayId: 'overlay',
		lightwindowId: 'lightwindow',
		lightwindowTopDelta: 70,
		overlayOnClick: null,
		onClose: null,
		defaultTheme: 'default',
		fadeEffect: true,
		onPressEsc: null,
		fixed: false
	},

	jOverlay: null,
	jLightwindow: null,
	objOverlay: null,
	objLightwindow: null,
	currentContent: null,
	currentTheme: null,
	currentPageSize: new Array(),

	init: function(options){

		var self = this;

		this.options = jQuery.extend(this.options, options);

		this.currentTheme = (this.currentTheme == null) ?  this.options.defaultTheme : this.currentTheme ;

		this.jOverlay = jQuery('#'+this.options.overlayId);
		this.jLightwindow = jQuery('#'+this.options.lightwindowId);	

		if (this.jOverlay.length == 0) {
			jQuery('body').append('<div id="'+this.options.overlayId+'"></div>');
			this.jOverlay = jQuery('#'+this.options.overlayId);
		}
		else this.jOverlay.appendTo('body');

		this.objOverlay = this.jOverlay.get(0);
		this.objLightwindow = this.jLightwindow.get(0);			

		if (this.jLightwindow.length == 0) {
			jQuery('body').append('<div id="'+this.options.lightwindowId+'" class="not_printable"></div>');
			this.jLightwindow = jQuery('#'+this.options.lightwindowId);
		}
		else this.jLightwindow.appendTo('body');

		//theme
		this.jOverlay.addClass(this.currentTheme);
		this.jLightwindow.addClass(this.currentTheme);

		//Events
		this.currentPageSize = this.getPageSize();

		jQuery(window).on('resize', function(){
			self.onResize();
		});		

		//Keyup
		jQuery(window).keyup(function(e){
			if ((typeof(self.options.onPressEsc) == 'function') && (e.which == 27)) self.options.onPressEsc.apply();
		});		
	},

	onResize: function(){
		
		var self = this;
		
		if (!this.isPageSizeChanged()) return;
		
		if ((this.jOverlay != null) && this.jOverlay.is(':visible') && (this.jLightwindow != null) && this.jLightwindow.is(':visible')) self.setElementsPosition();
		
	},

	isPageSizeChanged: function() {
		return (!((this.currentPageSize[0] == $(document).width()) && (this.currentPageSize[1] ==  $(document).height()) && (this.currentPageSize[2] == $(window).width()) && (this.currentPageSize[3] ==  $(window).height())));
	},
	
	show: function(content, clone){
		
		clone = (typeof(clone) != 'undefined') ? clone : true;

		var self = this;
		
		if ((this.jOverlay == null) || (this.jLightwindow == null)) {
			this.init();
		}
		
		if (this.options.overlayOnClick != null) this.jOverlay.one('click', this.options.overlayOnClick);
		
		this.appendContent(this.jLightwindow.get(0), content, clone);
		this.setElementsPosition();
		
		//Select ausblenden - IE Bug
		if ($.browser.msie) {
			jQuery('select:visible').hide().addClass('hidden');
			this.jLightwindow.removeClass('hidden').show();
		}
		
	},

	replaceContent: function(selector, content) {
		
		var self = this; 
		var jContentArea = this.jLightwindow.find(selector);
		
		if (jContentArea.length == 0) return;
		
		jContentArea.html('');
		
		this.appendContent(jContentArea.get(0), content);

		this.jLightwindow.triggerHandler('onVisible');		
		
	},

	appendContent: function(target, content, clone) {

		clone = (typeof(clone) != 'undefined') ? clone : true;

		var self = this;
		var idRegExp = /^(\w+[-]*)+$/;
		
		this.currentContent = content;
		
		if (typeof(content) == 'object') { //DOM-Object; jQuery-Object
			if (clone) {
				jQuery(content).clone(true).appendTo(target);
				this.jLightwindow.attr('data-cloned','true');
			}
			else {
				jQuery(content).appendTo(target);
				this.jLightwindow.attr('data-cloned','false');
			}
		} else if ((idRegExp.test(content)) && (jQuery('#'+content).length != 0)) { //ID
			if (clone) {
				jQuery('#'+content).clone(true).appendTo(target);
				this.jLightwindow.attr('data-cloned','true');
			}	
			else {
				jQuery('#'+content).appendTo(target);
				this.jLightwindow.attr('data-cloned','false');
			}
		} else if (content) { //HTML
			if (content.indexOf("<") != 0) content = "<div>"+content+"</div>";
			jQuery(content).appendTo(target); 
		} 		

	},

	setElementsPosition: function(){

		this.jOverlay.hide();
		this.jLightwindow.hide();
		
		this.jLightwindow.css({top: '0px', left: '0px'});

		//Overlay
		this.setOverlayPosition();

		//Lightwindow
		this.setLightwindowPosition();
		
		if (this.isPageSizeChanged()) this.setOverlayPosition();		
		
		this.currentPageSize = this.getPageSize();
		
	},
	
	setOverlayPosition: function() {
		
		var arrayPageSize = this.getPageSize();
		
		var overlayWidth = (arrayPageSize[0] > arrayPageSize[2]) ? arrayPageSize[0] : arrayPageSize[2];
		var overlayHeight = (arrayPageSize[1] > arrayPageSize[3]) ? arrayPageSize[1] : arrayPageSize[3];
		overlayHeight = (overlayHeight < this.jLightwindow.height()) ? (this.jLightwindow.height() + 10) : overlayHeight;

		if (this.options.fadeEffect) {
			this.jOverlay.width(overlayWidth + 'px').height(overlayHeight + 'px').fadeIn('fast');
		} else {
			this.jOverlay.width(overlayWidth + 'px').height(overlayHeight + 'px').show();
		}		
	},
	
	setLightwindowPosition: function() {
		
		var arrayPageSize = this.getPageSize();
		var arrayPageScroll = this.getPageScroll();		
		
		var objLightwindow = this.jLightwindow.get(0);

		this.jLightwindow.css({left: '-100000px'}).show();

		var lightwindowHeight = jQuery(objLightwindow).outerHeight();
		var lightwindowWidth = jQuery(objLightwindow).outerWidth();

		var lightwindowTop =  ((arrayPageSize[3] - this.options.lightwindowTopDelta - lightwindowHeight) / 2);
		lightwindowTop = (lightwindowTop < 0) ? arrayPageScroll[1] : arrayPageScroll[1]+lightwindowTop;

		var lightwindowTopByFixed = (arrayPageSize[3] - this.options.lightwindowTopDelta - lightwindowHeight)/2;

		var lightwindowLeft = ((arrayPageSize[0] - lightwindowWidth) / 2);

		if (!this.options.fixed) {
			this.jLightwindow.hide().css({
				'top': (lightwindowTop < 0) ? "0px" : lightwindowTop + "px",
				'left': (lightwindowLeft < 0) ? "0px" : lightwindowLeft + "px"
			});
		} else {
			this.jLightwindow.hide().css({
				'position': (lightwindowTopByFixed < 0) ? 'absolute' : 'fixed',
				'top': (lightwindowTopByFixed < 0) ? lightwindowTop+"px" : lightwindowTopByFixed + "px",
				'left': (lightwindowLeft < 0) ? "0px" : lightwindowLeft + "px"
			});
		}		

		if (this.options.fadeEffect) {
			this.jLightwindow.fadeIn('fast', function(){
				$(this).triggerHandler('onVisible');
			});		
		} else {
			this.jLightwindow.show();
			this.jLightwindow.triggerHandler('onVisible');
		}		
		
	},
	
	hide: function(){

		this.jLightwindow.hide();
		this.jOverlay.hide();

		if (this.jLightwindow.attr('data-cloned') == 'false') $('body').append(this.jLightwindow.find('>*'));
		this.jLightwindow.removeAttr('data-cloned');
		
		this.clear();
	   
		//Select einblenden - IE Bug
		jQuery('select.hidden').show().removeClass('hidden');
		
		if (typeof(this.options.onClose) == 'function') this.options.onClose.apply();
		
	},

	clear: function(){
		this.jLightwindow.html('');
		this.jLightwindow.attr('style','');
		if (this.options.overlayOnClick != null) {
			this.jOverlay.off('click');
		}
		this.currentPageSize = this.getPageSize();
	},

	getPageScroll: function(){
		return ['', (jQuery('html').scrollTop() || jQuery('body').scrollTop())];
	},


	getPageSize: function(){
		return [$(document).width(), $(document).height(),$(window).width(), $(window).height()];
	},

	setTheme: function(theme) {
		
		if ((this.jOverlay == null) || (this.jLightwindow == null)) this.init();
		
		theme = (theme == 'default') ? this.options.defaultTheme : theme;
		
		this.jOverlay.removeClass(this.currentTheme).addClass(theme);
		this.jLightwindow.removeClass(this.currentTheme).addClass(theme);
		
		this.currentTheme = theme;

	}
    
};