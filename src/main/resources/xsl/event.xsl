<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
	xmlns="http://www.appng.org/schema/platform" xmlns:ait="http://aiticon.de" xmlns:appng="http://appng.org"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc"
	xpath-default-namespace="http://www.appng.org/schema/platform">

	<xd:doc>
		<xd:short>Generic action template which is generally processed first</xd:short>
		<xd:detail>
			Outputs the basic html structure of a action, containing title and content container who can be foldable via slideBox JS.
			Further action content assembly is controlled by a mode specific action template.
			
			For convenience following tunnel parameters are assigned to the further action template:
			<ul>
				<li>action-id - ID</li>
				<li>action-config - Config node tree</li>
				<li>action-data - Data node tree</li>
				<li>action-mode - Display mode</li>
			</ul>
		</xd:detail>
	</xd:doc>
	<xsl:template match="element/action" priority="2.5">
		<xsl:param name="tab-id" tunnel="yes"/>
		
		<xsl:param name="action-id" select="@id" as="xs:string"/>
		<xsl:param name="action-config" select="config" as="element(config)"/>
		<xsl:param name="action-data" select="data" as="element(data)?"/>
		<xsl:param name="action-userdata" select="userdata" as="element(userdata)?"/>
		<xsl:param name="action-mode" select="if (@mode) then @mode else 'form'" as="xs:string"/>
		<xsl:param name="action-clientvalidation" select="if (@clientValidation eq 'false') then false() else true()" as="xs:boolean"/>
		<xsl:param name="action-htmlid" select="string-join(('action',replace($action-id,'[\._-]','')),'_')" as="xs:string"/>
		<xsl:param name="action-js-localization">
			localization: {
			number: {
			format: '#,###.##',
			groupingSeparator: '<xsl:value-of select="$subject/localization/groupingSeparator"/>',
			decimalSeparator: '<xsl:value-of select="$subject/localization/decimalSeparator"/>'
			}
			}</xsl:param>

		<xsl:choose>
			<xsl:when test="$action-mode eq 'form'">
				<xsl:apply-templates select="." mode="form">
					<xsl:with-param name="action-id" select="$action-id" tunnel="yes"/>
					<xsl:with-param name="action-config" select="$action-config" tunnel="yes"/>
					<xsl:with-param name="action-action" select="$action-id" tunnel="yes"/>
					<xsl:with-param name="action-data" select="$action-data" tunnel="yes"/>
					<xsl:with-param name="action-userdata" select="$action-userdata" tunnel="yes"/>
					<xsl:with-param name="action-mode" select="$action-mode" tunnel="yes"/>
					<xsl:with-param name="action-clientvalidation" select="$action-clientvalidation" tunnel="yes"/>
					<xsl:with-param name="action-htmlid" select="$action-htmlid" tunnel="yes"/>
					<xsl:with-param name="action-js-localization" select="$action-js-localization" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$action-mode eq 'custom'">
				<xsl:apply-templates select="." mode="custom">
					<xsl:with-param name="action-id" select="$action-id" tunnel="yes"/>
					<xsl:with-param name="action-config" select="$action-config" tunnel="yes"/>
					<xsl:with-param name="action-action" select="$action-id" tunnel="yes"/>
					<xsl:with-param name="action-data" select="$action-data" tunnel="yes"/>
					<xsl:with-param name="action-userdata" select="$action-userdata" tunnel="yes"/>
					<xsl:with-param name="action-mode" select="$action-mode" tunnel="yes"/>
					<xsl:with-param name="action-clientvalidation" select="$action-clientvalidation" tunnel="yes"/>
					<xsl:with-param name="action-htmlid" select="$action-htmlid" tunnel="yes"/>
					<xsl:with-param name="action-js-localization" select="$action-js-localization" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="form">
					<xsl:with-param name="action-id" select="$action-id" tunnel="yes"/>
					<xsl:with-param name="action-config" select="$action-config" tunnel="yes"/>
					<xsl:with-param name="action-action" select="$action-id" tunnel="yes"/>
					<xsl:with-param name="action-data" select="$action-data" tunnel="yes"/>
					<xsl:with-param name="action-userdata" select="$action-userdata" tunnel="yes"/>
					<xsl:with-param name="action-mode" select="$action-mode" tunnel="yes"/>
					<xsl:with-param name="action-clientvalidation" select="$action-clientvalidation" tunnel="yes"/>
					<xsl:with-param name="action-htmlid" select="$action-htmlid" tunnel="yes"/>
					<xsl:with-param name="action-js-localization" select="$action-js-localization" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="element/action" priority="-2.5" mode="#all">
		<xsl:param name="tab-id" tunnel="yes"/>
		<xsl:param name="action-id" tunnel="yes"/>
		<xsl:param name="action-action" tunnel="yes"/>
		<xsl:param name="action-config" tunnel="yes"/>
		<xsl:param name="action-data" tunnel="yes"/>
		<xsl:param name="action-userdata" tunnel="yes"/>
		<xsl:param name="action-clientvalidation" tunnel="yes"/>
		<xsl:param name="action-htmlid" tunnel="yes"/>
		<xsl:param name="action-js-localization" tunnel="yes"/>

		<xsl:apply-templates select="$action-config/description"/>
		<form action="#{$tab-id}" enctype="multipart/form-data" method="post" id="{$action-htmlid}" name="{$action-id}" onsubmit="return FormJS_{$action-htmlid}.validateForm();">
			<script type="text/javascript" language="javascript">
				if (typeof(formsArr) == 'undefined') var formsArr = new Array();
				var FormJS_<xsl:value-of select="$action-htmlid"/> = new form('form[name="<xsl:value-of select="$action-id"/>"]', {<xsl:value-of select="$action-js-localization"/>});
			</script>
			
			<input name="form_action" type="hidden" value="{$action-action}"/>
			
			<xsl:apply-templates select="$action-data" mode="#current"/>
			
			<xsl:choose>
				<xsl:when test="$action-config/linkpanel">
					<xsl:apply-templates select="$action-config/linkpanel" mode="#current"/>
				</xsl:when>
				<xsl:otherwise>
					<div class="buttons_panel">
						<div class="center">
							<a class="btn_save" href="javascript:void(0)"
								onclick="return app.submitForm('{$action-htmlid}')">
								<xsl:value-of select="appng:search-label('submit',$action-config)"/>
							</a>
							<a class="btn_reset" href="javascript:void(0)"
								onclick="return app.resetForm('{$action-htmlid}')">
								<xsl:value-of select="appng:search-label('reset',$action-config)"/>
							</a>
						</div>
						<p class="clr">&#160;</p>
					</div>
				</xsl:otherwise>
			</xsl:choose>
			<script type="text/javascript" language="javascript">
				formsArr.push(FormJS_<xsl:value-of select="$action-htmlid"/>);
			</script>
			<xsl:call-template name="add-csrf-token"/>
		</form>
	
	</xsl:template>

	<xsl:template name="add-csrf-token">
		<xsl:if test="$application-config/session//session-param[@name='_csrf']">
			<input type="hidden" name="_csrf" value="{$application-config/session//session-param[@name='_csrf']}"/>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/data" priority="-2.5" mode="#all">
		<xsl:param name="action-config" tunnel="yes"/>
		<xsl:param name="action-data" tunnel="yes"/>
		
		<xsl:apply-templates select="$action-config/meta-data/field" mode="#current"/>
	</xsl:template>

	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field" priority="2.5" mode="#all">
		<xsl:param name="action-id" tunnel="yes"/>
		<xsl:param name="action-htmlid" tunnel="yes"/>
		<xsl:param name="action-config" tunnel="yes"/>
		<xsl:param name="action-data" tunnel="yes"/>
		<xsl:param name="action-userdata" tunnel="yes"/>
		<xsl:param name="action-validation" tunnel="yes"/>
		
		<xsl:param name="absolutepos" as="xs:string"><xsl:number count="field" level="single"/></xsl:param>
		
		<xsl:param name="field" select="." as="element(*)"/>
		<xsl:param name="field-name" select="$field/@name" as="xs:string"/>
		<xsl:param name="field-htmlid" select="string-join(('field',replace(replace($field-name,'[\._-]',''),'[\[\]]','_'),$absolutepos),'_')" as="xs:string"/>
		<xsl:param name="field-binding" select="$field/@binding" as="xs:string"/>
		<xsl:param name="field-hidden" select="if ($field/@hidden eq 'true') then true() else false()" as="xs:boolean"/>
		<xsl:param name="field-readonly" select="($field/@readonly,false())[1]" as="xs:boolean"/>
		<xsl:param name="field-value" select="if ($action-userdata/input[@name eq $field-binding])
			then $action-userdata/input[@name eq $field-binding]  
			else $action-data/result//field[@name eq $field-name]/value"/>
		<xsl:param name="field-type" select="if ($field/@type ne '') then $field/@type else 'text'" as="xs:string"/>
		<xsl:param name="field-selected" select="if ($field-value = 'true') then true() else false()" as="xs:boolean"/>
		<xsl:param name="field-attributes">
			<xsl:if test="$field/@autosubmit eq 'true'">
				<attribute name="onchange" value="javascript:void(0);return app.submitForm('form_{$action-id}');"/>
			</xsl:if>
			<xsl:if test="$field/validation/size/@max">
				<attribute name="maxlength" value="{$field/validation/size/@max}"/>
			</xsl:if>
		</xsl:param>
		<xsl:param name="field-format" select="$field/@format" as="xs:string?"/>
		<xsl:param name="field-options"/>
		<xsl:param name="field-css-error" select="if ($field/messages/message[@class eq 'ERROR']) then 'error' else ''" as="xs:string"/>
		<xsl:param name="field-css-readonly" select="if ($field-readonly) then 'disabled' else ''" as="xs:string"/>
		<xsl:param name="field-css" select="string-join( ($field-type,$field-css-readonly,$field-css-error),' ' )" as="xs:string"/>
		<xsl:param name="field-validation" select="$field/validation" as="element(validation)?"/>

		<xsl:next-match>
			<xsl:with-param name="field" select="$field" tunnel="yes"/>
			<xsl:with-param name="field-name" select="$field-name" tunnel="yes"/>
			<xsl:with-param name="field-htmlid" select="$field-htmlid" tunnel="yes"/>
			<xsl:with-param name="field-binding" select="$field-binding" tunnel="yes"/>
			<xsl:with-param name="field-hidden" select="$field-hidden" tunnel="yes"/>
			<xsl:with-param name="field-readonly" select="$field-readonly" tunnel="yes"/>
			<xsl:with-param name="field-value" select="$field-value" tunnel="yes"/>
			<xsl:with-param name="field-type" select="$field-type" tunnel="yes"/>
			<xsl:with-param name="field-selected" select="$field-selected" tunnel="yes"/>
			<xsl:with-param name="field-attributes" select="$field-attributes" tunnel="yes"/>
			<xsl:with-param name="field-format" select="$field-format" tunnel="yes"/>
			<xsl:with-param name="field-options" select="$field-options" tunnel="yes"/>
			<xsl:with-param name="field-css-error" select="$field-css-error" tunnel="yes"/>
			<xsl:with-param name="field-css-readonly" select="$field-css-readonly" tunnel="yes"/>
			<xsl:with-param name="field-css" select="$field-css" tunnel="yes"/>
			<xsl:with-param name="field-validation" select="$field-validation" tunnel="yes"/>
		</xsl:next-match>
	</xsl:template>
	<xd:doc>
		<xd:short>
			Field decorator template, assemblies a fieldcontainer, containing label, field and messages
		</xd:short>
		<xd:detail>
			Fieldcontainer is only displayed when action has no result (create formular) 
			or result contains field which matchs to the meta-field 
		</xd:detail>
	</xd:doc>
	<xsl:template match="action/config/meta-data//field" priority="1.25" mode="form">
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-hidden" tunnel="yes"/>
		<xsl:param name="field-type" tunnel="yes"/>
		<xsl:param name="field-name" tunnel="yes"/>
		<xsl:param name="action-data" tunnel="yes"/>

		<xsl:if test="$action-data/result//field[@name eq $field-name] or not($action-data/result)">
			<div class="fieldcontainer {$field-htmlid}">
				<xsl:if test="not($field-hidden) and $field-type ne 'checkbox'">
					<xsl:apply-templates select="label" mode="#current"/>
				</xsl:if>
				<div class="field">
					<xsl:next-match/>
				</div>
				<xsl:apply-templates select="messages" mode="#current"/>
			</div>
		</xsl:if>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@hidden eq 'true' and not(contains(@type,'list:'))]" priority="1.2" mode="form">
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-selected" tunnel="yes"/>
		<xsl:param name="field-binding" tunnel="yes"/>
		
		<input id="{$field-htmlid}" name="{$field-binding}" type="hidden" value="{$field-value}">
			<xsl:if test="$field-selected">
				<xsl:attribute name="checked" select="'checked'"/>
			</xsl:if>
		</input>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@readonly eq 'true' and not(contains(@type,'list:')) and not(@type eq 'richtext') and not(@type eq 'checkbox')]" priority="1.1" mode="form">
		<xsl:param name="field-value" tunnel="yes"/>
		<div class="readonly">
			<xsl:apply-templates select="$field-value"/>
		</div>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type eq 'checkbox']" priority="-1.5" mode="form">
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-readonly" tunnel="yes"/>
		<xsl:param name="field-css" tunnel="yes"/>
		<xsl:param name="field-binding" tunnel="yes"/>
		<xsl:param name="field-type" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-selected" tunnel="yes"/>
		<xsl:param name="field-attributes" tunnel="yes"/>
		
		<ul>
			<li>
				<input class="{$field-css}"	id="{$field-htmlid}" name="{$field-binding}" type="{$field-type}" value="true">
					<xsl:if test="$field-selected">
						<xsl:attribute name="checked" select="'checked'"/>
					</xsl:if>
					<xsl:if test="$field-readonly">
						<xsl:attribute name="disabled" select="'disabled'"/>
						<xsl:attribute name="readonly" select="'readonly'"/>
					</xsl:if>
					<xsl:for-each select="$field-attributes/attribute">
						<xsl:attribute name="{@name}" select="@value"/>
					</xsl:for-each>
				</input>
				<xsl:apply-templates select="label" mode="#current"/>
				<p class="clr"></p>
			</li>
		</ul>
		<xsl:apply-templates select="." mode="js-validation"/>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type eq 'longtext']" priority="-1.5" mode="form">
		<xsl:param name="field" tunnel="yes"/>
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-readonly" tunnel="yes"/>
		<xsl:param name="field-binding" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-format" tunnel="yes"/>
		<xsl:param name="field-attributes" tunnel="yes"/>
		<xsl:param name="field-css-error" tunnel="yes"/>
		<xsl:param name="field-css-readonly" tunnel="yes"/>
		
		<xsl:param name="field-css" select="normalize-space(string-join( ('text',replace($field-format,'auto','autosize'),$field-css-readonly,$field-css-error),' ' ))" as="xs:string"/>
		
		<textarea class="{$field-css}" id="{$field-htmlid}" name="{$field-binding}">
			<xsl:if test="$field-readonly">
				<xsl:attribute name="disabled" select="'disabled'"/>
				<xsl:attribute name="readonly" select="'readonly'"/>
			</xsl:if>
			<xsl:for-each select="$field-attributes/attribute">
				<xsl:attribute name="{@name}" select="@value"/>
			</xsl:for-each>
			<xsl:apply-templates select="$field-value" />
		</textarea>
		<xsl:apply-templates select="." mode="js-validation"/>
	</xsl:template>	
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type = ('file','file-multiple')]" priority="-1.5" mode="form">
		<xsl:param name="field" tunnel="yes"/>
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-readonly" tunnel="yes"/>
		<xsl:param name="field-css" tunnel="yes"/>
		<xsl:param name="field-binding" tunnel="yes"/>
		<xsl:param name="field-type" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-attributes" tunnel="yes"/>
		
		<input class="{$field-css}" id="{$field-htmlid}" name="{$field-binding}" type="file" value="{$field-value}">
			<xsl:if test="$field-readonly">
				<xsl:attribute name="disabled" select="'disabled'"/>
				<xsl:attribute name="readonly" select="'readonly'"/>
			</xsl:if>
			<xsl:if test="$field-type eq 'file-multiple'">
				<xsl:attribute name="multiple" select="'multiple'"/>
			</xsl:if>
			<xsl:for-each select="$field-attributes/attribute">
				<xsl:attribute name="{@name}" select="@value"/>
			</xsl:for-each>
			<xsl:if test="$field/@format ne ''">
				<xsl:attribute name="accept" select="$field/@format"/>
			</xsl:if>
		</input>
		<xsl:apply-templates select="." mode="js-validation"/>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type = ('list:radio','list:checkbox','list:text')]" priority="-1.5" mode="form">
		<xsl:param name="action-data" tunnel="yes"/>
		
		<xsl:param name="field" tunnel="yes"/>
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-name" tunnel="yes"/>
		<xsl:param name="field-readonly" tunnel="yes"/>
		<xsl:param name="field-binding" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-selected" tunnel="yes"/>
		<xsl:param name="field-attributes" tunnel="yes"/>
		<xsl:param name="field-css-error" tunnel="yes"/>
		<xsl:param name="field-css-readonly" tunnel="yes"/>

		<xsl:param name="field-type" select="substring-after($field/@type,'list:')" as="xs:string"/>
		<xsl:param name="field-css" select="string-join( ($field-type,$field-css-readonly,$field-css-error),' ' )" as="xs:string"/>
		
		<ul>
			<xsl:for-each select="$action-data/selection[@id eq $field-name]/option">
				<li>
					<input class="{$field-css}"	id="{$field-htmlid}_{position()}" name="{$field-binding}" type="{$field-type}" value="{@value}">
						<xsl:if test="@selected eq 'true' and $field-type = ('radio','checkbox')">
							<xsl:attribute name="checked" select="'checked'"/>
						</xsl:if>
						<xsl:if test="$field-readonly">
							<xsl:attribute name="disabled" select="'disabled'"/>
							<xsl:attribute name="readonly" select="'readonly'"/>
						</xsl:if>
						<xsl:for-each select="$field-attributes/attribute">
							<xsl:attribute name="{@name}" select="@value"/>
						</xsl:for-each>
					</input>
					<label class="{$field-css}" for="{$field-htmlid}_{position()}">
						<xsl:apply-templates select="@name"/>
					</label>
					<p class="clr"></p>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type eq 'list:select']" priority="-1.5" mode="form">
		<xsl:param name="action-data" tunnel="yes"/>
		<xsl:param name="field-name" tunnel="yes"/>
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-readonly" tunnel="yes"/>
		<xsl:param name="field-binding" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-selected" tunnel="yes"/>
		<xsl:param name="field-attributes" tunnel="yes"/>
		<xsl:param name="field-css-error" tunnel="yes"/>
		<xsl:param name="field-css-readonly" tunnel="yes"/>
		
		<xsl:param name="field-type" select="if ($action-data/selection[@id eq $field-name]/@type eq 'select:multiple') 
			then 'select-multiple' else 'select'" as="xs:string"/>
		<xsl:param name="field-css" select="string-join( ($field-type,$field-css-readonly,$field-css-error),' ' )" as="xs:string"/>
		
		<div id="multiple_{$field-htmlid}">
			<select class="{$field-css}" id="{$field-htmlid}" name="{$field-binding}">
				<xsl:if test="$field-type eq 'select-multiple'">
					<xsl:attribute name="multiple" select="'multiple'"/>
				</xsl:if>
				<xsl:if test="$field-readonly">
					<xsl:attribute name="disabled" select="'disabled'"/>
					<xsl:attribute name="readonly" select="'readonly'"/>
				</xsl:if>
				<xsl:for-each select="$field-attributes/attribute">
					<xsl:attribute name="{@name}" select="@value"/>
				</xsl:for-each>
				<xsl:for-each select="$action-data/selection[@id eq $field-name]/option">
					<option value="{@value}">
						<xsl:if test="@selected eq 'true'"><xsl:attribute name="selected" select="'selected'"/></xsl:if>
						<xsl:value-of select="@name"/>
					</option>
				</xsl:for-each>
				<xsl:for-each select="$action-data/selection[@id eq $field-name]/optionGroup">
					<optgroup label="{label}">
						<xsl:for-each select="option">
							<option value="{@value}">
								<xsl:if test="@selected eq 'true'"><xsl:attribute name="selected" select="'selected'"/></xsl:if>
								<xsl:value-of select="@name"/>
							</option>
						</xsl:for-each>
					</optgroup>
				</xsl:for-each>
			</select>
		</div>
		<p class="clr"></p>
		<xsl:apply-templates select="." mode="js-validation"/>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type eq 'image']" priority="-1.5" mode="form">
		<xsl:param name="action-id" tunnel="yes"/>
		<xsl:param name="action-config" tunnel="yes"/>
		<xsl:param name="action-data" tunnel="yes"/>
		
		<xsl:param name="field-binding" tunnel="yes"/>
		
		<xsl:param name="image-src" select="if (icon/@type eq 'file') 
			then $action-data//result//field[@name eq current()/@name]/value 
			else '/template/assets/spacer.png'
			"/>
		<xsl:param name="image-css" select="if (icon/@type ne 'file') then concat('icon ','ico_',icon/text()) else ''" as="xs:string"/>
		
		<xsl:if test="icon">
			<img src="{$image-src}" border="0">
				<xsl:if test="image-css ne ''">
					<xsl:attribute name="class" select="$image-css"/>	
				</xsl:if>
				<xsl:if test="string-length(label) > 1">
					<xsl:attribute name="title"><xsl:value-of select="label"/></xsl:attribute>
					<xsl:attribute name="alt"><xsl:value-of select="label"/></xsl:attribute>
				</xsl:if>
			</img>
		</xsl:if>
		<xsl:if test="count(icon) = 0">
			<xsl:variable name="field-name" select="./@name" />
			<img src="{$action-data//result//field[@name eq $field-name]/value}" border="0" />
		</xsl:if>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type eq 'coordinate']" priority="-1.5" mode="form">
		<xsl:param name="action-id" tunnel="yes"/>
		<xsl:param name="action-htmlid" tunnel="yes"/>
		<xsl:param name="action-config" tunnel="yes"/>
		<xsl:param name="action-data" tunnel="yes"/>
		<xsl:param name="field-name" tunnel="yes"/>
		<xsl:param name="field-htmlid" tunnel="yes" />
		<xsl:param name="field-id" tunnel="yes"/>
		
		<xsl:param name="field-lat-selector" as="xs:string">
			<xsl:for-each select="field">
				<xsl:if test="contains(@binding,'latitude')">
					<xsl:value-of select="string-join( ('#field',@name,string(position())),'_' )"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:param>
		<xsl:param name="field-lng-selector" as="xs:string">
			<xsl:for-each select="field">
				<xsl:if test="contains(@binding,'longitude')">
					<xsl:value-of select="string-join( ('#field',@name,string(position())),'_' )"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:param>
		
		<xsl:for-each select="field">
			<xsl:apply-templates select="." mode="#current"/>
		</xsl:for-each>

		<xsl:call-template name="google-maps">
			<xsl:with-param name="action-htmlid" select="$action-htmlid"/>
			<xsl:with-param name="lat-selector" select="$field-lat-selector"/>
			<xsl:with-param name="lng-selector" select="$field-lng-selector"/>
			<xsl:with-param name="config" select="$action-config"/>
		</xsl:call-template>
		<xsl:apply-templates select="." mode="js-validation"/>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type eq 'richtext']" priority="-1.5" mode="form">
		<xsl:param name="action-id" tunnel="yes"/>
		<xsl:param name="action-config" tunnel="yes"/>
		<xsl:param name="field" tunnel="yes"/>
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-binding" tunnel="yes"/>
		<xsl:param name="field-readonly" tunnel="yes"/>
		<xsl:param name="field-attributes" tunnel="yes"/>
		<xsl:param name="field-format" tunnel="yes"/>
		<xsl:param name="field-css-readonly" tunnel="yes"/>
		<xsl:param name="field-css-error" tunnel="yes"/>
		
		<xsl:param name="field-css" select="normalize-space(string-join( ('text',$field-css-readonly,$field-css-error),' ' ))" as="xs:string"/>
		
		<xsl:variable name="directionality" select="if ( $language eq 'ar') then 'rtl' else 'ltr'" />
		
		<textarea class="richtext {$field-css}" id="{$field-htmlid}" name="{$field-binding}">
			<xsl:if test="$field-readonly">
				<xsl:attribute name="disabled" select="'disabled'"/>
				<xsl:attribute name="readonly" select="'readonly'"/>
			</xsl:if>
			<xsl:for-each select="$field-attributes/attribute">
				<xsl:attribute name="{@name}" select="@value"/>
			</xsl:for-each>
			<xsl:value-of select="$field-value" disable-output-escaping="yes"/>
		</textarea>
		<script type="text/javascript" language="javascript">
			if(typeof richTextItems == 'undefined') var richTextItems = [];
			richTextItems.push({
					selector: '#<xsl:value-of select="$field-htmlid"/>',
					options: {
						format: '<xsl:value-of select="$field-format"/>',
						directionality : '<xsl:value-of select="$directionality" />'
					}
				});
		</script>	
		<xsl:apply-templates select="." mode="js-validation"/>
	</xsl:template>	
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type eq 'date']" priority="-1.5" mode="form">
		<xsl:param name="action-id" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-format" tunnel="yes"/>
		<xsl:param name="field-binding" tunnel="yes"/>
		
		<xsl:call-template name="datetime-picker">
			<xsl:with-param name="form-id" select="$action-id"/>
			<xsl:with-param name="id" select="$field-htmlid"/>
			<xsl:with-param name="name" select="$field-binding"/>
			<xsl:with-param name="datetime" select="$field-value"/>
			<xsl:with-param name="datetime-format" select="$field-format"/>
		</xsl:call-template>
		<xsl:apply-templates select="." mode="js-validation"/>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type eq 'password']" priority="-1.5" mode="form">
		<xsl:param name="field" tunnel="yes"/>
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-readonly" tunnel="yes"/>
		<xsl:param name="field-binding" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-selected" tunnel="yes"/>
		<xsl:param name="field-attributes" tunnel="yes"/>
		
		<xsl:param name="field-type" select="'text'" as="xs:string"/>
		<xsl:param name="field-css-error" select="if ($field/messages/message[@class eq 'ERROR']) then 'error' else ''" as="xs:string"/>
		<xsl:param name="field-css-readonly" select="if ($field/@readonly eq 'true') then 'disabled' else ''" as="xs:string"/>
		<xsl:param name="field-css" select="string-join( ($field-type,$field-css-readonly,$field-css-error),' ' )" as="xs:string"/>
		
		<input class="{$field-css}" id="{$field-htmlid}" name="{$field-binding}" type="password">
			<xsl:if test="$field-readonly">
				<xsl:attribute name="disabled" select="'disabled'"/>
				<xsl:attribute name="readonly" select="'readonly'"/>
			</xsl:if>
			<xsl:for-each select="$field-attributes/attribute">
				<xsl:attribute name="{@name}" select="@value"/>
			</xsl:for-each>
		</input>
		<xsl:apply-templates select="." mode="js-validation"/>
	</xsl:template>	
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field" priority="-2.5" mode="js-validation">
		<xsl:param name="action-htmlid" tunnel="yes"/>
		<xsl:param name="action-clientvalidation" tunnel="yes"/>
		<xsl:param name="field" tunnel="yes"/>
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-type" tunnel="yes"/>
		<xsl:param name="field-validation" tunnel="yes"/>
		
		<xsl:param name="localization" select="$localization"/>
		
		<xsl:if test="$action-clientvalidation">
			<xsl:choose>
				<!-- single types or type list:select -->
				<xsl:when test="not(contains($field-type,'list:')) or $field-type eq 'list:select'">
					<xsl:if test="$field/validation">
						<xsl:call-template name="client-field-validation">
							<xsl:with-param name="action-htmlid" select="$action-htmlid"/>
							<xsl:with-param name="field-htmlid" select="$field-htmlid"/>
							<xsl:with-param name="field-type" select="$field-type"/>
							<xsl:with-param name="field-validation" select="$field-validation"/>
							<xsl:with-param name="localization" select="$localization"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:when>
				<!-- not supported types -->
				<xsl:otherwise/>						
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field" priority="-2.25" mode="form">
		<xsl:param name="field" tunnel="yes"/>
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-readonly" tunnel="yes"/>
		<xsl:param name="field-binding" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-selected" tunnel="yes"/>
		<xsl:param name="field-attributes" tunnel="yes"/>
		
		<xsl:param name="field-type" select="'text'" as="xs:string"/>
		<xsl:param name="field-css-error" select="if ($field/messages/message[@class eq 'ERROR']) then 'error' else ''" as="xs:string"/>
		<xsl:param name="field-css-readonly" select="if ($field/@readonly eq 'true') then 'disabled' else ''" as="xs:string"/>
		<xsl:param name="field-css" select="string-join( ($field-type,$field-css-readonly,$field-css-error),' ' )" as="xs:string"/>

		<input class="{$field-css}" id="{$field-htmlid}" name="{$field-binding}" type="{$field-type}" value="{$field-value}">
			<xsl:if test="$field-readonly">
				<xsl:attribute name="disabled" select="'disabled'"/>
				<xsl:attribute name="readonly" select="'readonly'"/>
			</xsl:if>
			<xsl:for-each select="$field-attributes/attribute">
				<xsl:attribute name="{@name}" select="@value"/>
			</xsl:for-each>
		</input>
		
		<xsl:apply-templates select="." mode="js-validation"/>
	</xsl:template>	

	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type ne 'checkbox']/label" priority="1.75" mode="#all">
		<div class="label">
			<xsl:next-match/>
		</div>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field/label" priority="1.5" mode="#all">
		<xsl:param name="field-htmlid" tunnel="yes"/>
		<xsl:param name="field-css" tunnel="yes"/>
		
		<label for="{$field-htmlid}" class="{$field-css}">
			<xsl:next-match/>
		</label>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field[@type eq 'checkbox']/label" priority="-2.4" mode="#all">
		<xsl:apply-templates select="text()"/><xsl:if test="../validation/notNull"><span class="red"> *</span></xsl:if>
	</xsl:template>
	<xd:doc>
		
	</xd:doc>
	<xsl:template match="action/config/meta-data//field/label" priority="-2.5" mode="#all">
		<xsl:apply-templates select="text()"/><xsl:if test="../validation/notNull"><span class="red"> *</span></xsl:if>:
	</xsl:template>
	
</xsl:stylesheet>
