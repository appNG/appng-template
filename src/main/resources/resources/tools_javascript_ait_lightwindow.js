var lightwindow = {
    
    options: {
		overlayId: 'overlay',
		lightwindowId: 'lightwindow',
		lightwindowTopDelta: 70,
		overlayOnClick: null,
		onClose: null,
		defaultTheme: 'default',
		fadeEffect: true,
		onPressEsc: null
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
		
        if (this.options.overlayOnClick != null) this.jOverlay.bind('click', this.options.overlayOnClick);

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
		
		jQuery(window).bind('resize', function(){
			self.onResize();
		});		
		
		//Keyup
		jQuery(window).keyup(function(e){
			if ((typeof(self.options.onPressEsc) == 'function') && (e.which == 27)) self.options.onPressEsc.apply();
		});		
    },
	
	onResize: function(){
		
		var self = this;
		
		var isPageSizeChanged = function() {
			return (!((self.currentPageSize[0] == $(document).width()) && (self.currentPageSize[1] ==  $(document).height()) && (self.currentPageSize[2] == $(window).width()) && (self.currentPageSize[3] ==  $(window).height())));
		};
		
		if (!isPageSizeChanged()) return;
		
		if (this.jOverlay.is(':visible') && this.jLightwindow.is(':visible')) self.setElementsPosition();
		
	},
    
    show: function(content, clone){
        
		clone = (typeof(clone) != 'undefined') ? clone : true;
		
		var self = this;
		
		if ((this.jOverlay == null) || (this.jLightwindow == null)) {
			this.init();
		}
		
		this.appendContent(this.jLightwindow.get(0), content, clone);
		this.setElementsPosition();
		
		//Select ausblenden - IE Bug
		if (navigator.userAgent.indexOf('MSIE')!=-1) {
 	 		jQuery('select:visible').hide().addClass('hidden');
 	 		this.jLightwindow.find('select').removeClass('hidden').show();
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
        
		this.jLightwindow.hide();
		this.jOverlay.hide();
        
      	var arrayPageSize = this.getPageSize();
      	var arrayPageScroll = this.getPageScroll();

        //Overlay
		var overlayWidth = (arrayPageSize[0] > arrayPageSize[2]) ? arrayPageSize[0] : arrayPageSize[2];
		var overlayHeight = (arrayPageSize[1] > arrayPageSize[3]) ? arrayPageSize[1] : arrayPageSize[3];
		overlayHeight = (overlayHeight < this.jLightwindow.height()) ? (this.jLightwindow.height() + 10) : overlayHeight;
		
		if (this.options.fadeEffect) {
			this.jOverlay.width(overlayWidth + 'px').height(overlayHeight + 'px').fadeIn('fast');
		} else {
			this.jOverlay.width(overlayWidth + 'px').height(overlayHeight + 'px').show();
		}
        
        //Lightwindow
		var objLightwindow = this.jLightwindow.get(0);
		this.jLightwindow.css({top: '-1000px'}).show();
        
        var lightwindowTop = arrayPageScroll[1] + ((arrayPageSize[3] - this.options.lightwindowTopDelta - objLightwindow.offsetHeight) / 2);
        lightwindowTop = (lightwindowTop < 0) ? 0 : lightwindowTop;
        var lightwindowLeft = ((arrayPageSize[0] - objLightwindow.offsetWidth) / 2);
        
		this.jLightwindow.hide().css({
			'top': (lightwindowTop < 0) ? "0px" : lightwindowTop + "px",
			'left': (lightwindowLeft < 0) ? "0px" : lightwindowLeft + "px"
		});
		
		if (this.options.fadeEffect) {
			this.jLightwindow.fadeIn('fast', function(){
				$(this).triggerHandler('onVisible');
			});		
		} else {
			this.jLightwindow.show();
			this.jLightwindow.triggerHandler('onVisible');
		}
		
		this.currentPageSize = this.getPageSize();
		
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
			this.jOverlay.unbind('click');
			this.jOverlay.bind('click', this.options.overlayOnClick);
		}
	},
    
    getPageScroll: function(){
    
    	var yScroll;
    
    	if (self.pageYOffset) {
    		yScroll = self.pageYOffset;
    	} else if (document.documentElement && document.documentElement.scrollTop){	 // Explorer 6 Strict
    		yScroll = document.documentElement.scrollTop;
    	} else if (document.body) {// all other Explorers
    		yScroll = document.body.scrollTop;
    	}
    
    	var arrayPageScroll = new Array('',yScroll) 
    	return arrayPageScroll;
    },
    
    
    getPageSize: function(){
    	return [$(document).width(), $(document).height(),$(window).width(), $(window).height()];
    },
	
	setTheme: function(theme) {
		
		theme = (theme == 'default') ? this.options.defaultTheme : theme;
		
		this.jOverlay.removeClass(this.currentTheme).addClass(theme);
		this.jLightwindow.removeClass(this.currentTheme).addClass(theme);
		
		this.currentTheme = theme;
		
	}
    
};