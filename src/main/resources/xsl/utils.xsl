<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
	xmlns="http://www.appng.org/schema/platform" xmlns:ait="http://aiticon.de" xmlns:appng="http://appng.org"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc"
	xpath-default-namespace="http://www.appng.org/schema/platform">
	
	<xd:doc>
		<xd:short>
			Outputs outer HTML table for one or messages 
		</xd:short>
	</xd:doc>
	<xsl:template match="messages" priority="-0.5" mode="#all">
		<table class="eventmessage">
			<xsl:apply-templates select="message" mode="#current"/>
		</table>
	</xsl:template>
	<xd:doc>
		<xd:short>
			Outputs a message
		</xd:short>
	</xd:doc>
	<xsl:template match="message" priority="-0.5" mode="#all">
		<xsl:param name="id" select="string-join(('m',string(position()),@ref),'_')" as="xs:string"/>
		<xsl:param name="class" select="string-join(('text',lower-case(@class)),' ')" as="xs:string"/>
		<tr>
			<td align="center">
				<div class="centered fade-{$class}" id="{$id}">
					<p class="text">
					<xsl:call-template name="replace-nl-to-br">
						<xsl:with-param name="string" select="text() | *"/>
					</xsl:call-template>
					</p>
				</div>
				<script language="javascript" type="text/javascript">
					<![CDATA[app.initEventmessage(']]><xsl:value-of select="$id"/><![CDATA[');]]>
				</script>
			</td>
		</tr>
	</xsl:template>
	
	<xd:doc>
		<xd:short>Outputs an element as a list element</xd:short>
	</xd:doc>
	<xsl:template match="*" priority="5" mode="xml-list">
		<li>
			<a href="javascript:void(0)">
				&lt;<xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="#current"/>&gt;
				<xsl:apply-templates select="text()" mode="#current"/>
			</a>
			<xsl:if test="count(*) &gt; 0">
				<ul>
					<xsl:apply-templates select="*" mode="#current"/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	<xd:doc>
		<xd:short>Outputs an attribute in plaintext</xd:short>
	</xd:doc>
	<xsl:template match="@*" priority="5" mode="xml-list formattedtext">&#160;<xsl:value-of select="name()"/>="<xsl:value-of select="."/>"<xsl:text/></xsl:template>
	<xd:doc>
		<xd:short>Outputs text-node in plaintext</xd:short>
	</xd:doc>
	<xsl:template match="text()" priority="5" mode="xml-list"><xsl:value-of select="."/></xsl:template>
	<xd:doc>
		<xd:short>Outputs text-node in plaintext</xd:short>
		<xd:detail>Plaintext is intended via Tab's, depending on count of ancestor elements</xd:detail>
	</xd:doc>
	<xsl:template match="text()" priority="5" mode="formattedtext"><xsl:value-of select="for $tab in (ancestor::node()) return '&#x09;'"/><xsl:value-of select="."/><xsl:text>&#xA;</xsl:text></xsl:template>
	<xd:doc>
		<xd:short>Outputs an element in plaintext</xd:short>
		<xd:detail>Plaintext is intended via Tab's, depending on count of ancestor elements</xd:detail>
	</xd:doc>
	<xsl:template match="*[exists( (*,text()) )]" priority="5" mode="formattedtext"><xsl:value-of select="for $tab in (ancestor::node()) return '&#x09;'"/><xsl:text>&lt;</xsl:text><xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="#current"/><xsl:text>&gt;&#xA;</xsl:text><xsl:apply-templates select="text() | *" mode="#current"/><xsl:value-of select="for $tab in (ancestor::node()) return '&#x09;'"/><xsl:text>&lt;/</xsl:text><xsl:value-of select="name()"/><xsl:text>&gt;&#xA;</xsl:text></xsl:template>
	<xd:doc>
		<xd:short>Outputs an element in plaintext</xd:short>
		<xd:detail>Plaintext is intended via Tab's, depending on count of ancestor elements</xd:detail>
	</xd:doc>
	<xsl:template match="*[not(exists( (*,text()) ))]" priority="5" mode="formattedtext"><xsl:value-of select="for $tab in (ancestor::node()) return '&#x09;'"/><xsl:text>&lt;</xsl:text><xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="#current"/><xsl:text>&#160;/&gt;&#xA;</xsl:text></xsl:template>
	
	<xd:doc>
		<xd:short>Outputs cdatatext text-node with disabled output escaping</xd:short>
	</xd:doc>
	<xsl:template match="cdatatext" priority="-2.5" mode="#all">
		<xsl:value-of disable-output-escaping="yes" select="."/>
	</xsl:template>
	
	<xd:doc>
		<xd:short>Common description template</xd:short>
		<xd:detail>
		</xd:detail>
	</xd:doc>
	<xsl:template match="description" priority="-2.5" mode="#all">
		<xsl:call-template name="replace-nl-to-br">
			<xsl:with-param name="string" select="text()"/>
		</xsl:call-template>
	</xsl:template>
	
	<xd:doc>
		<xd:short>Default htmltext element template</xd:short>
		<xd:detail>
			All htmltext elements and childs are transformed 1:1 (xml->html).
			Custom htmltext element templates can defined, if needed, so it acts similiar to the builtin xslt templates..   
		</xd:detail>
	</xd:doc>
	<xsl:template match="htmltext//*" priority="-2.5" mode="#all">
		<xsl:element name="{local-name()}">
			<xsl:apply-templates select="* | @* | text()"/>
		</xsl:element>
	</xsl:template>
	<xd:doc>
		<xd:short>Default htmltext attribute template</xd:short>
		<xd:detail>
			All htmltext attributes are transformed 1:1 (xml->html).
			Custom htmltext element templates can defined, if needed, so it acts similiar to the builtin xslt templates..   
		</xd:detail>
	</xd:doc>
	<xsl:template match="htmltext//@*" priority="-2.5" mode="#all">
		<xsl:attribute name="{name(.)}">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<xd:doc>
		<xd:short>Generates clientside javascript/markup for validation of a field</xd:short>
	</xd:doc>
	<xsl:template name="client-field-validation">
		<xsl:param name="action-htmlid" as="xs:string" required="yes"/>
		<xsl:param name="field-htmlid" as="xs:string" required="yes"/>
		<xsl:param name="field-type" as="xs:string" required="yes"/>
		
		<xsl:param name="field-validation" as="element(*)?"/>
		<xsl:param name="localization" as="element(*)"/>
		
		<xsl:param name="grouping-separator" select="$localization/groupingSeparator" as="xs:string"/>
		<xsl:param name="decimal-separator" select="$localization/decimalSeparator" as="xs:string"/>
		<xsl:param name="format" select="if ($field-type = ('int','long','decimal','date')) then $field-validation/../@format else ''" as="xs:string"/>
		<xsl:param name="mandatory" select="if (not($field-validation/notNull)) then 'mandatory: false' else 'mandatory: true'" as="xs:string"/>
		
		<div id="{$field-htmlid}-error-message"></div>
		<script type="text/javascript">
			<!-- ATTENTION: leave linebreaks and identation as is, JS errors might occur otherwhise! -->
			$(document).ready(function(){
				FormJS_<xsl:value-of select="$action-htmlid"/>.addElement("#<xsl:value-of select="$field-htmlid"/>", "<xsl:value-of select="$field-type"/>", {
					<xsl:value-of select="$mandatory"/>,<xsl:if test="$field-type eq 'date'">
					format: '<xsl:value-of select="$format"/>',</xsl:if>
					errorMessageContainer: '#<xsl:value-of select="$field-htmlid"/>-error-message',
					typeErrorMessage: '<xsl:value-of select="$field-validation/type"/>',
					validationRules: [<xsl:for-each select="$field-validation/*[name() ne 'type']">
						{
							type: '<xsl:value-of select="name()"/>', 
							errorMessage:'<xsl:value-of select="replace(message/text(),' ','&#160;')"/>',
							options: {
								<xsl:for-each select="@*"><xsl:value-of select="name()"/>:'<xsl:value-of select="replace(.,'\\','\\\\')"/>'<xsl:if test="position() != last()">,
								</xsl:if>
								</xsl:for-each>
							}
						}<xsl:if test="position() != last()">,</xsl:if>
						</xsl:for-each>
					]<xsl:if test="$format ne ''">,
					localization: {
						number: {
							format: '<xsl:value-of select="$format"/>',
							groupingSeparator: '<xsl:value-of select="$grouping-separator"/>',
							decimalSeparator: '<xsl:value-of select="$decimal-separator"/>'
						}
					}</xsl:if>
				});
			});
		</script>
	</xsl:template>
	
	<xd:doc>
		<xd:short>Generates a date-time picker field</xd:short>
	</xd:doc>
	<xsl:template name="datetime-picker">
		<xsl:param name="form-id" as="xs:string" required="yes"/>
		<xsl:param name="id" as="xs:string" required="yes"/>
		<xsl:param name="name" as="xs:string" required="yes"/>
		
		<xsl:param name="datetime" as="xs:string"/>
		<xsl:param name="next-id" as="xs:string?"/>
		<xsl:param name="auto-submit" select="false()" as="xs:boolean"/>
		<xsl:param name="datetime-format" as="xs:string"/>
		
		<xsl:param name="show-hours" select="contains( lower-case($datetime-format),'hh' )" as="xs:boolean"/>
		<xsl:param name="show-minutes" select="contains( $datetime-format,'mm' )" as="xs:boolean"/>
		<xsl:param name="show-seconds" select="contains( lower-case($datetime-format),'ss' )" as="xs:boolean"/>
		<xsl:param name="show-time" select="if ( $show-hours and $show-minutes and $show-seconds ) then true() else false()" as="xs:boolean"/>
		<xsl:param name="show-24h" select="contains( $datetime-format,'hh' )" as="xs:boolean"/>
		<xsl:param name="show-timeonly" select="
			if (
				contains($datetime-format,'y') or contains($datetime-format,'M') or contains($datetime-format,'d')
			) then false() 
			else true()
			" as="xs:boolean"/>
		<xsl:param name="separator" select="if ( not($show-hours and $show-minutes and $show-minutes) ) then '' else ' '" as="xs:string"/>
		<input id="{$id}" name="{$name}" value="{$datetime}" type="text" class="text w200 typeDate"/>
		<a href="javascript:void(0);" onclick="$('#{$id}').val('');" class="typeDate">X</a>
		<script type="text/javascript" language="javascript">
			<xsl:text disable-output-escaping="yes"><![CDATA[<!--]]></xsl:text>
			$('#<xsl:value-of select="$id"/>').datetimepicker({
			dateFormat: dateTimePattern.get({pattern: '<xsl:value-of select="$datetime-format"/>', type: 'date'}),
			timeFormat: dateTimePattern.get({pattern: '<xsl:value-of select="$datetime-format"/>', type: 'time'}),
			separator: '<xsl:value-of select="$separator"/>',
			ampm: <xsl:value-of select="$show-24h"/>,
			timeOnly: <xsl:value-of select="$show-timeonly"/>,
			showHour: <xsl:value-of select="$show-hours"/>,
			showMinute: <xsl:value-of select="$show-minutes"/>,
			showSecond: <xsl:value-of select="$show-seconds"/>,
			showTime: <xsl:value-of select="$show-time"/><xsl:if test="$next-id != '' or ($auto-submit and $next-id eq '')">,</xsl:if>
			<xsl:choose>
				<xsl:when test="$next-id ne ''">
					onClose: function(dateText, inst){
					var endDateTextBox = $('#<xsl:value-of select="$next-id"/>');
					if(endDateTextBox.val() != ''){
					var testStartDate = new Date(dateText);
					var testEndDate = new Date(endDateTextBox.val());
					<xsl:text disable-output-escaping="yes"><![CDATA[if (testStartDate > testEndDate) endDateTextBox.val(dateText);]]></xsl:text>
					} else {
					endDateTextBox.val(dateText);
					}
					<xsl:if test="$auto-submit">
						app.submitForm('<xsl:value-of select="$form-id"/>');
					</xsl:if>
					},
					onSelect: function (selectedDateTime){
					var start = $(this).datetimepicker('getDate');
					$('#<xsl:value-of select="$next-id"/>').datetimepicker('option', 'minDate', new Date(start.getTime()));
					}
				</xsl:when>
				<xsl:when test="$auto-submit and $next-id eq ''">
					onClose: function(){ app.submitForm('<xsl:value-of select="$form-id"/>'); }
				</xsl:when>
			</xsl:choose>
			});
			<xsl:text disable-output-escaping="yes"><![CDATA[// -->]]></xsl:text>
		</script>
	</xsl:template>

	<xd:doc>
		<xd:short>Generates a select-option to switch the chunksize of a paginated resultset</xd:short>
	</xd:doc>
	<xsl:template name="pagination-chunksize-switcher">
		<xsl:param name="current-chunksize" as="xs:integer" required="yes"/>
		<xsl:param name="datasource-id" as="xs:string" required="yes"/>

		<xsl:param name="sort-datasource-id" select="concat(upper-case(substring($datasource-id,1,1)),substring($datasource-id, 2))" as="xs:string"/>
		<xsl:param name="url-param-prefix-pagesize" select="string-join( ('sort',$sort-datasource-id,'=','pageSize:'),'' )" as="xs:string"/>
		<xsl:param name="label-chunksize" select="appng:search-label('label.chunkSize', .)" as="xs:string"/>
		<xsl:param name="url-anchor" as="xs:string"/>
		<xsl:param name="additional-url-params"/>
		
		<xsl:param name="chunksize-switch-sequence" select="(1,5,10,25)"/>

		<xsl:value-of select="$label-chunksize"/>:&#160;
		<select	name="{$sort-datasource-id}_chunksize" onchange="location.href=this.options[this.selectedIndex].value">
			<xsl:for-each select="$chunksize-switch-sequence">
				<xsl:variable name="url-param-dyn-pagesize" select="concat($url-param-prefix-pagesize,.)" as="xs:string"/>
				<option value="{concat( '?' , string-join( ($url-param-dyn-pagesize,($additional-url-params)),'&#38;' ) , if ($url-anchor) then concat('#',$url-anchor) else '')}">
					<xsl:if test="$current-chunksize eq .">
						<xsl:attribute name="selected" select="'selected'"/>
					</xsl:if>
					<xsl:value-of select="."/>
				</option>
			</xsl:for-each>		
		</select>
	</xsl:template>
	<xd:doc>
		<xd:short>Display information about items in current pagination chunk</xd:short>
	</xd:doc>
	<xsl:template name="pagination-hits">
		<xsl:param name="resultset" as="element(resultset)?"/>
		<xsl:param name="current-first-item" select="(xs:integer($resultset/@chunk) * xs:integer($resultset/@chunksize)) + 1" as="xs:integer"/>
		<xsl:param name="current-last-item" select="
				if ($resultset/@chunk eq $resultset/@lastchunk) then
					xs:integer($resultset/@hits)
				else
					$current-first-item + xs:integer($resultset/@chunksize) - 1
				" as="xs:integer"/>
		<xsl:param name="count-items" select="xs:integer($resultset/@hits)" as="xs:integer"/>
		<xsl:param name="label-of" select="appng:search-label('label.of', .)" as="xs:string"/>
		
		<xsl:value-of select="($current-first-item,'-',$current-last-item,' ',$label-of,' ',$count-items)"/>
	</xsl:template>
	
	<xd:doc>
		<xd:short>
			Generates a paginated navigation of a resultset
		</xd:short>
	</xd:doc>
	<xsl:template name="pagination">
		<xsl:param name="current-chunk" as="xs:integer" required="yes"/>
		<xsl:param name="first-chunk" as="xs:integer" required="yes"/>
		<xsl:param name="prev-chunk" as="xs:integer" required="yes"/>
		<xsl:param name="next-chunk" as="xs:integer" required="yes"/>
		<xsl:param name="last-chunk" as="xs:integer" required="yes"/>
		
		<xsl:param name="datasource-id" as="xs:string" required="yes"/>
		<xsl:param name="sort-datasource-id" select="concat(upper-case(substring($datasource-id,1,1)),substring($datasource-id, 2))" as="xs:string"/>
		
		<xsl:param name="chunk-split" select="4" as="xs:integer"/>
		<xsl:param name="url-anchor" as="xs:string"/>
		<xsl:param name="chunk-size" select="25" as="xs:integer"/>
		<xsl:param name="additional-url-params"/>
	
		<xsl:param name="url-param-prefix-position" select="string-join( ('sort',$sort-datasource-id,'=','page:'),'' )" as="xs:string"/>
		<xsl:param name="url-param-first-position" select="concat($url-param-prefix-position,$first-chunk)"/>
		<xsl:param name="url-param-next-position" select="concat($url-param-prefix-position,$next-chunk)"/>
		<xsl:param name="url-param-last-position" select="concat($url-param-prefix-position,$last-chunk)"/>
		<xsl:param name="url-param-prev-position" select="concat($url-param-prefix-position,$prev-chunk)"/>
		
		<xsl:param name="label-first" select="appng:search-label('label.first', .)" as="xs:string"/>
		<xsl:param name="label-last" select="appng:search-label('label.last', .)" as="xs:string"/>
		<xsl:param name="label-prev" select="appng:search-label('label.previous', .)" as="xs:string"/>
		<xsl:param name="label-next" select="appng:search-label('label.next', .)" as="xs:string"/>
		
		<xsl:if test="$first-chunk ne $last-chunk">
				
			<span class="cursor">
				<xsl:choose>
					<xsl:when test="$current-chunk = 0">
						<a class="btn_pag_start" style="color: #666;">
							<xsl:value-of select="$label-first"/>
						</a>
						<a class="btn_pag_back" style="color: #666;">
							<xsl:value-of select="$label-prev"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a class="btn_pag_start"
							href="{concat( '?' , string-join( ($url-param-first-position,($additional-url-params)),'&#38;' ) , if ($url-anchor) then concat('#',$url-anchor) else '')}">
							<xsl:value-of select="$label-first"/>
						</a>
						<a class="btn_pag_back"
							href="{concat( '?' , string-join( ($url-param-prev-position,($additional-url-params)),'&#38;' ) , if ($url-anchor) then concat('#',$url-anchor) else '')}">
							<xsl:value-of select="$label-prev"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</span>
			
			<ul class="page_navigation">
				<xsl:for-each select="(1 to ($last-chunk + 1))">
					<xsl:variable name="dyn-chunk" select="position() - 1"/>
					<xsl:variable name="url-param-dyn-position" select="concat($url-param-prefix-position,$dyn-chunk)" as="xs:string"/>
					
					<xsl:choose>
						<xsl:when test="($last-chunk + 1) ge ($chunk-split * 2)">
							<xsl:choose>
								<xsl:when test="position() ge ($first-chunk + 1)
									and position() lt (($first-chunk + 1) + $chunk-split)
									and ($current-chunk + 1) le $chunk-split">
									<li>
										<xsl:if test="position() = ($current-chunk + 1)">
											<xsl:attribute name="class" select="'active'"/>
										</xsl:if>
										<a>
											<xsl:if test="position() ne ($current-chunk + 1)">
												<xsl:attribute name="href" select="concat( '?' , string-join( ($url-param-dyn-position,($additional-url-params)),'&#38;' ) , if ($url-anchor) then concat('#',$url-anchor) else '')"/>
											</xsl:if>
											<xsl:value-of select="position()"/>
										</a>
									</li>
								</xsl:when>
								<xsl:when test="(	position() le (($last-chunk + 1) - $chunk-split)
									and position() gt ($last-chunk + 1) - ($chunk-split * 2)
									and ($current-chunk + 1) gt (($last-chunk + 1) - $chunk-split) )
									or
									( 
									position() gt ($current-chunk + 1) - $chunk-split
									and position() le ($current-chunk + 1)
									and not(($current-chunk + 1) gt (($last-chunk + 1) - $chunk-split))
									)">
									<li>
										<xsl:if test="position() = ($current-chunk + 1)">
											<xsl:attribute name="class" select="'active'"/>
										</xsl:if>
										<a>
											<xsl:if test="position() ne ($current-chunk + 1)">
												<xsl:attribute name="href" select="concat( '?' , string-join( ($url-param-dyn-position,($additional-url-params)),'&#38;' ) , if ($url-anchor) then concat('#',$url-anchor) else '')"/>
											</xsl:if>
											<xsl:value-of select="position()"/>
										</a>
									</li>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="position() = ($last-chunk + 1) - $chunk-split and ($last-chunk + 1) ge ($chunk-split * 2)">
								<li> ... </li>
							</xsl:if>						
							<xsl:if test="position() le ($last-chunk + 1)
								and position() gt ($last-chunk +1) - $chunk-split
								and ($last-chunk + 1) ge ($chunk-split * 2)
								">
								<xsl:variable name="dyn-chunk" select="position() - 1"/>
								<xsl:variable name="url-param-dyn-position" select="concat($url-param-prefix-position,$dyn-chunk)" as="xs:string"/>
								
								<li>
									<xsl:if test="position() = ($current-chunk + 1)">
										<xsl:attribute name="class" select="'active'"/>
									</xsl:if>
									<a>
										<xsl:if test="position() ne ($current-chunk + 1)">
											<xsl:attribute name="href" select="concat( '?' , string-join( ($url-param-dyn-position,($additional-url-params)),'&#38;' ) , if ($url-anchor) then concat('#',$url-anchor) else '')"/>
										</xsl:if>
										<xsl:value-of select="position()"/>
									</a>
								</li>						
							</xsl:if>						
						</xsl:when>
						<xsl:when test="($last-chunk + 1) lt ($chunk-split * 2)">
							<li>
								<xsl:if test="position() = ($current-chunk + 1)">
									<xsl:attribute name="class" select="'active'"/>
								</xsl:if>
								<a>
									<xsl:if test="position() ne ($current-chunk + 1)">
										<xsl:attribute name="href" select="concat( '?' , string-join( ($url-param-dyn-position,($additional-url-params)),'&#38;' ) , if ($url-anchor) then concat('#',$url-anchor) else '')"/>
									</xsl:if>
									<xsl:value-of select="position()"/>
								</a>
							</li>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</ul>
	
			<span class="cursor">
				<xsl:choose>
					<xsl:when test="$current-chunk = $last-chunk">
						<a class="btn_pag_next" style="color: #666;">
							<xsl:value-of select="$label-next"/>
						</a>
						<a class="btn_pag_end" style="color: #666;">
							<xsl:value-of select="$label-last"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a class="btn_pag_next"
							href="{concat( '?' , string-join( ($url-param-next-position,($additional-url-params)),'&#38;' ) , if ($url-anchor) then concat('#',$url-anchor) else '')}">
							<xsl:value-of select="$label-next"/>
						</a>
						<a class="btn_pag_end"
							href="{concat( '?' , string-join( ($url-param-last-position,($additional-url-params)),'&#38;' ) , if ($url-anchor) then concat('#',$url-anchor) else '')}">
							<xsl:value-of select="$label-last"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</span>
			
		</xsl:if>
	</xsl:template>

	<xd:doc>
		<xd:short>Generates a jtree list presentation of one or more XML sources</xd:short>
	</xd:doc>
	<xsl:template name="debug-console">
		<xsl:param name="sources"/>
		<xsl:param name="tree-limit" select="6" as="xs:integer"/>
		<xsl:param name="child-limit" select="25" as="xs:integer"/>
		
		<div class="debug-console">
			<xsl:for-each select="$sources">
				<xsl:call-template name="xml-to-ul">
					<xsl:with-param name="xml">
						<xsl:call-template name="xml-limited-tree">
							<xsl:with-param name="xml" select="."/>
							<xsl:with-param name="tree-limit" select="$tree-limit"/>
							<xsl:with-param name="child-limit" select="$child-limit"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="with-jtree" select="true()"/>
				</xsl:call-template>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<xd:doc>
		<xd:short>Outputs XML with a limitation of childs and sublevels</xd:short>
	</xd:doc>
	<xsl:template name="xml-limited-tree">
		<xsl:param name="xml" as="node()"/>
		<xsl:param name="child-limit" select="25" as="xs:integer"/>
		<xsl:param name="tree-limit" select="3" as="xs:integer"/>
		
		<xsl:if test="$tree-limit ge 0">
			<xsl:copy>
				<xsl:copy-of select="@* | text()"/>
				<xsl:for-each select="child::*[position() le $child-limit]">
					<xsl:call-template name="xml-limited-tree">
						<xsl:with-param name="child-limit" select="$child-limit"/>
						<xsl:with-param name="tree-limit" select="$tree-limit - 1"/>
						<xsl:with-param name="xml" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		<xd:short>
			Transforms XML to an HTML unordered list presentation
		</xd:short>
	</xd:doc>
	<xsl:template name="xml-to-ul">
		<xsl:param name="xml" required="yes" as="node()"/>
		<xsl:param name="id" select="string-join( ('list_',generate-id($xml)),'_' )" as="xs:string"/>
		<xsl:param name="with-jtree" select="false()" as="xs:boolean"/>
		
		<xsl:choose>
			<xsl:when test="$with-jtree">
				<div class="envtree" id="{$id}">
					<ul>
						<xsl:apply-templates select="$xml" mode="xml-list"/>
					</ul>
					<script type="text/javascript">
						<xsl:text disable-output-escaping="yes">
						<![CDATA[
							$(function () { 
								$("#]]></xsl:text><xsl:value-of select="$id"/><xsl:text disable-output-escaping="yes"><![CDATA[").jstree({
										"themes" : {
											"url" : "/template/resources/tools_stylesheet_jquery_tree.css",
											"dots" : true,
											"icons" : true
										},
										"plugins" : [ "themes", "html_data" ]
								});
							});
						]]>
						</xsl:text>
					</script>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<ul>
					<xsl:apply-templates select="$xml" mode="xml-list"/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		<xd:short>Generates file-icon template</xd:short>
		<xd:detail>Generated span element to display a file-icon dependens on filename-suffix</xd:detail>
	</xd:doc> 
	<xsl:template name="file-icon">
		<xsl:param name="file-name" as="xs:string" required="yes"/>
		<xsl:param name="display-length" select="40" as="xs:integer"/>

		<xsl:variable name="file-suffix" as="xs:string">
			<xsl:analyze-string regex="\.([a-zA-Z0-9]+)$" select="$file-name">
				<xsl:matching-substring>
					<xsl:value-of select="lower-case(regex-group(1))"/>
				</xsl:matching-substring>
			</xsl:analyze-string>
		</xsl:variable>
		<xsl:variable name="file-type" as="xs:string">
			<xsl:choose>
				<xsl:when test="$file-suffix = ('zip','tar','rar','tgz','7z')">zip</xsl:when>
				<xsl:when test="$file-suffix = ('txt', 'properties', 'sql', 'log', 'js', 'css', 'html', 'sh', 'bat')">txt</xsl:when>
				<xsl:when test="$file-suffix = ('xls','xlsx','ods')">xls</xsl:when>
				<xsl:when test="$file-suffix = ('jpg','gif','png')">img</xsl:when>
				<xsl:when test="$file-suffix = ('mp3',  'aac', 'm4a', 'f4a', 'ogg', 'oga', 'mp4', 'm4v', 'f4v', 'mov', 'flv', 'ogv')">audio</xsl:when>
				<xsl:when test="$file-suffix = ('pdf')">pdf</xsl:when>
				<xsl:when test="$file-suffix = ('ppt', 'pptx', 'odp')">ppt</xsl:when>
				<xsl:when test="$file-suffix = ('avi','mpg','mkv','flv')">video</xsl:when>
				<xsl:when test="$file-suffix = ('doc','docx', 'odt')">doc</xsl:when>
				<xsl:when test="$file-suffix = ('xml', 'xsl', 'xsd','csv')">xml</xsl:when>
				<xsl:otherwise>unknown</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<span class="icon ico_file_{$file-type}" title="{.}">
			<xsl:value-of select="appng:crop-by-length($file-name,$display-length,'...')"/>
		</span>
	</xsl:template>

	<xd:doc>
		<xd:short>Generates a google maps mashup</xd:short>
	</xd:doc>
	<xsl:template name="google-maps">
		<xsl:param name="config" select="." as="element(*)"/>
		<xsl:param name="action-htmlid" as="xs:string" required="yes"/>
		<xsl:param name="lat-selector" as="xs:string" required="yes"/>
		<xsl:param name="lng-selector" as="xs:string" required="yes"/>
		<xsl:param name="grouping-separator" select="$localization/groupingSeparator" as="xs:string"/>
		<xsl:param name="decimal-separator" select="$localization/decimalSeparator" as="xs:string"/>

		<div class="fieldcontainer">
			<div class="field">
				<input class="text" name="address"
					onblur="if (this.value=='') this.value='{appng:search-label('enter.address',$config)}'"
					onfocus="if (this.value=='{appng:search-label('enter.address',$config)}') this.value=''"
					size="60" type="text">
					<xsl:attribute name="value" select="appng:search-label('enter.address',$config)"/>
				</input>
			</div>
		</div>
		<div class="buttons_panel">
			<div class="center">
				<a class="btn_search" href="javascript:void(0)"
					onclick="return gmaps.showLocation(document.forms['{$action-htmlid}'].address.value)">
					<xsl:value-of select="appng:search-label('search',$config)"/>
				</a>
				<a class="btn_goto" href="javascript:void(0)" onclick="return gmaps.goToMarker()">
					<xsl:value-of select="appng:search-label('go.to.marker',$config)"/>
				</a>
				<a class="btn_delete" href="javascript:void(0)"
					onclick="return gmaps.deleteMarker()">
					<xsl:value-of select="appng:search-label('delete.marker',$config)"/>
				</a>
			</div>
			<xsl:text disable-output-escaping="yes"><![CDATA[<br/>]]></xsl:text>
			<div class="map-canvas" id="map_canvas"/>
			<script src="//maps.google.com/maps/api/js?key={$google-maps-key}&amp;sensor=false" type="text/javascript"/>
			<script src="/template/resources/tools_javascript_gmaps.js" type="text/javascript"/>
			<script type="text/javascript">
				$(document).ready(function(){
                	gmaps.init({
                		latSelector: '<xsl:value-of select="$lat-selector"/>',
                		lngSelector: '<xsl:value-of select="$lng-selector"/>',
                		geoCoordinatesFormat: {format: '#0.0000000', groupingSeparator: '<xsl:value-of select="$grouping-separator"/>', decimalSeparator: '<xsl:value-of select="$decimal-separator"/>'}
                	});
				});
			</script>
		</div>
		<xsl:text disable-output-escaping="yes"><![CDATA[<br/>]]></xsl:text>
		<div class="hr"/>
		<p class="clr">&#160;</p>
	</xsl:template>

	<xd:doc>
		<xd:short>Replaces newline &amp;#10; with HTML &lt;br /&gt;</xd:short>
	</xd:doc>
	<xsl:template name="replace-nl-to-br">
		<xsl:param name="string" as="xs:string?"/>
		<xsl:param name="disable-output-escaping" select="true()" as="xs:boolean"/>
		
		<xsl:choose>
			<xsl:when test="$disable-output-escaping">
				<xsl:for-each select="tokenize($string,'&#10;')">
					<xsl:value-of select="." disable-output-escaping="yes"/><xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="tokenize($string,'&#10;')">
					<xsl:value-of select="."/><xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:function name="appng:search-label">
		<xsl:param name="id"/>
		<xsl:param name="node"/>

		<xsl:choose>
			<xsl:when test="$node/config/labels/label[@id eq $id]">
				<xsl:value-of select="$node/config/labels/label[@id eq $id]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$node/parent::*">
						<xsl:value-of select="appng:search-label($id,$node/parent::*)"/>
					</xsl:when>
					<xsl:otherwise>{<xsl:value-of select="$id"/>}_ADD_TO_DICT</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xd:doc>
		<xd:short>
			TODO docu
		</xd:short>
		<xd:detail>
			Equal to appng:search-label and just added for backward compatibility to some old applications/plugins  
		</xd:detail>
	</xd:doc>
	<xsl:function name="ait:dict">
		<xsl:param name="id"/>
		<xsl:param name="node"/>
		
		<xsl:message>Usage of ait:dict function, which is deprecated. Use appng:search-label indeed.</xsl:message>
		<xsl:choose>
			<xsl:when test="$node/config/labels/label[@id eq $id]">
				<xsl:value-of select="$node/config/labels/label[@id eq $id]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$node/parent::*">
						<xsl:value-of select="appng:search-label($id,$node/parent::*)"/>
					</xsl:when>
					<xsl:otherwise>{<xsl:value-of select="$id"/>}_ADD_TO_DICT</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xd:doc>
		<xd:short>Crop a string after n words</xd:short>
	</xd:doc>
	<xsl:function name="appng:crop-by-wordcount" as="xs:string">
		<xsl:param name="string" as="xs:string"/>
		<xsl:param name="wordcount" as="xs:double"/>
		<xsl:param name="filler" as="xs:string?"/>
		
		<xsl:variable name="string-cropped" select="tokenize($string,'\s+')[position() &lt; $wordcount]"/>
		<xsl:choose>
			<xsl:when test="count(tokenize($string,'\s+')) &gt; $wordcount">
				<xsl:value-of disable-output-escaping="yes" select="string-join(($string-cropped,$filler),'')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of disable-output-escaping="yes" select="$string"/>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xd:doc>
		<xd:short>Crop a string after n characters</xd:short>
	</xd:doc>
	<xsl:function name="appng:crop-by-length" as="xs:string">
		<xsl:param name="string" as="xs:string"/>
		<xsl:param name="length" as="xs:double"/>
		<xsl:param name="filler" as="xs:string?"/>
		<xsl:variable name="string-cropped" select="substring($string,0,$length)"/>
		<xsl:choose>
			<xsl:when test="string-length($string) &gt; $length">
				<xsl:value-of disable-output-escaping="yes" select="string-join(($string-cropped,$filler),'')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of disable-output-escaping="yes" select="$string"/>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xd:doc>
	</xd:doc>
	<xsl:function name="appng:get-absolute-url" as="xs:anyURI">
		<xsl:param name="url" as="xs:string"/>
		<xsl:param name="mode" as="xs:string"/>
		
		<xsl:variable name="final-url">
			<xsl:choose>
				<xsl:when test="$mode eq 'extern'">
					<xsl:value-of select="$url"/>
				</xsl:when>
				<xsl:when test="$mode eq 'intern'">
					<xsl:value-of select="string-join( ($current-applicationurl,$url),'' )"/>
				</xsl:when>
				<xsl:when test="$mode eq 'webservice'">
					<xsl:value-of select="$url"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="($final-url) cast as xs:anyURI"/>
	</xsl:function>

	<xd:doc>
		<xd:short>Generates a query string from a sequence of strings</xd:short>
	</xd:doc>
	<xsl:function name="appng:generate-query-string" as="xs:string">
		<xsl:param name="params"/>
		<xsl:param name="uriencoded" as="xs:boolean"/>
			<xsl:choose>
				<xsl:when test="$uriencoded">
					<xsl:variable name="query-string-seq">
						<xsl:for-each select="$params">
							<xsl:variable name="param-tokens-uriencoded" select="for $p in tokenize(.,'=') return encode-for-uri($p)"/>
							<xsl:variable name="param-uriencoded" select="string-join( ($param-tokens-uriencoded),'=' )" as="xs:string"/>
							
							<xsl:value-of select="if (position() eq 1) 
								then string-join( ('?',$param-uriencoded),'' )
								else string-join( ('&#38;',$param-uriencoded),'' )
								"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:value-of select="string-join( ($query-string-seq),'' )"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="query-string-seq">
						<xsl:for-each select="$params">
							<xsl:value-of select="if (position() eq 1) 
								then string-join( ('?',.),'' )
								else string-join( ('&#38;',.),'' )
								"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:value-of select="string-join( ($query-string-seq),'' )"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:function>

	<xd:doc>
		<xd:short>Generates a URL to reset a list of GET parameters</xd:short>
	</xd:doc>
	<xsl:function name="appng:generate-reset-url" as="xs:string">
		<xsl:param name="url" as="xs:string"/>
		<xsl:param name="params" as="xs:string*"/>
		<xsl:param name="anchor" as="xs:string"/>
		
		<xsl:variable name="query-string" select="if ( empty($params) ) then ''
			else appng:generate-query-string($params,false())" as="xs:string"/>
		<xsl:variable name="anchor-string" select="if ($anchor eq '') then '' 
			else concat( '#',$anchor )" as="xs:string"/>
		
		<xsl:value-of select="normalize-space(concat( $url,$query-string,$anchor-string ))"/>
	</xsl:function>	
	
</xsl:stylesheet>
