/* TabBox JS */
function TabBox(config){
    
    this.config = {
        id: null,
        buttonPanelId: null,
        buttonPanelClass: "button_panel_type2",
        itemClass: "content_item",
        itemTitleClass: "button_panel_type2",
        buttonPrefixTemplate:  '',
        buttonSuffixTemplate: ''
    };
    this.extend = function(destination, source) {
      for (var property in source)
        destination[property] = source[property];
      return destination;
    };
    
    
    this.items = new Array();
    this.buttonPanel = null;
    
    this.init = function(config){
        
        //Config
        this.config = this.extend(this.config, config);
        
        //Suche nach "Button panel"
        if (jQuery('#'+this.config.buttonPanelId).get().length > 0) {
            this.buttonPanel = jQuery('#'+this.config.buttonPanelId).get(0);
        } 
        
        //Suche nach Items, id bestimmen
        
        var elements = jQuery('#'+this.config.id+' .'+this.config.itemClass).get();
        for (var i=0; i<elements.length; i++){
        
            var item = { anchorId: null,  contentTitle: null, contentId: null };
            
            item.anchorId = this.config.id+"_anchor_"+i ;
            item.contentId = this.config.id+"_item_"+i ;
            item.contentTitle = null;
            item.rel = jQuery(elements[i]).attr('rel').replace(/^\s+/, '').replace(/\s+$/, ''); // with trim
            
            //Lokale Anchor loeschen
            jQuery('#'+this.config.id+' a.anchor-to-delete').remove();
            
            
            if (jQuery('#'+this.config.id+' .'+this.config.itemClass+' .'+this.config.itemTitleClass+' ul li span').length>0) {
                item.contentTitle =  jQuery('#'+this.config.id+' .'+this.config.itemClass+' .'+this.config.itemTitleClass+' ul li span').get(i).innerHTML;
            }
            
            elements[i].id = item.contentId;
            
            this.items[this.items.length] = item;
            
            
        }//for
        if (this.buttonPanel != null) {
            this.doButtonPanel();
            this.hideTabs();
        }
        
    };
    
    this.doButtonPanel = function(){
    
        /*    
        <div class="button_panel_type2">
          <ul>
            <li class="selected"><a href="#"><span>Beschreibung</span></a></li>
            <li><a href="#"><span>Anreiseinformationen</span></a></li>
            <li><a href="#"><span>News</span></a></li>
            <li><a href="#"><span>Routenvorschl&auml;ge</span></a></li>
          </ul>  
          <p class="clr">&nbsp;</p>
        </div>
        */    
        
        var htmlText = '<div class="'+this.config.buttonPanelClass+' not_printable"><ul>';
    
        for(var i=0; i<this.items.length; i++){
            
            var item = this.items[i];
            var cssClass = '';
            if (i==0)  cssClass = ' class="selected"';
            
            htmlText += '<li'+cssClass+'><a id="'+item.anchorId+'" href="javascript:void(0)" onfocus="if(this.blur)this.blur()"><span>'+this.config.buttonPrefixTemplate+item.contentTitle+this.config.buttonSuffixTemplate+'</span></a></li>';
            
            //Title-Leiste ausblenden
            jQuery('#'+item.contentId+' .'+this.config.itemTitleClass).hide();
        }
        htmlText += '</ul><p class="clr">&nbsp;</p></div>';
        this.buttonPanel.innerHTML = htmlText;
    };
   
    this.hideTabs = function(){
        for(var i=0; i<this.items.length; i++){
            if (i!=0) jQuery('#'+this.items[i].contentId).hide();
        }    
    };
    
    this.showTab = function(index){
        
        for (var i=0; i<this.items.length;i++){
            if (i == index)  jQuery('#'+this.items[i].contentId).show();
            else jQuery('#'+this.items[i].contentId).hide();
        }
        
    };
    
    this.toggleButton = function(buttonPanelId, index){
        var liItems = jQuery('#'+buttonPanelId+' ul li').get();
        for (var i=0; i<liItems.length; i++){
              if (i==index) jQuery(liItems[i]).addClass('selected');
              else jQuery(liItems[i]).removeClass('selected');
        }
    
    };
    
};
var tabBox = {
   
   items: new Array(),
   
   addItem: function(config){
        if (jQuery('#'+config.id).attr('rel') != 'initialized'){
          var box = new TabBox();
          box.init(config);
          tabBox.items.push(box);
          tabBox.initEvents(tabBox.items.length-1);
        }
        jQuery('#'+config.id).attr('rel', 'initialized');
   },
   
   initEvents: function(index){
        for (var i=0; i<tabBox.items[index].items.length; i++){
            var anchorId = tabBox.items[index].items[i].anchorId;
            tabBox.initEventByItem('click', index, i);
        }
   },
   
   initEventByItem: function(event, boxIndex, itemIndex){
        var anchorId = tabBox.items[boxIndex].items[itemIndex].anchorId;
        jQuery('#'+anchorId).on(event, function(){
            tabBox.items[boxIndex].toggleButton(tabBox.items[boxIndex].config.buttonPanelId ,itemIndex);
            tabBox.items[boxIndex].showTab(itemIndex);
            
            if (tabBox.items[boxIndex].items[itemIndex].rel != '') {
              var urlItems = location.href.split('#');
              location.replace(urlItems[0]+'#'+tabBox.items[boxIndex].items[itemIndex].rel);
            }
            
        });
   },
   
   activateTabByName: function(name){
        
      if ((name != '') && (name != 'undefined')){
        for (var boxIndex=0; boxIndex<tabBox.items.length; boxIndex++){
          for (var itemIndex=0; itemIndex<tabBox.items[boxIndex].items.length; itemIndex++){
            if (name == tabBox.items[boxIndex].items[itemIndex].rel) {
                tabBox.items[boxIndex].toggleButton(tabBox.items[boxIndex].config.buttonPanelId ,itemIndex);
                tabBox.items[boxIndex].showTab(itemIndex);
                window.scrollTo(0,0);
            }
          }
        }
      }
   }
   
};
