function form(formSelector, options){
    
	this.c = {
		isSkinning: false,
		element: {
			classNameByError: 'error',
			selectorMarkContainer: '.mark-container',
			tipText: ''
		},
		localization: {
			date: {
				shortYearCutoff: '+10',
				dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
				dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
				monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
				monthNames: ['January','February','March','April','May','June','July','August','September','October','November','December'],
				dayNamesMin: ['Su','Mo','Tu','We','Th','Fr','Sa'], // Column headings for days starting at Sunday
				prevText: 'Prev', // Display text for previous month link
				nextText: 'Next', // Display text for next month link
				weekHeader: 'Wk', // Column header for week of the year
				dateFormat: 'mm/dd/yy', // See format options on parseDate
				firstDay: 0, // The first day of the week, Sun = 0, Mon = 1, ...
				isRTL: false, // True if right-to-left language, false if left-to-right
				showMonthAfterYear: false, // True if the year select precedes month, false for month then year
				yearSuffix: '' // Additional text to append to the year in the month headers
			},
			time: {
				currentText: 'Now',
				closeText: 'Done',
				ampm: false,
				amNames: ['AM', 'A'],
				pmNames: ['PM', 'P'],
				timeFormat: 'hh:mm tt',
				timeSuffix: '',
				timeOnlyTitle: 'Choose Time',
				timeText: 'Time',
				hourText: 'Hour',
				minuteText: 'Minute',
				secondText: 'Second',
				millisecText: 'Millisecond',
				timezoneText: 'Time Zone'											
			},			
			number: {
				format: '#.##',
				groupingSeparator: ',',
				decimalSeparator: '.'			
			}
		},
		
		markup: {
			errorMessage: '\
				<div>\
					<table class="eventmessage">\
						<tr>\
							<td align="center">\
							   <div class="centered fade-text error">\
								   <p class="text"><#error-message#></p>\
							   </div>\
							</td>\
						</tr>\
					</table>\
				</div>\
			'
		},

		message: {
			valueIsEmpty: 'Error: Value is empty',
			dateInvalid: 'Error: Date value is invalid',
			intInvalid: 'Error: Integer value is invalid',
			decimalInvalid: 'Error: Decimal value is invalid'
		}		
		
	};

	
    this.obj = null;
    this.element = new Array();
	this.group = new Array();
    
    this.init = function(formSelector, options){
        
		var self = this;
		
		var objLastElement = function(obj){
			var len=0;
			for (var i in obj) len++;
			return {index:len-1, name: i};
		};
		
		//Localization
		if (typeof(options.localization) == 'object') {
			
			//Date
			jQuery(function($){
				var lastElement = objLastElement($.datepicker.regional);
				if (lastElement.index>=1) $.extend(self.c.localization.date, $.datepicker.regional[lastElement.name]);
				if (typeof(options.localization.date) == 'object') $.extend(self.c.localization.date, options.localization.date);
				$.datepicker.setDefaults(self.c.localization.date);
			});			
			
			//Time
			(function($){
				var lastElement = objLastElement($.timepicker.regional);
				if (lastElement.index>=1) $.extend(self.c.localization.time, $.timepicker.regional[lastElement.name]);
				if (typeof(options.localization.time) == 'object') jQuery.extend(self.c.localization.time, options.localization.time);
				$.timepicker.setDefaults(self.c.localization.time);
			})(jQuery);			
			
			//Number
			if (typeof(options.localization.number) == 'object') jQuery.extend(this.c.localization.number, options.localization.number);
		}


		if (typeof(options.element) == 'object')  jQuery.extend(this.c.element, options.element);
		
		this.c.isSkinning = (typeof(options.isSkinning) != 'undefined') ? options.isSkinning : this.c.isSkinning;
		
        this.element = new Array();
        this.obj = jQuery(formSelector).get(0);
    };
    
    this.addElement = function(selector, type, options){
        
		options.mandatory = (typeof(options.mandatory)!='undefined') ? options.mandatory : false;
		options.tipText = (typeof(options.tipText)!='undefined') ? options.tipText : this.c.element.tipText;
		
		var defaultLocalization = {};
		jQuery.extend(defaultLocalization, this.c.localization);
		options.localization = (typeof(options.localization)!='undefined') ? jQuery.extend(defaultLocalization, options.localization)  : defaultLocalization;
		options.localization = defaultLocalization;
		
		
		var defaultMarkup = {};
		jQuery.extend(defaultMarkup, this.c.markup);
		options.markup = (typeof(options.markup)!='undefined') ? Query.extend(defaultMarkup, options.markup) : this.c.markup;
		options.markup = defaultMarkup
		
		var defaultMessage = {};
		jQuery.extend(defaultMessage, this.c.message);
		options.message = (typeof(options.message)!='undefined') ? Query.extend(defaultMessage, options.message) : this.c.message;
		options.message = defaultMessage;
		
		if ((type == 'date') && (typeof(options.datetimepickerCongif) == 'object')) {
			$(selector).datetimepicker(options.datetimepickerCongif);		
		}
		
        var elm = new formElement(this, selector, type, options);
        if (elm) this.element.push(elm);
    };
    
    this.validateForm = function(){

		var valid = true;
        
		if (this.element != null)
			for(var i=0; i < this.element.length; i++){
				if (this.element[i].checkElement() == false) valid = false;
			}

		if (this.group != null)
			for(var i=0; i < this.group.length; i++){
				if (this.group[i].checkGroup() == false) valid = false;
			}
		
		if (valid) this.removeTipTextValues();
		
		return valid;
    };

	this.addGroup = function(groupName, options){
	
		var mandatory = (typeof(options.mandatory) != 'undefined') ? options.mandatory : false;
		var rule = (typeof(options.rule) != 'undefined') ? options.rule : 'OR';
		
		var group = new formGroup(this, groupName, mandatory, rule);
		this.group.push(group);
	};
	
	this.addElementToGroup = function(groupName, elementSelector, elementType, options){

		for(var i=0; i<this.group.length;i++) {
			if (this.group[i].groupName == groupName) {
				this.group[i].addElement(elementSelector, elementType, options);
			}
		}
	};
	
	this.removeTipTextValues = function() {

		for(var i=0; i < this.element.length; i++){
			if ((this.element[i].tipText != '') && (this.element[i].obj.value == this.element[i].tipText)) this.element[i].obj.value = '';
		}
	}
	
	this.init(formSelector, options);
	
} //form

function formElement(form, selector, type, options){

	var self = this;
	this.form = form;
    this.selector = selector; 
    this.type = type;
	this.options = {}; this.options = jQuery.extend(this.options, options);

	//private
	this.errorMessages = new Array();
	
	//Obj
	switch(this.type){
		case "radio":
		case "list:radio":
			this.obj = jQuery('input[type="radio"][name="'+selector+'"]');
		break;
		default:
			this.obj = jQuery(selector).get(0);
		break;
	};
	
	//tipText
	this.tipText = (typeof(this.options.tipText) != 'undefined') ? this.options.tipText : null;
	
	//markObj
    this.markObj = null;
    switch(this.type){
	
        case "radio" :
		case "list:radio" :
            this.markObj = (jQuery(this.obj.get(0)).parents(this.form.c.element.selectorMarkContainer).length > 0) ? jQuery(this.obj.get(0)).parents(this.form.c.element.selectorMarkContainer).get(0) : null;
            break;
			
		case "boolean" :
        case "checkbox" :
		case "list:checkbox" :
            this.markObj = (jQuery(this.selector).parents(this.form.c.element.selectorMarkContainer).length > 0) ? jQuery(this.selector).parents(this.form.c.element.selectorMarkContainer).get(0) : null;
            break;
			
		case "text" :
		case "list:text" :
		case "longtext" :
			this.markObj = this.obj;
			if (this.tipText != null) {
				var self = this;
				if (this.obj.value == '') this.obj.value = this.tipText;
				jQuery(this.obj).on('focus', function(){ if (this.value == self.tipText) this.value = '' });
				jQuery(this.obj).on('blur', function(){ if (jQuery.trim(this.value) == '') this.value = self.tipText });
			}
			break;
		default :
            this.markObj = this.obj;
            break;
    }
    
	//Dependencies
	if (typeof(options.dependencies) != 'undefined') {
		var dependenciesProcessor = new DependenciesProcessor(selector, type, options.dependencies);
	}	

	//validationRules
	this.options.mandatory = false;
	if (typeof(options.validationRules) != 'undefined') {
		this.options.validationRules = new Array;
		for (var i=(options.validationRules.length-1); i>=0; i--) {
			if (options.validationRules[i].type.toLowerCase() != 'notnull') this.options.validationRules.push(options.validationRules[i]);
			else {
				this.options.mandatory = true;
				this.options.message.valueIsEmpty = options.validationRules[i].errorMessage;
			}
		}
	} else {
		this.options.validationRules = new Array();
	}
	
	//Functions
    this.checkElement = function(){
		
        var valid = this.isValid();
		
		if (valid) this.clearLabelElement();
		else this.markLabelElement();
        
		return valid;	
		
    };
	
	
	this.isValid = function(){
		
		var valid = true;
		this.errorMessages = new Array();
		
		switch(this.type){
			case "date":
				valid = this.checkDateTimeElement();
				break;
			case "coordinate":
			case "long":
			case "decimal":
			case "int":
			case "text":
			case "list:text":
			case "file":
			case "file-multiple":
			case "password":
				valid = this.checkTextElement();
				break;
			case "radio":
			case "list:radio":
				valid = this.checkRadioElement();
				break;
			case "boolean":
			case "checkbox":
			case "list:checkbox":
				valid = this.checkCheckboxElement();
				break;
			case "longtext":
				valid = this.checkTextareaElement();
				break;
			case "select":
			case "list:select":
				valid = this.checkSelectElement();
				break;
			case "richtext":
				//markObj kann nur nach RichText Editor Initialisierung ermittelt werden
				var markSelector = '#'+jQuery(self.selector).attr('id') + '_parent';
				self.markObj = (jQuery(markSelector).length > 0) ? jQuery(markSelector).get(0) : null;					
				
				valid = this.checkTextareaElement();
				break;
			default:
				valid = false;
				break;
		};

        return valid;
		
	};	
	

	
    this.checkTextElement = function(){
		
		var self = this;
		
		//is empty & mandatory
		if (jQuery.trim(this.obj.value) == '') {
			if (this.options.mandatory == false) return true;
			else {
				this.errorMessages.push(this.options.message.valueIsEmpty); 
				return false;
			}
		}
		
		//data type validation
		var isInt = function(value){
			var intRegex = /^[\+|-]{0,1}\d*[.]{0,1}\d+$/;
			return (intRegex.test(value.toString()) && !isNaN(parseInt(value.toString())) && (parseFloat(value.toString()) == parseInt(value.toString())));
		};
		
		var isDecimal = function(value){
			var intRegex = /^[\+|-]{0,1}\d*[.]{0,1}\d+$/;
			return intRegex.test(value.toString());
		};
		
		var isFormatValid = function(value){
			var numberValue = $.format.number(value);
			var formatedValue = $.format.number(numberValue);
			return (formatedValue == value) ? true : false;
		};
		
		$.format.locale({
			number: this.options.localization.number
		});	
		
		var typeValid = true;
		var elementValue = this.obj.value;

		switch(this.type){
			case "coordinate":
			case "decimal":

				elementValue = $.format.number(this.obj.value).toString();

				var typeError = false;
				if ((this.options.localization.number.groupingSeparator != '.') && (this.options.localization.number.decimalSeparator != '.')) {
					if ((this.obj.value.indexOf('.') != -1) || (!isDecimal(elementValue))) typeError = true;
				} else if (!isDecimal(elementValue)) typeError = true;
				
				if (typeError) {
					var errorMessage = (typeof(this.options.typeErrorMessage) != 'undefined') ? this.options.typeErrorMessage : this.options.message.decimalInvalid;
					this.errorMessages.push(errorMessage);
					return false;
				}

				var numberValue = $.format.number(this.obj.value);
				this.obj.value = $.format.number(numberValue, this.options.localization.number.format);
				elementValue = numberValue;

			break;

			case "long":
			case "int":

				elementValue = $.format.number(this.obj.value).toString();

				var typeError = false;
				if ((this.options.localization.number.groupingSeparator != '.') && (this.options.localization.number.decimalSeparator != '.')) {
					if ((this.obj.value.indexOf('.') != -1) || (!isInt(elementValue))) typeError = true;
				} else if (!isInt(elementValue)) typeError = true;
				
				if (typeError) {
					var errorMessage = (typeof(this.options.typeErrorMessage) != 'undefined') ? this.options.typeErrorMessage : this.options.message.intInvalid;
					this.errorMessages.push(errorMessage);
					return false;
				}

				var numberValue = $.format.number(this.obj.value);
				this.obj.value = $.format.number(numberValue, this.options.localization.number.format);
				elementValue = numberValue;

			break;
		
		}
		
		//rules validation
		var vResult = validationRulesProcessor.validate(elementValue, this.options.validationRules);
        if ((vResult.valid) && (jQuery.trim(elementValue) != this.tipText)) return true;
        else {
			this.errorMessages = vResult.errorMessages; 
			return false;
		}
    };
	
    this.checkRadioElement = function(){
        
		//value 
		var value = null;
		for (var i=0; i< this.obj.length; i++){
			value = (this.obj.get(i).checked == true) ? this.obj.get(i).value : value;
		}
		
		//is empty & mandatory
		if (value == null) {
			if (this.options.mandatory == false) return true;
			else {
				this.errorMessages.push(this.options.message.valueIsEmpty); 
				return false;
			}
		}

		//data type validation
		//not necessarily
		
		//rules validation
		vResult = validationRulesProcessor.validate(value, this.options.validationRules);
		if (vResult.valid) return true;
		else {
			this.errorMessages = vResult.errorMessages; 
			return false;
		}
	
    };
	
    this.checkCheckboxElement = function(){
		
		//value 
		var value = (this.obj.checked == true) ? this.obj.value : null;
		
		//is empty & mandatory
		if (value == null) {
			if (this.options.mandatory == false) return true;
			else {
				this.errorMessages.push(this.options.message.valueIsEmpty); 
				return false;
			}		
		}
		

		//data type validation
		//not necessarily

		//rules validation
		vResult = validationRulesProcessor.validate(value, this.options.validationRules);
		if (vResult.valid) return true;
		else {
			this.errorMessages = vResult.errorMessages; 
			return false;
		}		
      
    };
	
    this.checkTextareaElement = function(){
	
		//is empty & mandatory
		if (jQuery.trim(this.obj.value) == '') {
			if (this.options.mandatory == false) return true;
			else {
				this.errorMessages.push(this.options.message.valueIsEmpty); 
				return false;
			}		
		}
		
		//data type validation
		//not necessarily
		
		//rules validation
		var vResult = validationRulesProcessor.validate(this.obj.value, this.options.validationRules);
        if ((vResult.valid) && (jQuery.trim(this.obj.value) != this.tipText)) return true;
        else {
			this.errorMessages = vResult.errorMessages; 
			return false;
		}
    };
	
    this.checkSelectElement = function(){
		return this.checkTextareaElement();
    };
	
    this.checkDateTimeElement = function(){

		//is empty ?
		if (jQuery.trim(this.obj.value) == '') {
			if (this.options.mandatory == false) return true;
			else {
				this.errorMessages.push(this.options.message.valueIsEmpty);
				return false;
			}
		}
		
		//data type validation
		var separatorPosition = dateTimePattern.getSeparatorPosition(options.format);
	   
		var formatParts = new Array();
		formatParts[0] = options.format.slice(0,separatorPosition+1);
		formatParts[1] = options.format.slice(separatorPosition+1, options.format.length);
		
		var dateValue = '';
		var timeValue = '';
		
		if ((formatParts[0].indexOf('a') != -1) ||
			(formatParts[0].indexOf('H') != -1) ||
			(formatParts[0].indexOf('k') != -1) || 
			(formatParts[0].indexOf('K') != -1) || 
			(formatParts[0].indexOf('h') != -1) || 
			(formatParts[0].indexOf('m') != -1) || 
			(formatParts[0].indexOf('s') != -1) || 
			(formatParts[0].indexOf('S') != -1) || 
			(formatParts[0].indexOf('z') != -1) ||
			(formatParts[0].indexOf('Z') != -1)) {
			
			dateValue = $.trim(this.obj.value.slice(separatorPosition+1, options.format.length));
			timeValue = $.trim(this.obj.value.slice(0,separatorPosition+1));
		} else {
			timeValue = $.trim(this.obj.value.slice(separatorPosition+1, options.format.length));
			dateValue = $.trim(this.obj.value.slice(0,separatorPosition+1));
		}
		
		
		var dateFormat = dateTimePattern.get({pattern: options.format, type: 'date'});
		var timeFormat = dateTimePattern.get({pattern: options.format, type: 'time'});
		

		//Date
		var replaceTableData = [
			{s: /-/, r: '<#HYPHEN#>'},
			{s: /\./, r: '<#POINT#>'},
			{s: /\//, r: '<#SLASH#>'},
			{s: /\\/, r: '<#BACKSLASH#>'},
			{s: /\ /, r: '<#SPACE#>'},
			{s: /\$/, r: '<#DOLLAR#>'},
			{s: /yy/, r: '\\<#D#>{1,4}'},
			{s: /y/,  r: '\\<#D#>{1,2}'},
			{s: /MM/, r: '\\w+'},
			{s: /M/,  r: '\\w+'},
			{s: /mm/, r: '\\<#D#>{1,2}'},
			{s: /m/,  r: '\\<#D#>{1,1}'},
			{s: /dd/, r: '\\<#D#>{1,2}'},
			{s: /d/,  r: '\\d{1,1}'},
			{s: /<#D#>/, r: 'd'},
			{s: /<#DOLLAR#>/, r: '\\$'},
			{s: /<#SPACE#>/, r: '\\ '},
			{s: /<#BACKSLASH#>/, r: '\\\\'},
			{s: /<#SLASH#>/, r: '\/'},
			{s: /<#POINT#>/, r: '\.'},
			{s: /<#HYPHEN#>/, r: '\-'}
		];
		
		var dateRegExpString = string.replaceAllFromArray(dateFormat, replaceTableData);
		var dateValue = this.obj.value.match(new RegExp(dateRegExpString));
		dateValue = dateValue ? dateValue.toString() : '';

		//Time
		var replaceTableTime = [
			{s: /S/,  r: ''},
			{s: /-/, r: '<#HYPHEN#>'},
			{s: /\./, r: '<#POINT#>'},
			{s: /\//, r: '<#SLASH#>'},
			{s: /\\/, r: '<#BACKSLASH#>'},
			{s: /\ /, r: '<#SPACE#>'},
			{s: /\$/, r: '<#DOLLAR#>'},
			{s: /hh/, r: '\\d{1,2}'},
			{s: /h/,  r: '\\d{1,2}'},
			{s: /HH/, r: '\\d{1,2}'},
			{s: /H/,  r: '\\d{1,2}'},
			{s: /mm/, r: '\\d{1,2}'},
			{s: /m/,  r: '\\d{1,2}'},
			{s: /ss/, r: '\\d{1,2}'},
			{s: /s/,  r: '\\d{1,2}'},
			{s: /tt/,  r: '\\w+'},
			{s: /<#DOLLAR#>/, r: '\\$'},
			{s: /<#SPACE#>/, r: '\\ '},
			{s: /<#BACKSLASH#>/, r: '\\\\'},
			{s: /<#SLASH#>/, r: '\/'},
			{s: /<#POINT#>/, r: '\.'},
			{s: /<#HYPHEN#>/, r: '\-'}
		];		
		
		var timeRegExpString = string.replaceAllFromArray(timeFormat, replaceTableTime);
		var timeValue = this.obj.value.match(new RegExp(timeRegExpString));
		timeValue = timeValue ? timeValue.toString() : '';
		
		var timeTypeIsValid = ($.datepicker.parseTime(timeFormat, timeValue, null) == false) ? false : true ;
		var dateTypeIsValid = this.validateDateType(dateFormat, dateValue, this.options.localization.date);

		
		if (!dateTypeIsValid || !timeTypeIsValid) {
			var errorMessage = (typeof(this.options.typeErrorMessage) != 'undefined') ? this.options.typeErrorMessage : this.options.message.dateInvalid;
			this.errorMessages.push(errorMessage); 
			return false;		
		}
		
		
		//rules validation
		var oDate = this.getDate(dateFormat, dateValue, this.options.localization.date);
		var oTime = $.datepicker.parseTime(timeFormat, timeValue, null);
		var value = oDate; jQuery.extend(value, oTime);
		
		vResult = validationRulesProcessor.validate(value, this.options.validationRules);
		if (vResult.valid) return true;
		else {
			this.errorMessages = vResult.errorMessages; 
			return false;
		}
		
    };
	
	this.validateDateType = function(format, value, settings){
		
		var date = this.getDate(format, value, settings);
		if (typeof(date) != 'object') return false;
		return true;
		
	};
	
	this.getDate = function(format, value, settings){
	
		if (format == null || value == null) return null;
		
		value = (typeof value == 'object' ? value.toString() : value + '');
		if (value == '') return null;
		
		var shortYearCutoff = (settings ? settings.shortYearCutoff : null) || this.options.localization.date.shortYearCutoff;
		shortYearCutoff = (typeof shortYearCutoff != 'string' ? shortYearCutoff : new Date().getFullYear() % 100 + parseInt(shortYearCutoff, 10));

		var dayNamesShort = (settings ? settings.dayNamesShort : null) || this.options.localization.date.dayNamesShort;
		var dayNames = (settings ? settings.dayNames : null) || this.options.localization.date.dayNames;
		var monthNamesShort = (settings ? settings.monthNamesShort : null) || this.options.localization.date.monthNamesShort;
		var monthNames = (settings ? settings.monthNames : null) || this.options.localization.date.monthNames;
		var year = -1;
		var month = -1;
		var day = -1;
		var doy = -1;
		var literal = false;
		
		// Check whether a format character is doubled
		var lookAhead = function(match) {
			var matches = (iFormat + 1 < format.length && format.charAt(iFormat + 1) == match);
			if (matches)
				iFormat++;
			return matches;
		};
		// Extract a number from the string value
		var getNumber = function(match) {
			var isDoubled = lookAhead(match);
			var size = (match == '@' ? 14 : (match == '!' ? 20 :
				(match == 'y' && isDoubled ? 4 : (match == 'o' ? 3 : 2))));
			var digits = new RegExp('^\\d{1,' + size + '}');
			var num = value.substring(iValue).match(digits);
			if (!num) return false;
			iValue += num[0].length;
			return parseInt(num[0], 10);
		};
		// Extract a name from the string value and convert to an index
		var getName = function(match, shortNames, longNames) {
			var names = $.map(lookAhead(match) ? longNames : shortNames, function (v, k) {
				return [ [k, v] ];
			}).sort(function (a, b) {
				return -(a[1].length - b[1].length);
			});
			var index = -1;
			$.each(names, function (i, pair) {
				var name = pair[1];
				if (value.substr(iValue, name.length).toLowerCase() == name.toLowerCase()) {
					index = pair[0];
					iValue += name.length;
					return false;
				}
			});
			if (index != -1)
				return index + 1;
			else
				return false;
		};
		// Confirm that a literal character matches the string value
		var checkLiteral = function() {
			if (value.charAt(iValue) != format.charAt(iFormat)) return false;
			iValue++;
		};
		
		var getDaysInMonth = function(year, month) {
			return 32 - this._daylightSavingAdjust(new Date(year, month, 32)).getDate();
		};
		
		var daylightSavingAdjust = function(date) {
			if (!date) return null;
			date.setHours(date.getHours() > 12 ? date.getHours() + 2 : 0);
			return date;
		};
		
		var iValue = 0;
		for (var iFormat = 0; iFormat < format.length; iFormat++) {
			
			if (literal) {
				if (format.charAt(iFormat) == "'" && !lookAhead("'"))
					literal = false;
				else
					if (!checkLiteral()) return false;
			}
			else {
				switch (format.charAt(iFormat)) {
					case 'd':
						day = getNumber('d');
						break;
					case 'D':
						getName('D', dayNamesShort, dayNames);
						break;
					case 'o':
						doy = getNumber('o');
						break;
					case 'm':
						month = getNumber('m');
						break;
					case 'M':
						month = getName('M', monthNamesShort, monthNames);
						break;
					case 'y':
						year = getNumber('y');
						break;
					case '@':
						var date = new Date(getNumber('@'));
						year = date.getFullYear();
						month = date.getMonth() + 1;
						day = date.getDate();
						break;
					case '!':
						var date = new Date((getNumber('!') - this._ticksTo1970) / 10000);
						year = date.getFullYear();
						month = date.getMonth() + 1;
						day = date.getDate();
						break;
					case "'":
						if (lookAhead("'"))
							checkLiteral();
						else
							literal = true;
						break;
					default:
						checkLiteral();
				}
			}	
		}
		
		if (iValue < value.length){ //Extra/unparsed characters found in date
			return false;
		}
		if (year == -1)
			year = new Date().getFullYear();
		else if (year < 100)
			year += new Date().getFullYear() - new Date().getFullYear() % 100 +	(year <= shortYearCutoff ? 0 : -100);
				
		if (doy > -1) {
			month = 1;
			day = doy;
			do {
				var dim = getDaysInMonth(year, month - 1);
				if (day <= dim)
					break;
				month++;
				day -= dim;
			} while (true);
		}
		
		var date = daylightSavingAdjust(new Date(year, month - 1, day));
		if (date.getFullYear() != year || date.getMonth() + 1 != month || date.getDate() != day) return false;
		
		return {year: year, month: month, day: day};
	};
	
    this.markLabelElement = function(){
        if (!form.c.isSkinning) jQuery(this.markObj).addClass(form.c.element.classNameByError);
        else {
            switch(this.type){
                case "string" :
                case "text" :
                case "email":
                case "pattern":
				case "date":
				case "coordinate":
				case "decimal":
				case "int":
				case "long":
				case "list:text":
				case "file":
				case "file-multiple":
                    jQuery(this.markObj).parents('.jqTransformInputWrapper').addClass(form.c.element.classNameByError);
                    break;
                case "textarea":
				case "longtext":
					jQuery(this.markObj).parents('.jqTransformTextarea').addClass(form.c.element.classNameByError);
                    break;
                case "select":
				case "list:select":
					jQuery(this.markObj).parents('.jqTransformSelectWrapper').addClass(form.c.element.classNameByError);
                    break;
                case "radio":
                case "checkbox":
				case "list:radio":
				case "list:checkbox":
				case "boolean":
                    jQuery(this.markObj).addClass(form.c.element.classNameByError);
                    break;
            }            
        }
		
		this.showMessage();
		
    };
	
    this.clearLabelElement = function(){
        if (!form.c.isSkinning) jQuery(this.markObj).removeClass(form.c.element.classNameByError);
        else {
            switch(this.type){
                case "string" :
                case "text" :
                case "email":
                case "pattern":
				case "date":
				case "coordinate":
				case "decimal":
				case "int":
				case "long":
				case "list:text":
				case "file":
				case "file-multiple":
                    jQuery(this.markObj).parents('.jqTransformInputWrapper').removeClass(form.c.element.classNameByError);
                    break;
                case "textarea":
				case "longtext":
                    jQuery(this.markObj).parents('.jqTransformTextarea').removeClass(form.c.element.classNameByError);
                    break;
                case "select":
				case "list:select":				
                    jQuery(this.markObj).parents('.jqTransformSelectWrapper').removeClass(form.c.element.classNameByError);
                    break;
                case "radio":
                case "checkbox":
				case "list:radio":
				case "list:checkbox":
				case "boolean":
                    jQuery(this.markObj).removeClass(form.c.element.classNameByError);
                    break;
            }
        }

		this.hideMessage();		
    };
	
	this.showMessage = function(){

		this.hideMessage();
		
		var message = '';
		for (var i=0; i<this.errorMessages.length; i++){
			message += this.errorMessages[i] + '<br/>';
		}
		var messageElement = string.replaceAll(this.options.markup.errorMessage, /<#error-message#>/ , message);
		
		jQuery(this.options.errorMessageContainer).append(messageElement);
	};
	
	this.hideMessage = function(){
		jQuery(this.options.errorMessageContainer).find('*').remove();
	};
	
	
    if (this.obj) return this;
    else return false;
}


function DependenciesProcessor(selector, elementType, dependencies){

	this.selector = selector;
	this.elementType = elementType;
	this.dependencies = dependencies;
	
	this.init = function(){
		
		var self = this;
		
		switch (elementType) {
			
			case "radio":
			case "list:radio":
				var jMaster = jQuery('input[type="radio"][name="'+this.selector+'"]');
			break;
			
			default:
				var jMaster = jQuery(this.selector);
			break;
			
		}
		
		jMaster.on('change', function(){

			for (var i in self.dependencies) {
				
				switch (self.dependencies[i].type) {
					case 'visibility':

						//set default state
						self.changeSlaveState(self.dependencies[i].slaveSelector,self.dependencies[i].defaultSlaveState);

						for (var dataIndex in self.dependencies[i].data) {
						
							if (typeof(self.dependencies[i].data[dataIndex].masterValue) != 'object') {
								self.dependencies[i].data[dataIndex].masterValue = new Array(self.dependencies[i].data[dataIndex].masterValue);
							}
							
							switch (self.elementType) {
								case "radio":
								case "list:radio":
									if ((this.checked) && (jQuery.inArray(this.value, self.dependencies[i].data[dataIndex].masterValue) != -1))
										self.changeSlaveState(self.dependencies[i].slaveSelector, self.dependencies[i].data[dataIndex].slaveState);
								break;
								case "checkbox":
								case "list:checkbox":
								case "boolean":
									var value = (this.checked) ? this.value : '';
									if (jQuery.inArray(value, self.dependencies[i].data[dataIndex].masterValue) != -1)
										self.changeSlaveState(self.dependencies[i].slaveSelector, self.dependencies[i].data[dataIndex].slaveState);
								break;
								default:
									if (jQuery.inArray(this.value,self.dependencies[i].data[dataIndex].masterValue) != -1) 
										self.changeSlaveState(self.dependencies[i].slaveSelector, self.dependencies[i].data[dataIndex].slaveState);
								break;
							}
							
						}
					
					
					break;
					
					case 'changeValue':

						for (var dataIndex in self.dependencies[i].data) {

							if (typeof(self.dependencies[i].data[dataIndex].masterValue) != 'object') {
								self.dependencies[i].data[dataIndex].masterValue = new Array(self.dependencies[i].data[dataIndex].masterValue);
							}
							
							switch (self.elementType) {
								case "radio":
								case "list:radio":
									if ((this.checked) && (jQuery.inArray(this.value, self.dependencies[i].data[dataIndex].masterValue) != -1 ))
										self.changeSlaveValue(self.dependencies[i].slaveSelector, self.dependencies[i].slaveType, self.dependencies[i].data[dataIndex]);
								break;
								case "checkbox":
								case "list:checkbox":
								case "boolean":
									var value = (this.checked) ? this.value : '';
									if (jQuery.inArray(value, self.dependencies[i].data[dataIndex].masterValue) != -1)
										self.changeSlaveValue(self.dependencies[i].slaveSelector, self.dependencies[i].slaveType, self.dependencies[i].data[dataIndex]);
								break;
								default:
									if (jQuery.inArray(this.value, self.dependencies[i].data[dataIndex].masterValue) != -1) 
										self.changeSlaveValue(self.dependencies[i].slaveSelector, self.dependencies[i].slaveType, self.dependencies[i].data[dataIndex]);
								break;
							}

						}
						
					break;
					
					case 'changeValueSet':
						
						for (var dataIndex in self.dependencies[i].data) {

							if (typeof(self.dependencies[i].data[dataIndex].masterValue) != 'object') {
								self.dependencies[i].data[dataIndex].masterValue = new Array(self.dependencies[i].data[dataIndex].masterValue);
							}
							
							if ((jQuery.inArray(this.value, self.dependencies[i].data[dataIndex].masterValue) != -1) && (this.checked)) {
								self.changeSlaveValueSet(self.dependencies[i].slaveSelector, self.dependencies[i].slaveType, self.dependencies[i].data[dataIndex].slaveSet);
							}
						}
						
					break;
				}				
				
				
			}
		
		});
		
		jQuery(document).ready(function(){
			switch (self.elementType) {
				case 'radio':
				case "list:radio":
					var jMaster = jQuery('input[type="radio"][name="'+self.selector+'"]');
					var isChecked = false;
					for (var i=0;i<jMaster.length;i++){
						if (jMaster.get(i).checked) {
							jQuery(jMaster.get(i)).change();
							isChecked = true;
						}
					}
					if ((!isChecked) && (jMaster.length>=1)) jQuery(jMaster.get(0)).change();
				break;
				default:
					var jMaster = jQuery(self.selector);
					jMaster.change();
				break;
			}		
			
		});
		
	};
	
	this.changeSlaveState = function(slaveSelector, slaveState){
		
		if ((typeof(slaveState) != 'object') && (typeof(slaveState) != 'array')) return;
		
		for (var stateIndex in slaveState) {
			
			var state = slaveState[stateIndex];
			
			for (var propertyName in state) {
				
				switch (propertyName) {
					case 'display':
						jQuery(slaveSelector).css('display', state[propertyName]);
					break;
					case 'readonly':
						if (state[propertyName] == 'true') jQuery(slaveSelector).attr('readonly','readonly');
						else jQuery(slaveSelector).removeAttr('readonly');
					break;
					case 'disabled':
						if (state[propertyName] == 'true') jQuery(slaveSelector).attr('disabled','disabled');
						else jQuery(slaveSelector).removeAttr('disabled');
					break;
				
				}
			}
		}
	};
	
	this.changeSlaveValue = function(slaveSelector, slaveType, data){
		
		switch (slaveType) {
			
			case "text": 
			case "string":
			case "email":
			case "date":
			case "textarea": 
			case "pattern":
			case "coordinate":
			case "decimal":
			case "int":
			case "long":
			case "list:text":
			case "longtext":
			    var currentValue = jQuery(slaveSelector).val();
			    if (currentValue != data.slaveValue){
			     jQuery(slaveSelector).val(data.slaveValue).trigger('change').trigger('blur');
			    }
			break;
			
			case "radio":
			case "list:radio":
				jQuery('input[type="radio"][name="'+slaveSelector+'"]').each(function(){
					if ((this.value == data.slaveValue) && !this.checked) {
					   this.checked = true;
					   jQuery(this).trigger('change').trigger('blur');
					}
				});
			break;
		
			case "select":
			case "list:select":
				jQuery(slaveSelector).each(function(){
					var selectedIndex = null;
					for (var i=0; i<this.options.length; i++) {
						if (this.options[i].value == data.slaveValue) selectedIndex = i;
					}
					if ((selectedIndex != null) && (this.selectedIndex != selectedIndex)) {
					   this.selectedIndex = selectedIndex;
					   jQuery(this).trigger('change').trigger('blur');
					}
				});
			break;
			
			case "checkbox":
			case "list:checkbox":
			case "boolean":
				jQuery(slaveSelector).each(function(){
					if (data.slaveValue == 'checked') {
					   if(!this.checked) {
					       this.checked = true;
					       jQuery(this).trigger('change').trigger('blur');
					   }
					} else {
					   if(this.checked) {
					       this.checked = false;
					       jQuery(this).trigger('change').trigger('blur');
					   }
					}
				});
			break;
		
		}
		
	};
	
	this.changeSlaveValueSet = function(slaveSelector, slaveType, slaveSet) {

		switch (slaveType) {
			case "select":
			case "list:select":
				jQuery(slaveSelector).each(function(){
					
					while (this.options.length != 0) {
						this.options[0] = null;
					}
					for (var i in slaveSet) {
						jQuery(this).append(slaveSet[i]);
					}

				});			
			break;
		}
	
	}
	
	this.init();
	
	return this;
};

function formGroup(form, groupName, mandatory, rule){
	
	this.form = form;
	this.classNameByError = form.c.element.classNameByError;
	this.element = new Array();
	this.groupName = null;
	this.mandatory = false;
	this.rule = null;
	this.selectorMarkContainer = form.c.element.selectorMarkContainer;
	
	this.init = function(groupName, mandatory, rule){
		this.groupName = groupName;
		this.mandatory = mandatory;
		this.rule = rule;
	};
	
	this.addElement = function(selector, type, options){

        var pattern = null;

        type = (type.substr(0,1) == "/") ? eval(type) : type; 
        var typeOfType = typeof type;

        if ((typeOfType.toLowerCase() == "object") || (typeOfType.toLowerCase() == "function")) {
            pattern = type;
            type = 'pattern';
        }

		var mandatory = (typeof(options.mandatory)!='undefined') ? options.mandatory : false;
		
        var element = new formElement(this.form, selector, type, mandatory, pattern, options);
        if (element) this.element.push(element);
		
		return element;
		
	};
	
	this.isValid = function(){
		
		if (this.mandatory == false) return true;
		
		if (this.rule == 'AND') {

			var valid = true;
			if (this.element != null)
				for(var i=0; i < this.element.length; i++){
					if ((this.element[i].options.mandatory == true) && (this.element[i].isValid() == false)) valid = false;
				}
		
		} else { //OR
		
			var valid = false;
			if (this.element != null)
				for(var i=0; i < this.element.length; i++){
					if ((this.element[i].options.mandatory == true) && (this.element[i].isValid() == true)) valid = true;
				}
		}

		return valid;

	};
	
	this.markGroupContainer = function(){
		jQuery(this.selectorMarkContainer+'.'+this.groupName).addClass(this.classNameByError);
	};

	this.clearGroupContainer = function(){
		jQuery(this.selectorMarkContainer+'.'+this.groupName).removeClass(this.classNameByError);
	};
	
	
	this.checkGroup = function(){
		
		var valid = this.isValid();

		if ( valid == false)  this.markGroupContainer();
		else this.clearGroupContainer();
		
		return valid;
	}
	
	
	this.init(groupName, mandatory, rule);
};

var validationRulesProcessor = {

	validate: function(value, validationRules) {
		
		var valid = true;
		var errorMessages = new Array();

		var vResult = {};
		
		for(var i=0; i<validationRules.length; i++){
			vResult = this.validateValue(value, validationRules[i].type, validationRules[i].errorMessage, validationRules[i].options);
			if (!vResult.valid) {
				valid = false;
				errorMessages.push(vResult.errorMessage);
			}
		}
		
		return {valid: valid, errorMessages: errorMessages};
		
	},
	
	validateValue: function(value, type, errorMessage, options){
		
		var valid = true;
		var message = null;
		
		switch (type.toLowerCase()) {
			
			case "notnull":
				if (value == '') {
					valid = false;
					message = errorMessage;
				}
			break;
			
			case "fileupload":
				if (typeof(options.fileTypes) != 'undefined') {
					var fileTypes = options.fileTypes.toLowerCase().replace(/ /g,'').split(',');
					var fileExt = value.slice(value.lastIndexOf('.')+1, value.length).toLowerCase();
					if (jQuery.inArray(fileExt,fileTypes) == -1) {
						valid = false;
						message = errorMessage;
					}
				}
			break;
			
			case "email":
				if ((value == null) || !(value.search(/[@.]/) >= 0) || !(value.search(/.+@..+\...+/) >= 0) || !(value.length >= 8)) {
					valid = false;
					message = errorMessage;
				}
			break;
			
			case "size":
				if ((value.length < parseInt(options.min)) || (value.length > parseInt(options.max))) {
					valid = false;
					message = errorMessage;
				}
			break;
			
			case "min":
				if (parseFloat(value) < parseFloat(options.value)){
					valid = false;
					message = errorMessage;
				}
			break;
			
			case "max":
				if (parseFloat(value) > parseFloat(options.value)){
					valid = false;
					message = errorMessage;
				}
			break;

			case "pattern":
				var pattern = new RegExp(options.regexp);
				if (!pattern.test(value)) {
					valid = false;
					message = errorMessage;
				}
			break;
			
			case "future":
				var current = new Date();
				current = Date.UTC(current.getFullYear(), current.getMonth(), current.getDate(), current.getHours(), current.getMinutes(), current.getSeconds());
				value = Date.UTC(value.year,(value.month-1),value.day,value.hour,value.minute,value.second);
				
				if (value <= current) {
					valid = false;
					message = errorMessage;
				}
			break;
			
			case "past":
				var current = new Date();
				current = Date.UTC(current.getFullYear(), current.getMonth(), current.getDate(), current.getHours(), current.getMinutes(), current.getSeconds());
				value = Date.UTC(value.year,(value.month-1),value.day,value.hour,value.minute,value.second);
				
				if (value >= current) {
					valid = false;
					message = errorMessage;
				}			
			break;
			
			case "digits":
				
				var intRegex = /^[\+|-]{0,1}\d+[.]{0,1}\d+$/;
				value = value.toString();
				
				if (!intRegex.test(value)) {
					valid = false;
					message = errorMessage;
				} else {
					numberPart = value.split('.');
					if (numberPart[0].length > parseInt(options.integer)) {
						valid = false;
						message = errorMessage;
					} else if ((typeof(numberPart[1]) != 'undefined' ) && (numberPart[1].length>parseInt(options.fraction))) {
						valid = false;
						message = errorMessage;
					}
					
				}
				
			break;
		}
		
		
		return {valid: valid, errorMessage: message};
	}
};