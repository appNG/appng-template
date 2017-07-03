$(function() {
    
    function addURLTimeStamp(url){
        
        var pathAndParam = url.split('#')[0];
        var hash = (url.split('#').length>=2) ? url.split('#')[1] : '';
        
        var path = pathAndParam.split('?')[0];
        
        var params = (pathAndParam.split('?').length>=2) ? pathAndParam.split('?')[1] : '';
        var paramArr = (params!='')?params.split('&'):[];
        
        var ts = new Date().getTime();
        
        var found = false,
            name,
            value,
            newParams='';
            
        for(var i=0;i<paramArr.length;i++) {
            name = paramArr[i].split('=')[0];
            value = (paramArr[i].split('=').length>=2) ? paramArr[i].split('=')[1] : '';
            if (name != 'ts') {
                newParams += '&'+name+'='+value;
            } else {
                found = true;
                newParams += '&'+name+'='+ts;
            }
        }
        if (!found) newParams += '&ts='+ts;
        
        newParams = newParams.substring(1);
        
        return (path+"?"+newParams+((hash!='')?'#':'')+hash);
        
    }
    
    $(".editable").each(function(){
        
        var jObj = $(this),
            jObjValue = jObj.html();
        
        switch (jObj.attr('data-type')) {
            
            case "input-text":
                $(this).editable(function(value, settings) {
                        
                    var submitdata = JSON.parse(jObj.attr('data-submitdata'));
                    submitdata[jObj.attr('data-name')] = value;
                    
                    $.post(jObj.attr('data-action'), submitdata)
                        .done(function(data) {
                            
                            var jData = $(data),
								jErrorMessage = jData.find('messages > message[class="ERROR"]');
								
                            if  (jErrorMessage.length == 0) {
                                
                                jObj.html(value);
                                jObj.attr('data-value', value);
                                
                                var href = window.location.href; 
                                href = addURLTimeStamp(href);
                                window.location.href = href;
                                
                            } else {
                                jObj.html(jObjValue);
                                var errorMessage = jErrorMessage.text();
                                
                                jObj.parents('.tab_box_item').prepend('\
                                    <table class="eventmessage">\
                                        <tr>\
                                            <td align="center">\
                                                <div class="centered fade-text error" style="display: inline-block;">\
                                                    <p class="text">'+errorMessage+'</p>\
                                                </div>\
                                            </td>\
                                        </tr>\
                                    </table>\
                                ');
                            }
                            
                        })
                        .fail(function() {
                            jObj.html(jObjValue);
                        })
                            
                    return('Saving...')
                    
                }, {
                    type: "text",
                    data: (function(){return jObj.attr('data-value')}),
                    cssclass: 'editable-form',
                    submit: 'ok'
                });
            break;
        }
    });

});