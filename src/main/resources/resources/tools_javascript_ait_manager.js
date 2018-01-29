/*  appNG JS */
var app = {
    
	markup: {
		dialogWindow:'\
			<div class="wrapper"><div style="width: <#width#>" class="contentrow">\
				<div class="content">\
					<div class="hr"></div>\
					<p class="dialog-question"><#label#></p>\
					<div class="buttons_panel">\
						<div class="center"><#buttons#></div>\
						<p class="clr">&nbsp;</p>\
					</div>\
					<div class="hr"></div>\
				</div>\
			</div></div>',
			
		dialogWindowButtons: '<a href="javascript: void(0)" class="btn_delete" onclick="lightwindow.hide();"><#buttonAbort#></a><a href="javascript: location.replace(\'<#url#>\');" class="btn_undo"><#buttonOk#></a>',
		
		dialogWindowButtonsWithLoader: '<a href="javascript: void(0)" class="btn_delete" onclick="lightwindow.hide();"><#buttonAbort#></a><a href="javascript: app.showLoader(); location.replace(\'<#url#>\');" class="btn_undo"><#buttonOk#></a>',
		
		ajaxLoader: '<div class="communicationLoader" id="communicationLoader">\
				<div>\
					<div class="wrapper">\
						<div class="contentrow">\
							<div class="content">\
								<div class="hr"></div>\
								<p class="dialog-question">Operation is running. Please wait ...</p>\
								<div class="buttons_panel">\
									<div class="center"><div title="loading..." class="ajax-loader"></div></div>\
									<p class="clr">&nbsp;</p>\
								</div>\
								<div class="hr"></div>\
							</div>\
						</div>\
					</div>\
				</div>\
			</div>\
		',
		
		externalContentWindow: '\
			<div class="contentrow" style="width: <#width#>">\
				<div class="content">\
					<div class="hr"></div>\
					<p class="dialog-question">Content of \'<#contentId#>\'.\'<#type#>\'</p>\
					<div class="buttons_panel">\
						<div class="center">\
							<#buttons#>\
						</div><br/>\
						<div class="envtreeScroll" style="height: <#height#>; width: 100%" id="xml_<#contentId#>" data-url="<#url#>" data-id="<#contentId#>" data-type="<#type#>"><pre class="brush: <#type#>; toolbar: false;" rel="externalContent"></pre></div>\
						<p class="clr">&nbsp;</p>\
					</div>\
					<div class="hr"></div>\
				</div>\
			</div>'
	},
	
    label: {
        inProcess: 'The process is carried out. Please wait ...',
		isRunning: 'Operation is running. Please wait ...',
        areYouSure: 'Are you sure?',
        buttonYes: 'Yes',
        buttonNo: 'No',
        buttonAbort: 'Cancel',
        buttonRejectUpdates: 'Discard changes',
        uploadedItem: 'Media element uploaded',
        uploadedItems: 'Media elements uploaded',
        buttonClose: 'Close'
    },
    
	richTextEditors: new Array(),
	
    mstConfigDefault: {
         onOrderChange: function(table, row) {
            app.updateTableDate(table, row);
         },
         onMouseOverClass: 'tDnD_whileDrag' 
    },

    init: function(){
        
        this.initForms();
        
		this.initTables();
        
        this.initFormUndoButtons();
        
        this.initLoader();
		
		this.initMultiSelect();
		
		if (typeof autosize != 'undefined') autosize($('.autosize'));
		
		this.initLightwindowContents();
		
    },
    
    initButton: function(id, imageOver){
        if (jQuery('#'+id).get(0)) {
            var imageNormal = jQuery('#'+id).get(0).src;
            jQuery('#'+id).on('mouseover', function(){ jQuery('#'+id).get(0).src = imageOver });
            jQuery('#'+id).on('mouseout',  function(){ jQuery('#'+id).get(0).src = imageNormal });
        }
    },
    
    initDisableButton: function(id,divId){
        if (jQuery('#'+id).get(0)) {
            jQuery('#'+id).on('click', function(){ 
            	app.toggleDisableButton(id,divId);
            });
            app.toggleDisableButton(id,divId);
        }
    },
	
    toggleDisableButton: function(id,divId){
	    if (jQuery('#'+id).attr('checked') == true) {
	        jQuery('#'+ divId + ' label').each(function(){ jQuery(this).removeClass('disabled'); });
	        jQuery('#'+ divId + ' input').each(function(){
	            jQuery(this).removeAttr('disabled');
	            jQuery(this).removeAttr('readonly');
	        });
	    }
	    else {
	        jQuery('#'+ divId + ' label').each(function(){ jQuery(this).addClass('disabled'); });
	        jQuery('#'+ divId + ' input').each(function(){
	            jQuery(this).attr({disabled:'disabled'});
	            jQuery(this).attr({readonly:'readonly'});
	        });
	        jQuery('label[for='+id+']').removeClass('disabled');
	        jQuery('#'+id).removeAttr('disabled');
	        jQuery('#'+id).removeAttr('readonly');
	    }
    },
	
    updateTableDate: function(table, row){
    	var hitstart = jQuery('#hitstart').val();
		hitstart = hitstart ? parseInt(hitstart) : 0;
        jQuery('tbody tr', jQuery(table)).each( function(index){ 
            jQuery(this).attr('rel', index);
            jQuery('td span.index', this).html(index + 1 + hitstart);
            jQuery('.order', this).val(index + 1 + hitstart);
        });
    },
    
    initForms: function(){
        jQuery('form').on('submit', function(){
            if (!jQuery(this).hasClass('without-submit-control')) return false;
        });
        jQuery('form').on('reset', function(){
            if (!jQuery(this).hasClass('without-submit-control')) return false;
        });
        if (typeof(formsArr) == 'object'){
            for (var i=0; i < formsArr.length; i++) {
                // hide form buttons if all elements are disabled
     			if(this.areAllElementsDisabled(formsArr[i].obj.elements)) {
     			     jQuery(formsArr[i].obj).find('div.buttons_panel').hide();
     			}
            }
        }
    },    
    areAllElementsDisabled: function(elements){
		for (var i=0; i < elements.length; i++) {
		  switch (elements[i].tagName.toLowerCase()) {
			case 'input':
				switch (elements[i].type.toLowerCase()) {
         			case 'text':         				
         			case 'password':         				
         			case 'radio':
         			case 'checkbox':
         			case 'file':
         			case 'hidden':
         			    if ((typeof(elements[i].disabled) == 'undefined') || ((typeof(elements[i].disabled) != 'undefined') && (elements[i].disabled == false))) return false;
         			break;
         		}
			break;
			case 'select':
			case 'textarea':
                if ((typeof(elements[i].disabled) == 'undefined') || ((typeof(elements[i].disabled) != 'undefined') && (elements[i].disabled == false))) return false;
    		break;
		  }	
		}
		return true;
	},
    
    submitForm: function(formName){
		
        if (formName) {
		
			var jForm = jQuery(document.forms[formName]);
			if ((typeof(jForm.attr('data-submitted')) != 'undefined') && (jForm.attr('data-submitted') == 'true')) return false;
			jForm.attr('data-submitted','true');
			
			//save data from RichText Edirors
			if (typeof(jQuery().tinymce()) != 'undefined') {
				for(var i=0;i<this.richTextEditors.length;i++) {
					var elementContent = jQuery(this.richTextEditors[i]).tinymce().save();
					jQuery(this.richTextEditors[i]).val(elementContent);
				}
			}			
			
			if ( typeof(document.forms[formName].onsubmit) == 'function'){
				if  (document.forms[formName].onsubmit.call()) document.forms[formName].submit();
				else jForm.attr('data-submitted','false');
			} else {
				jQuery('form').off('submit');
				app.showLoader();
				document.forms[formName].submit();
			}
			
        }
        return false;		
		
    },
    
    resetForm: function(formName){
        if (formName) {
            jQuery('form').off('reset');
            document.forms[formName].reset();
        }
        return false;
    },
    
    initFormUndoButtons: function(){
        jQuery('a.btn_undo').attr('href', 'javascript: void(0)');
    },
    
    initEventmessage: function(id){
        if (jQuery('#'+id).length>0) {
			jQuery('#'+id).hide().fadeIn(500, function(){
				if (jQuery(this).hasClass('fade-ok') || jQuery(this).hasClass('ok')) { 
					var obj = this;
					setTimeout(function(){jQuery(obj).fadeOut("slow");}, 4000);
				}
			});
        }
    },
    
	addTimeLabelInUrl: function(url){
	
        var currentDate = new Date();
        var timeLabel = currentDate.getFullYear() + '' + (currentDate.getMonth() + 1) + currentDate.getDate() + currentDate.getHours() + currentDate.getMinutes() + currentDate.getSeconds() + currentDate.getMilliseconds() ;
        var items = url.split('#');
        if (items[0].indexOf('?') != -1) items[0] = items[0] + '&' + 'tl=' + timeLabel; else items[0] = items[0] + '?' + 'tl=' + timeLabel;
        if (items[1] != null) url = items[0] + '#' +items[1]; else url = items[0];	
		
		return url;
	},
	
	getDialogWindowMarkup: function(label, buttons, width) {

        return string.replacePlaceHolders(this.markup.dialogWindow, {
			width: width,
			label: label,
			buttons: buttons
		});
	
	},
	
    showUndoDialog: function(url){
        
		url = this.addTimeLabelInUrl(url);
		
		var width = '445px';
		
		var buttons = string.replacePlaceHolders(this.markup.dialogWindowButtons, {
			buttonAbort: this.label.buttonAbort,
			buttonOk: this.label.buttonRejectUpdates,
			url: url
		});
		
		var html = this.getDialogWindowMarkup(this.label.areYouSure, buttons, width);
		
        lightwindow.show(html);
    
    },
    
    showAbortDialog: function(url){
        
		url = this.addTimeLabelInUrl(url);
		
		var width = '445px';
		
		var buttons = string.replacePlaceHolders(this.markup.dialogWindowButtons, {
			buttonAbort: this.label.buttonNo,
			buttonOk: this.label.buttonYes,
			url: url
		});
		
		var html = this.getDialogWindowMarkup(this.label.areYouSure, buttons, width);
		
        lightwindow.show(html);		
    
    },
    
    showDialog: function(url,dialogMessage){
		
		url = this.addTimeLabelInUrl(url);

		var width = '445px';
		var buttons = string.replacePlaceHolders(this.markup.dialogWindowButtonsWithLoader, {
			buttonAbort: this.label.buttonNo,
			buttonOk: this.label.buttonYes,
			url: url
		});
		
		var html = this.getDialogWindowMarkup(dialogMessage, buttons, width);

        lightwindow.show(html);
    
    },
    
    getAnchorFromURL: function(){
        var value = window.location.hash;
        if ((value.indexOf('#') != -1) && (value.length > 1)) value = value.substring(1, value.length);
        else value = '';
        return value;
    },
	
    submitFormByFieldValue: function(objSubmitField, selectorField){
        var jParent = jQuery(objSubmitField).parent('form');
        var fieldValue = jParent.find(selectorField).val();
        var pattern = /^\w+$/;
        if (pattern.test(fieldValue)) {
            location.href = jParent.attr('action') + '/' + fieldValue;
            return false;
        } else return false;
    },
    
    setLabels: function(labels){
        this.labels = jQuery.extend(this.label,labels);
    },
    
    setCheckboxesRelation: function(masterItemSelector, slaveItemSelector, slaveLabelSelector){
        
        //init
        toggleState = function(){
            if (jQuery(masterItemSelector).get(0).checked) {
                jQuery(slaveItemSelector).removeAttr('disabled');
                jQuery(slaveLabelSelector).removeClass('disabled');
            } else {
                jQuery(slaveItemSelector).attr('disabled','disabled');
                jQuery(slaveItemSelector).get(0).checked = false;
                jQuery(slaveLabelSelector).addClass('disabled');
            }
            
        }
        
        toggleState();
        
        //Event
        jQuery(masterItemSelector).on('click',toggleState);
    },
    
    initLoader: function(){

		var self = this;
		
        jQuery('a').each(function(){
		
		
            if (!jQuery(this).attr('href')) return;
            if ((jQuery(this).attr('href').indexOf('javascript') != -1) || (jQuery(this).attr('href').indexOf('#') == 0) || (jQuery(this).attr('href').indexOf('mailto') == 0) || ((jQuery(this).attr('target') != null) && (jQuery(this).attr('target').indexOf('_blank') == 0))) return;

			//a-Tag - href-Normalisierung
			var aHref = jQuery(this).attr('href');

			var urlPort = (window.location.port != '') ? ':' + window.location.port : '' ;
			if ((aHref.slice(0,7) != 'http://') || (aHref.slice(0,8) != 'https://')) {
				if (aHref.slice(0,1) == '/') {
					aHref = window.location.protocol+'//'+window.location.hostname+urlPort+aHref; 

				} else {
				
					var pathNameArray = window.location.pathname.split('/');
					var pathName = '';
					
					for(var i=0; i<(pathNameArray.length-1); i++){
						if (pathNameArray[i] != '') pathName += '/'+pathNameArray[i];
					}
					aHref = window.location.protocol+'//'+window.location.hostname+urlPort+pathName+'/'+aHref; 
				}
			}
			
			var temp = aHref.split('#');
			aHref = temp[0];
			var aHrefAnchor = (temp[1] != 'undefined') ? temp[1] : null ;
			
			temp = window.location.href.split('#');
			var locationHref = temp[0];
		
			
			var changeTab = false; var tabName = '';

			if ((aHref == locationHref) && (aHrefAnchor != null)) {
				changeTab = true;
				tabName = aHrefAnchor;

			}
            
            jQuery(this).on('click', function(){
				if (changeTab) tabBox.activateTabByName(tabName);
				else self.showLoader();
            });
        
        });
    },
    
    showLoader: function(interval){
        
		var self = this;
		interval = typeof(interval) == 'undefined' ? 1000 : interval;
		
		var showLoader = function(){
			var loader = $('#communicationLoader');
			
			loader = (loader.length==0) ? $(self.markup.ajaxLoader).appendTo('body') : loader;
			loader.height($(document).height());
			
			loader.show();
			
			loader.find('>div').css('padding-top', ($(window).height()/2-150) + 'px');
		}
		
		if (interval > 0) {
			window.setTimeout(function(){
				showLoader();
			}, interval);
		} else showLoader();
		
    },
    
	removeLoader: function() {
		$('#communicationLoader').hide();
	},
	
    copyToClipboard: function(txt) {
  
		if (!txt) return;
		
		if (window.clipboardData) {

			window.clipboardData.clearData();
			window.clipboardData.setData("Text", txt);

		} else if (window.netscape) {

			try {
				netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			} catch (e) {
				alert("In order to use this function, please enable 'signed.applets.codebase_principal_support' in about:config'.");
				return false;
			}

			var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);  
			if (!str) return false; 
			str.data = txt;

			var trans = Components.classes["@mozilla.org/widget/transferable;1"].createInstance(Components.interfaces.nsITransferable);
			if (!trans)	return;

			trans.addDataFlavor('text/unicode');
			trans.setTransferData("text/unicode", str, txt.length * 2);

			var clipid = Components.interfaces.nsIClipboard;
			var clip =	Components.classes["@mozilla.org/widget/clipboard;1"].getService(clipid); 
			if (!clip) return false;

			clip.setData(trans,null,clipid.kGlobalClipboard);

		} else if (navigator.appVersion.indexOf('Chrome') != -1) {
			alert('The functionality is not supported by chrome.');
		}

	},
	
	showExternalContent: function(parameters){ //[url, contentId, type, callback]
		
		var p = {
			url: null,
			contentId: null,
			type: 'xml',
			callback: null
		};
		p = jQuery.extend(p, parameters);
		
		var self = this;

		this.showLoader(0);

		var wrapper = document.createElement("div");
		var pageSize = lightwindow.getPageSize();
		var html = string.replacePlaceHolders(self.markup.externalContentWindow, {
			contentId: p.contentId,
			type: p.type,
			url: p.url,
			width: Math.round(pageSize[2]*0.8)+'px',
			height: Math.round(pageSize[3]*0.7)+'px',
			buttons: (((navigator.appVersion.indexOf('MSIE') != -1) || (navigator.appVersion.indexOf('Mozilla') != -1)) ? '<a href="javascript: void(0)" class="btn_edit copyToClipboard">Copy to clipboard</a>' : '')+'<a href="javascript: void(0)" class="btn_delete" onclick="lightwindow.hide();">Close</a>'
		});
		
		jQuery(wrapper).addClass('wrapper').append(html);
		
		this.getExternalContent(p.url, function(data, textStatus){
			
			if (textStatus != 'success') return;
			
			jQuery(wrapper).find('.copyToClipboard').on('click', function(){
				self.copyToClipboard(data);
			});
			
			var previewHtml = data;
			previewHtml = previewHtml.replace(/</g, "&lt;");
			previewHtml = previewHtml.replace(/>/g, "&gt;");
			
			if (navigator.appVersion.indexOf('MSIE') != -1) jQuery(wrapper).find('[rel="externalContent"]').get(0).innerText  = data;
			else jQuery(wrapper).find('[rel="externalContent"]').get(0).innerHTML  = previewHtml;
			
			window.setTimeout(function(){

				lightwindow.clear();
				lightwindow.show(wrapper);
				
				syntaxHighlighter.init();
				
				if (typeof(p.callback) == 'function') p.callback.apply();
			
			}, 50);
			
		});
	
	},
	
	getExternalContent: function(url, callback){
		jQuery.get(url,{},callback,'text');
	},

	preloadImages: function(images){

		for (var i=0; i<images.length; i++){
			var image = new Image();
			image.src = images[i];
		}
	},
	
	getURLVars: function () {
		var vars = [], hash;
		var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
		for(var i = 0; i < hashes.length; i++)
		{
			hash = hashes[i].split('=');
			vars.push(hash[0]);
			vars[hash[0]] = hash[1];
		}
		return vars;
	},
	
	getURLVar: function(name){
		return this.getURLVars()[name];
	},
	
	initTables: function(){
	
		//hightlighting
		jQuery('table[rel="data-table"]').each(function(){
		
			jQuery(this).find('tr td').mouseover(function(){ 
				jQuery(this).parent(':not(.selected)').addClass('line_highlighted');
			}).mouseout(function(){
				jQuery(this).parent().removeClass('line_highlighted');
			}).each(function(){
				if (typeof(jQuery(this).attr('onclick')) != 'undefined') jQuery(this).css('cursor', 'pointer');
			});
		
		});
	},
	
	openUrl: function(url,newWindow) {
		if(newWindow) {
			window.open(url);
		} else {
			window.location.href = url;
		}
	},


	initRichTextEditor: function(selector, options, elements){
	
		var richEditorButtons = {
			"formatselect": {
				pattern: /\bp\b|\baddress\b|\bpre\b|\bh1\b|\bh2\b|\bh3\b|\bh4\b|\bh5\b|\\bh6\b/,
				code: 'formatselect,',
				group: "0"
			},
			"bold": {
				pattern: /\bb\b|\bstrong\b/,
				code: 'bold,',
				group: "1"
			},
			"italic": {
				pattern: /\bi\b/,
				code: 'italic,',
				group: "1"
			},
			"underline": {
				pattern: /\bunderline\b/,
				code: 'underline,',
				group: "1"				
			},
			"sub": {
				pattern: /\bsub\b/,
				code: 'sub,',
				group: "2"
			},
			"sup": {
				pattern: /\bsup\b/,
				code: 'sup,',
				group: "2"
			},
			"bullist": {
				pattern: /\bul\b/,
				code: 'bullist,',
				group: "3"
			},
			"numlist": {
				pattern: /\bol\b/,
				code: 'numlist,',
				group: "3"
			},
			"link": {
				pattern: /\ba\[\b|\ba\b/,
				code: 'link,unlink,',
				group: "4"
			},
			"align": {
				pattern: /div\[align\]|p\[align\]/,
				code: 'justifyleft,justifycenter,justifyright,justifyfull,',
				group: "5"				
			},
			"indent": {
				pattern: /\indent\b/,
				code: 'outdent,indent,',
				group: "6"				
			}
			
		};
		
		var richEditorButtonGroups = {
			"0": false,
			"1": false,
			"2": false,
			"3": false,
			"4": false,
			"5": false
		};

		var richEditorOptions = {
			mode : "exact",
			elements: elements,
			theme : "advanced",
			theme_advanced_buttons1 : "newdocument,|,undo,redo,|,cut,copy,paste,|,charmap,|,search,replace,|,code,|,preview,|,removeformat,|,bold,italic,underline",
			theme_advanced_buttons2 : "",
			theme_advanced_buttons3 : "",
			theme_advanced_toolbar_location : "top",
			theme_advanced_toolbar_align : "left",
			plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,wordcount,advlist,visualblocks",
			oninit: (typeof initGlobalTabBox == 'function') ? initGlobalTabBox : null,
			content_css: "/template/resources/tiny_mce/content.css"
		};
		
		var getRrichEditorButton = function(name){
			var validElements = options.format.split(',');
			for(var i=0;i<validElements.length;i++){
				if ((typeof(richEditorButtons[name]) != 'undefined') && (validElements[i].match(richEditorButtons[name].pattern))) {
					richEditorButtonGroups[richEditorButtons[name].group] = true; 
					return richEditorButtons[name].code;
				}
			}
			return '';
		};
		
		var getRrichEditorGroupsSeparator = function(name){
			if (richEditorButtonGroups[name]) return '|,';
			return '';
		};
		
		var getRrichEditorBlockformats = function(){

			var result = '';
			var elm = 'p,address,pre,h1,h2,h3,h4,h5,h6';
			var blockformats = elm.split(',');
			var validElements = options.format.split(',');
			
			
			for (var i=0; i<blockformats.length;i++) {
				for (var j=0; j<validElements.length; j++) {
					if (blockformats[i] == validElements[j]) {
						result = result + blockformats[i] + ',';
						break;
					}
				}
			}
			
			return result.substring(0,(result.length-1));
		};
		
		if ((typeof(options.format)!='undefined') && ($.trim(options.format).length != 0)) {
		
			richEditorOptions = {
				// General options
				mode : "exact",
				elements: elements,
				theme : "advanced",
				plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,wordcount,advlist,visualblocks",

				// Theme options
				theme_advanced_buttons1 : "newdocument,|,undo,redo,|,cut,copy,paste,|,charmap,|,search,replace,|,code,|,preview,|,removeformat",
				theme_advanced_buttons2 : getRrichEditorButton('formatselect')+getRrichEditorGroupsSeparator('0')+getRrichEditorButton('bold')+getRrichEditorButton('italic')+getRrichEditorButton('underline')+getRrichEditorGroupsSeparator('1')+getRrichEditorButton('sub')+getRrichEditorButton('sup')+getRrichEditorGroupsSeparator('2')+getRrichEditorButton('bullist')+getRrichEditorButton('numlist')+getRrichEditorGroupsSeparator('3')+getRrichEditorButton('link')+getRrichEditorGroupsSeparator('4')+getRrichEditorButton('align')+getRrichEditorGroupsSeparator('5')+getRrichEditorButton('indent'),
				theme_advanced_blockformats: getRrichEditorBlockformats(),
				
				valid_elements: options.format.replace(/\bunderline\b/, 'span[style<text-decoration: underline;]').replace(/div\[align\]/,'div[style]').replace(/p\[align\]/,'p[style]'),

				theme_advanced_toolbar_location : "top",
				theme_advanced_toolbar_align : "left",
				theme_advanced_statusbar_location : "bottom",
				theme_advanced_resizing : false,
				oninit: (typeof initGlobalTabBox == 'function') ? initGlobalTabBox : null,
				content_css: "/template/resources/tiny_mce/content.css"
			};
			
		}
		if (($(selector).attr('readonly') == 'readonly') || ($(selector).attr('disabled') == 'disabled')) jQuery.extend(richEditorOptions, {readonly:1});
		if (typeof(options.contentCss) != 'undefined') jQuery.extend(richEditorOptions, {content_css:options.contentCss});
		if (typeof(options.directionality) != 'undefined') jQuery.extend(richEditorOptions, {directionality:options.directionality});
		if (typeof(options.theme_advanced_buttons1) != 'undefined') jQuery.extend(richEditorOptions, {theme_advanced_buttons1:options.theme_advanced_buttons1});

		$(selector).tinymce(richEditorOptions);
		
		this.richTextEditors.push(selector);
	},
	
	initMultiSelect: function() {
		
		$(".multiselect-picklist").pickList();
		//$(".multiselect").multiselect();
		$(".select-multiple").each(function() {
			$(this).parent().append('<div id="print_'+$(this).attr('id')+'" class="multiSelections">Selected options</div>');
			$(this).multiselect({
				header: true,
				height: 175,
				minWidth: 255,
				classes: "",
				checkAllText: "Check all",
				uncheckAllText: "Uncheck all",
				noneSelectedText: "Select options",
				selectedText: function(numChecked, numTotal, checkedItems){
					return numChecked + ' of ' + numTotal + ' checked';
				},
				selectedList: 50,
				show: null,
				hide: null,
				autoOpen: !1,
				multiple: !0,
				position: {my: 'left top', at: 'left bottom'},
				click: function(event, ui){
					app.printSelections($(this).attr('id'));
				},
				checkAll: function(){
					app.printSelections($(this).attr('id'));
				},
				uncheckAll: function(){
					app.printSelections($(this).attr('id'));
				},
				optgrouptoggle: function(){
					app.printSelections($(this).attr('id'));
				},
				create: function(){
					app.printSelections($(this).attr('id'));
				}
			});
		});
	},
	printSelections: function(containerId) {
		var $printContainer = $('#print_'+containerId);
		var $a = '<a href="javascript:void(0)">X&nbsp;</a>'
		$printContainer.empty();
		var $html = $('#'+containerId).multiselect("widget").find('.ui-multiselect-checkboxes').clone();
		if ($('#'+containerId).attr('disabled') == 'disabled'){
			$printContainer.addClass('ui-state-disabled');
			$a = '<span>X&nbsp;</span>';
		}
		$html.removeClass().removeAttr('style');
		$html.find('li > label > input').parent().parent().addClass('out');
		$html.find('li > label > input:checked').each(function() {
			$(this).parent().parent().removeClass().addClass('in').attr('id',$(this).val());
		});
		$html.find('li.out').remove();
		$html.find('.ui-multiselect-optgroup-label').each(function() {
			if ($(this).next().hasClass('ui-multiselect-optgroup-label') || ($(this).next().length < 1)){
				$(this).remove();
			} else {
				$(this).removeClass().addClass('groupName');
			}
		});
		$html.find('li.groupName a').each(function() {
			$(this).parent().text($(this).text());
		});
		$html.find('li.in label').each(function() {
			$(this).before($a+'<span>'+$(this).text()+'</span>');
			$(this).remove();
		});
		$html.find('li.in a').click(function() {
			$('#'+containerId).multiselect("widget").find('input[value='+$(this).parent().attr('id')+']').click();
		});
		($html.find('li').length != 0)? $printContainer.append($html) : $printContainer.append('Selected options');
	},
	
	initLightwindowContents: function() {
		var lightboxForms = new Array;
		
		$('[data-action="showFormInLightbox"][data-content-selector]').each(function(){
			var contentSelector = $(this).attr('data-content-selector');
			if ((contentSelector == '') || ($(contentSelector).length == 0)) return;
			
			var jContent = $(contentSelector);
			
			if (typeof(lightboxForms[contentSelector]) == 'object'){
				jContent = lightboxForms[contentSelector];
			} else {
				jContent.wrapInner('<div class="markupWrapper"></div>');
				
				jContent.append('\
				<div class="lightwindowContent formDialog wrapper">\
					<div class="contentrow">\
						<div class="hr"></div>\
						<div class="buttons_panel">\
							<div class="center">\
								<a class="btn_reset" href="javascript:void(0)" onclick="lightwindow.hide()">Close</a>\
							</div>\
							<p class="clr">&nbsp;</p>\
						</div>\
					</div>\
				</div>');
				jContent.find('.contentrow').prepend(jContent.find('.markupWrapper'));
				lightboxForms[contentSelector] = jContent;
			}
			$(this).click(function(){
				lightwindow.show(jContent, false);
			}); 
			
		});
		
	}
};

$(document).ready(function(){ 
    app.init();
});


function processObserver() {
    
    isStarted = false;
    processFlag = false;
    
    this.start = function(callback, interval){
      if (!isStarted) {
          isStarted = true;
          locator(callback, interval);
      }
      return false;
    };
    
    locator = function(callback, interval){
    
      if (processFlag == true) {
          processFlag = false;
          var _processObserver = this;
          window.setTimeout(function(){ _processObserver.locator(callback, interval) }, interval);
      } else {
          isStarted = false;
          callback.apply();
      }
      return false;
    
    };
    
    this.inProcess = function() {
        processFlag = true;
    }
    
};

var dateTimePattern = {
		
	normalize: function(pattern) {

		var replaceTableData = [
			{s: / /, 	r: '<#spcr#>'},
			{s: /yyyy/, r: '<#4y#>'},
			{s: /yy/, 	r: '<#2y#>'},
			{s: /MMMM/, r: '<#4m#>'},
			{s: /MMM/, 	r: '<#3m#>'},
			{s: /MM/, 	r: '<#2m#>'},
			{s: /M/, 	r: '<#1m#>'},
			{s: /ddd/, 	r: '<#3d#>'},
			{s: /a/, 	r: '<#1A#>'},
			{s: /S/, 	r: ''},
			{s: /<#1A#>/, 	r: 'tt'},
			{s: /<#3d#>/, 	r: 'DD'},
			{s: /<#1m#>/, 	r: 'm'},
			{s: /<#2m#>/, 	r: 'mm'},
			{s: /<#3m#>/, 	r: 'M'},
			{s: /<#4m#>/, 	r: 'MM'},
			{s: /<#2y#>/, 	r: 'y'},
			{s: /<#4y#>/, 	r: 'yy'},
			{s: /<#spcr#>/, r: ' '}
			
		];
		
		return string.replaceAllFromArray(pattern, replaceTableData);
	},

	get: function(options){
		
		var separatorPosition = this.getSeparatorPosition(options.pattern);
		var parts = new Array();
		parts[0] = options.pattern.slice(0,separatorPosition+1);
		parts[1] = options.pattern.slice(separatorPosition+1, options.pattern.length);
		
		var datePattern = '';
		var timePattern = '';
		
		if ((parts[0].indexOf('a') != -1) ||
			(parts[0].indexOf('H') != -1) ||
			(parts[0].indexOf('k') != -1) || 
			(parts[0].indexOf('K') != -1) || 
			(parts[0].indexOf('h') != -1) || 
			(parts[0].indexOf('m') != -1) || 
			(parts[0].indexOf('s') != -1) || 
			(parts[0].indexOf('S') != -1) || 
			(parts[0].indexOf('z') != -1) ||
			(parts[0].indexOf('Z') != -1)) {
			
			datePattern = this.normalize(parts[1]);
			timePattern = this.normalize(parts[0]);
			
		} else {

			datePattern = this.normalize(parts[0]);
			timePattern = this.normalize(parts[1]);
		}
		
		switch (options.type) {
			case 'date':
				return jQuery.trim(datePattern);
			break;
			case 'time':
				return jQuery.trim(timePattern);
			break;
			default:
				return null;
			break;
		}
		
	},
	
	getSeparatorPosition: function(patternString){
		var arrayTime = new Array('a','H','k','K','h','m','s','S','z','Z');
		var timeBoundary = null;

		var arrayDate = new Array('G','y','M','w','W','D','d','F','E');
		var dateBoundary = null;
		
		for(var i=0; i<patternString.length; i++){
			if ($.inArray(patternString.charAt(i), arrayTime) != -1 ) {
				timeBoundary = i-1;
				break;
			}
		}
		
		for(var i=0; i<patternString.length; i++){
			if ($.inArray(patternString.charAt(i), arrayDate) != -1) {
				dateBoundary = i-1;
				break;
			}
		}		
		
		if (timeBoundary == null) return patternString.length+1;
		if (dateBoundary == null) return -1;

		if (timeBoundary > dateBoundary) return timeBoundary;
		else return dateBoundary;
	
	}

};

var string = {

	replaceAll: function(subject, pattern, replace){
		var counter = 0;
		do {
			subject = subject.replace(pattern,replace);
			counter++;
		} while((subject.search(pattern) != -1) && (counter<100));
		
		return subject;
	},
	
	replaceAllFromArray: function(subject, replaceTable){
		var result = subject;
		for(var i=0; i<replaceTable.length; i++){
			result = this.replaceAll(result, replaceTable[i].s, replaceTable[i].r );
		}
		return result;
	},
	
	replacePlaceHolders: function(subject, data) {
		
		for (var prop in data) {
			var pattern = new RegExp("<#"+prop+"#>");
			subject = this.replaceAll(subject, pattern, data[prop]);
		}
		
		return subject;
	}
};

var polling = {
	url: 'server/time.php',
	options: {
		selector: '',
		interval: 5000,
		errorMessage: 'error: data is undefined',
		alignment: 'top',
		polling: true
	},
	getData: function(options){
		$.get(options.url, function(data) {
			var obj = $('#'+options.selector);
				obj.html(data);
				if(options.alignment == 'bottom'){
					if(!obj.is( 'textarea' )){
						var scrollValue = obj.parent().height();
						obj.parent().scrollTop( scrollValue );
					} else {
						var scrollValue = obj.height();
						obj.scrollTop( scrollValue );
					}
				}
		}).fail(function() {
				$('#'+options.selector).html(options.errorMessage);
		});
	},
	pollData: function(options){
		var self = this;
		self.getData(options);
		if (options.polling){
			setTimeout(function(){ self.pollData(options); },options.interval);
		}
	},
	init: function(options){
		var self = this;
		var opt = options;
		opt.url = (typeof(opt.url) != 'undefined')? opt.url : self.url;
		opt.interval = (typeof(opt.interval) != 'undefined')? opt.interval : self.options.interval;
		opt.errorMessage = (typeof(opt.errorMessage) != 'undefined')? opt.errorMessage : self.options.errorMessage;
		opt.alignment = (typeof(opt.alignment) != 'undefined')? opt.alignment : self.options.alignment;
		opt.polling = (typeof(opt.polling) != 'undefined')? opt.polling : self.options.polling;

		if ($('#'+opt.selector).length > 0){
			self.pollData(opt);
		};
	}
};

