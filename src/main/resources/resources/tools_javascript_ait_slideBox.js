/* slideBox JS */
var slideBox = {
    init: function(name, config){
        slideBox[name] = new SlideBox();
        slideBox[name].setConfig(config);
        return slideBox[name];
    },
    
    addItem: function(name, id, folding){
        slideBox[name].addItem(id,folding);
    }
};
var SlideBox = function(){
    
   this.currentItemId = null;
    
   this.config = {
        listType: 0, // 0 - nur eins Item anzeigen; 1 - alle Items anzeigen
        notPrintableCssClassName: "notPrintable",
        defaultSelectedCssClassName: "selected",
        switchCssClassNameByHover: "switchHover",
        switchCssClassNameByNotHover: "",
        switchIconIdSuffix: '-switchIcon',
        switchIconCssClassNameByClose: 'switchIconClose',
        switchIconCssClassNameByOpen: 'switchIconOpen',
        boxIdSuffix: '_a',
        switchHeadlineAlwaysPrintable: false 
    };
    
    this.setConfig = function(userConfig){
        this.config = jQuery.extend(this.config, userConfig);
    };
    
    this.addItem = function(id,folding){
    
        var obj = jQuery('#'+id).get(0);
        var slideBoxObj = this;
        
        if (obj != null){
        
          if ((!this.config.switchHeadlineAlwaysPrintable) && (!jQuery(obj).hasClass(this.config.notPrintableCssClassName))) {
            jQuery(obj).addClass(this.config.notPrintableCssClassName);
          }
          
          var obj_a = jQuery('#' + id + slideBoxObj.config.boxIdSuffix).get(0);
          if (obj_a != null) {
            
            if (!jQuery(obj).hasClass(this.config.defaultSelectedCssClassName)) obj_a.style.display = 'none';
            else {
                obj_a.style.display = 'block';
                this.currentItemId = id;
            }
            
            jQuery(obj).on('click', function() {
                 onClick(id, slideBoxObj);
                 resetSelected(id);
            });
          }  
          
          jQuery(obj).on('mouseover', function()     { setSelected(id, slideBoxObj); });
          jQuery(obj).on('mouseout', function()     { resetSelected(id, slideBoxObj); });
          
          if (folding == 'false'){ onClick(id, slideBoxObj); };
          
          var item_anchor = unescape(self.document.location.hash.substring(1));
          if (item_anchor == id){ onClick(id, slideBoxObj); };
        }
    };
    
    onClick = function(id, slideBoxObj) {
    
        if ((slideBoxObj.currentItemId != null) && (slideBoxObj.currentItemId != id) && (slideBoxObj.config.listType == 0)) {
          toggleItem(slideBoxObj.currentItemId + slideBoxObj.config.boxIdSuffix);
          toggleIcon(slideBoxObj.currentItemId + slideBoxObj.config.switchIconIdSuffix, slideBoxObj); 
        }
        toggleItem(id + slideBoxObj.config.boxIdSuffix);
        toggleIcon(id + slideBoxObj.config.switchIconIdSuffix, slideBoxObj); 
        
        if ((slideBoxObj.config.listType == 1) && (!slideBoxObj.config.switchHeadlineAlwaysPrintable)) { 
            if (!jQuery('#'+id).hasClass(slideBoxObj.config.notPrintableCssClassName))  jQuery('#'+id).addClass(slideBoxObj.config.notPrintableCssClassName);
            else  jQuery('#'+id).removeClass(slideBoxObj.config.notPrintableCssClassName);
        }
        
        if (slideBoxObj.config.listType == 0) {
            if (slideBoxObj.currentItemId != id) {
                if (!slideBoxObj.config.switchHeadlineAlwaysPrintable) {
                  if (slideBoxObj.currentItemId != null) jQuery('#'+slideBoxObj.currentItemId).addClass(slideBoxObj.config.notPrintableCssClassName);
                  jQuery('#'+id).removeClass(slideBoxObj.config.notPrintableCssClassName);
                }
                slideBoxObj.currentItemId = id; 
                
            } else {
                if ((slideBoxObj.currentItemId != null) && (!slideBoxObj.config.switchHeadlineAlwaysPrintable)) jQuery('#'+slideBoxObj.currentItemId).addClass(slideBoxObj.config.notPrintableCssClassName);
                slideBoxObj.currentItemId = null;
            }
        }
    };
    
    setSelected = function(id, slideBoxObj){
        if (slideBoxObj){
            jQuery('#'+id).removeClass(slideBoxObj.config.switchCssClassNameByNotHover);
            jQuery('#'+id).addClass(slideBoxObj.config.switchCssClassNameByHover);
        }
    };
    resetSelected = function(id, slideBoxObj){
        if (slideBoxObj){
            jQuery('#'+id).removeClass(slideBoxObj.config.switchCssClassNameByHover);
            jQuery('#'+id).addClass(slideBoxObj.config.switchCssClassNameByNotHover);
        }
    };
    toggleItem = function(id){
        if (jQuery('#'+id).css('display') == 'none') {
            jQuery('#'+id).slideDown("fast"); 
        }
        else  jQuery('#'+id).slideUp("fast");
    };
    toggleIcon = function(id, slideBoxObj){
        if ((jQuery('#'+id).get(0)!= null)) {
          if (jQuery('#'+id).hasClass(slideBoxObj.config.switchIconCssClassNameByClose)) {
            jQuery('#'+id).removeClass(slideBoxObj.config.switchIconCssClassNameByClose);
            jQuery('#'+id).addClass(slideBoxObj.config.switchIconCssClassNameByOpen);
          }  
          else {
            jQuery('#'+id).removeClass(slideBoxObj.config.switchIconCssClassNameByOpen);
            jQuery('#'+id).addClass(slideBoxObj.config.switchIconCssClassNameByClose);
          }  
        }
    };    
};