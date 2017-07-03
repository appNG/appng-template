<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
	xmlns="http://www.appng.org/schema/platform" xmlns:ait="http://aiticon.de" xmlns:appng="http://appng.org"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc"
	xpath-default-namespace="http://www.appng.org/schema/platform">
	<xd:doc type="stylesheet">
		Datasource XSLT template, where the big data comes.
		Provides the element templates for processing datasources of the source document tree.
		
		Processing a datasource is mainly a top-down applying of the datasource elements.
		
		To support different display modes, custom templates, overwriting templates, etc. 
		we use mode, prioritisation and inheritance: 
		
		...
	</xd:doc>

	<xd:doc>
		<xd:short>datasource template which controls mode of further datasource template processing</xd:short>
	</xd:doc>
	<xsl:template match="element/datasource" priority="2.5">
		<xsl:param name="datasource-id" select="@id" as="xs:string"/>
		<xsl:param name="datasource-config" select="config" as="node()"/>
		<xsl:param name="datasource-data" select="data" as="node()"/>
		<xsl:param name="datasource-mode" select="if (@mode) then @mode else 'table'" as="xs:string"/>
		
		<xsl:param name="datasource-sort-name" select="string-join( ('sort',upper-case(substring($datasource-id,1,1)),substring($datasource-id,2) ),'' )" as="xs:string"/>
		<xsl:param name="datasource-sort-text" as="xs:string">
			<xsl:variable name="field-sort-text">
				<xsl:for-each select="$datasource-config/meta-data/field[(@hidden eq 'false' or not(@hidden)) and sort/@prio]">
					<xsl:sort select="sort/@prio" order="ascending"/>
					<xsl:if test="position() != 1">, </xsl:if>
					<xsl:apply-templates select="label"/>&#160;<xsl:value-of select="appng:search-label(sort/@order,$datasource-config/meta-data)"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="$field-sort-text"/>
		</xsl:param>
	
		<xsl:param name="datasource-message-nodata" as="node()">
			<messages>
				<message ref="{$datasource-id}" class="NOTICE">
					<xsl:value-of select="appng:search-label('label.nodata',$datasource-config)"/>
				</message>
			</messages>
		</xsl:param>
		
		<xsl:choose>
			<xsl:when test="$datasource-mode eq 'table'">
				<xsl:apply-templates select="." mode="table">
					<xsl:with-param name="datasource-id" select="$datasource-id" tunnel="yes"/>
					<xsl:with-param name="datasource-config" select="$datasource-config" tunnel="yes"/>
					<xsl:with-param name="datasource-data" select="$datasource-data" tunnel="yes"/>
					<xsl:with-param name="datasource-mode" select="$datasource-mode" tunnel="yes"/>
					<xsl:with-param name="datasource-sort-name" select="$datasource-sort-name" tunnel="yes"/>
					<xsl:with-param name="datasource-sort-text" select="$datasource-sort-text" tunnel="yes"/>
					<xsl:with-param name="datasource-message-nodata" select="$datasource-message-nodata" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$datasource-mode eq 'custom'">
				<xsl:apply-templates select="." mode="custom">
					<xsl:with-param name="datasource-id" select="$datasource-id" tunnel="yes"/>
					<xsl:with-param name="datasource-config" select="$datasource-config" tunnel="yes"/>
					<xsl:with-param name="datasource-data" select="$datasource-data" tunnel="yes"/>
					<xsl:with-param name="datasource-mode" select="$datasource-mode" tunnel="yes"/>
					<xsl:with-param name="datasource-sort-name" select="$datasource-sort-name" tunnel="yes"/>
					<xsl:with-param name="datasource-sort-text" select="$datasource-sort-text" tunnel="yes"/>
					<xsl:with-param name="datasource-message-nodata" select="$datasource-message-nodata" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="table">
					<xsl:with-param name="datasource-id" select="$datasource-id" tunnel="yes"/>
					<xsl:with-param name="datasource-config" select="$datasource-config" tunnel="yes"/>
					<xsl:with-param name="datasource-data" select="$datasource-data" tunnel="yes"/>
					<xsl:with-param name="datasource-mode" select="$datasource-mode" tunnel="yes"/>
					<xsl:with-param name="datasource-sort-name" select="$datasource-sort-name" tunnel="yes"/>
					<xsl:with-param name="datasource-sort-text" select="$datasource-sort-text" tunnel="yes"/>
					<xsl:with-param name="datasource-message-nodata" select="$datasource-message-nodata" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xd:doc>
		<xd:short>datasource template which assemblies all datasource elements who should be displayed</xd:short>
	</xd:doc>
	<xsl:template match="element/datasource" priority="-2.5" mode="#all">
		<xsl:param name="datasource-id" tunnel="yes"/>
		<xsl:param name="datasource-config" tunnel="yes"/>
		<xsl:param name="datasource-data" tunnel="yes"/>
		<xsl:param name="datasource-mode" tunnel="yes"/>
		
		<xsl:apply-templates select="$datasource-config/description" mode="#current"/>
		<xsl:apply-templates select="$datasource-data/resultset" mode="pagination"/>
		<xsl:apply-templates select="$datasource-data/selectionGroup" mode="#current"/>
		<xsl:apply-templates select="$datasource-config/linkpanel[ @location = ('top','both') ]" mode="#current"/>
		<xsl:apply-templates select="$datasource-data" mode="#current"/>
		<xsl:apply-templates select="$datasource-config/linkpanel[ @location = ('bottom','both') ]" mode="#current"/>
		<xsl:apply-templates select="$datasource-data/resultset" mode="pagination"/>
	</xsl:template>
	
	<xd:doc>
		<xd:short>datasource data template which controls further data template processing</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data" priority="2.5" mode="#all">
		<xsl:param name="datasource-id" tunnel="yes"/>
		<xsl:param name="datasource-config" tunnel="yes"/>
		<xsl:param name="datasource-sort-name" tunnel="yes"/>
		<xsl:param name="datasource-sort-text" tunnel="yes"/>
		<xsl:param name="datasource-message-nodata" tunnel="yes"/>
		<xsl:param name="tab-id" tunnel="yes"/>
		
		<xsl:choose>
			<xsl:when test="count(result) &gt; 0 or count(resultset/result) &gt; 0">
				<xsl:next-match/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$datasource-message-nodata"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xd:doc>
		<xd:short>datasource data template for mode table which generates table html structure</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data" priority="-2.25" mode="table">
		<xsl:param name="tab-id" tunnel="yes"/>
		<xsl:param name="datasource-config" tunnel="yes"/>
		<xsl:param name="datasource-sort-name" tunnel="yes"/>
		<xsl:param name="datasource-sort-text" tunnel="yes"/>

		<xsl:if test="string-length($datasource-sort-text) > 1">
			<div class="buttons_panel">
				<xsl:value-of select="appng:search-label('data.sort',$datasource-config/meta-data)"/>:&#160;<xsl:value-of select="$datasource-sort-text"/><a href="?{$datasource-sort-name}=reset#{$tab-id}" class="button only-icon btn_deleted">&#160;</a>
			</div>
		</xsl:if>
		<table rel="data-table">
			<tr>
				<xsl:apply-templates select="$datasource-config/meta-data/field[@hidden eq 'false' or not(@hidden)]" mode="#current"/>
			</tr>
			<xsl:next-match/>
		</table>
	</xsl:template>
	<xd:doc>
		<xd:short>datasource data template which controls further result/resultset processing</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data" priority="-2.5" mode="#all">
		<xsl:param name="datasource-config" tunnel="yes"/>
		<xsl:param name="datasource-sort-name" tunnel="yes"/>
		<xsl:param name="datasource-sort-text" tunnel="yes"/>
		<xsl:param name="tab-id" tunnel="yes"/>
		
		<xsl:apply-templates select="result | resultset" mode="#current"/>
	</xsl:template>

	<xd:doc>
		<xd:short>resultset template which transform a resultset into a paginated navigation</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data/resultset[count(result) > 0]" priority="-2.25" mode="pagination">
		<xsl:param name="datasource-data" tunnel="yes" />
		<xsl:param name="datasource-id" tunnel="yes" />
		<xsl:param name="datasource-config" tunnel="yes" />
		<xsl:param name="tab-id" tunnel="yes" />
		
		<xsl:choose>
			<xsl:when test="$datasource-data/@paginate eq 'true' or (not($datasource-data/@paginate))">
				<div class="pagination_panel">
					<div class="navigation">
						<xsl:call-template name="pagination">
							<xsl:with-param name="current-chunk" select="@chunk"/>
							<xsl:with-param name="first-chunk" select="@firstchunk" />
							<xsl:with-param name="prev-chunk" select="@previouschunk" />
							<xsl:with-param name="next-chunk" select="@nextchunk" />
							<xsl:with-param name="last-chunk" select="@lastchunk" />
							<xsl:with-param name="chunk-size" select="@chunksize" />
							<xsl:with-param name="datasource-id" select="$datasource-id"/>
							<xsl:with-param name="url-anchor" select="$tab-id" />
							<xsl:with-param name="chunk-split" select="if (@hits cast as xs:integer lt 1000) then 4 else 2" />
						</xsl:call-template>
						<span class="empty">&#160;</span>
					</div>
					<div class="chunksize">
						<xsl:call-template name="pagination-hits">
							<xsl:with-param name="resultset" select="."/>
						</xsl:call-template>
						<xsl:text> - </xsl:text>
						<xsl:call-template name="pagination-chunksize-switcher">
							<xsl:with-param name="current-chunksize" select="@chunksize" />
							<xsl:with-param name="datasource-id" select="$datasource-id" />
							<xsl:with-param name="url-anchor" select="$tab-id" />
						</xsl:call-template>
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<span class="empty">&#160;</span>
				<p class="clr">&#160;</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xd:doc>
		<xd:short>resultset template which applies further result elements</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data/resultset" priority="-2.5" mode="#all">
		<xsl:apply-templates select="result" mode="#current"/>
	</xsl:template>

	<xd:doc>
		<xd:short>result template which controls further result template processing</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data/result | datasource/data/resultset/result" priority="2.5" mode="#all">
		<xsl:param name="datasource-config" tunnel="yes"/>
		<xsl:param name="datasource-id" tunnel="yes"/>
		
		<xsl:param name="result-htmlid" select="string-join( ('result',$datasource-id,string(position())),'_' )" as="xs:string"/>
		<xsl:param name="result-selected" select="(@selected,false())[1]" as="xs:boolean"/>
		<xsl:param name="result-css-position" select="if (position() mod 2 &gt; 0) then 'line_0' else 'line_1'" as="xs:string"/>
		<xsl:param name="result-css-selected" select="if ($result-selected) then 'selected' else ''" as="xs:string"/>
		<xsl:param name="result-css" select="string-join( ($result-css-position,$result-css-selected),' ' )" as="xs:string"/>
		
		<xsl:param name="result-defaultlink" select="(linkpanel[@location eq 'inline']/link[@default eq 'true'][1]/@target,'')[1]" as="xs:string"/>
		<xsl:param name="result-defaultlink-mode" select="(linkpanel[@location eq 'inline']/link[@default eq 'true'][1]/@mode,'')[1]" as="xs:string"/>
		<xsl:param name="result-defaultlink-url" select="appng:get-absolute-url($result-defaultlink,$result-defaultlink-mode)" as="xs:string"/>
		<xsl:param name="result-defaultlink-newwindow" select="if ($result-defaultlink-mode eq 'extern') then true() else false()" as="xs:boolean"/>
		
		<xsl:next-match>
			<xsl:with-param name="result-htmlid" select="$result-htmlid" tunnel="yes"/>
			<xsl:with-param name="result-selected" select="$result-selected" tunnel="yes"/>
			<xsl:with-param name="result-css-position" select="$result-css-position" tunnel="yes"/>
			<xsl:with-param name="result-css-selected" select="$result-css-selected" tunnel="yes"/>
			<xsl:with-param name="result-css" select="$result-css" tunnel="yes"/>
			<xsl:with-param name="result-defaultlink" select="$result-defaultlink" tunnel="yes"/>
			<xsl:with-param name="result-defaultlink-mode" select="$result-defaultlink-mode" tunnel="yes"/>
			<xsl:with-param name="result-defaultlink-url" select="$result-defaultlink-url" tunnel="yes"/>
			<xsl:with-param name="result-defaultlink-newwindow" select="$result-defaultlink-newwindow" tunnel="yes"/>
		</xsl:next-match>
	</xsl:template>
	<xd:doc>
		<xd:short>result template for mode table which transform a result into a table row.</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data/result | datasource/data/resultset/result" priority="1.25" mode="table">
		<xsl:param name="datasource-config" tunnel="yes"/>
		<xsl:param name="datasource-id" tunnel="yes"/>
		
		<xsl:param name="result-htmlid" tunnel="yes"/>
		<xsl:param name="result-css" tunnel="yes"/>
		
		<tr class="{$result-css}" id="{$result-htmlid}">
			<xsl:next-match/>
		</tr>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data/result | datasource/data/resultset/result" priority="-2.5" mode="#all">
		<xsl:param name="datasource-config" tunnel="yes"/>
		
		<xsl:for-each select="field[
			some $field in self::node(),
			$metafield in $datasource-config/meta-data/field[@hidden ne 'true' or not(@hidden)]
			satisfies ( ($field/@name eq $metafield/@name) )
			]
			, linkpanel[
			some $linkpanel in self::node(),
			$metalinkpanel in $datasource-config/linkpanel[@location eq 'inline' and ( @hidden ne 'true' or not(@hidden) )]
			satisfies ( ($linkpanel/@id eq $metalinkpanel/@id) )
			]">
			<xsl:variable name="field-name" select="@name"/>
			
			<xsl:apply-templates select="." mode="#current">
				<xsl:with-param name="field-metadata" select="$datasource-config/meta-data/field[@name eq $field-name]" tunnel="yes"/>
				<xsl:with-param name="linkpanel-metadata" select="$datasource-config/linkpanel[@location eq 'inline']" tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/config/meta-data/field" priority="2.5" mode="#all">
		<xsl:param name="datasource-sort-name" tunnel="yes"/>
		<xsl:param name="tab-id" tunnel="yes"/>

		<xsl:param name="field-sortable" select="if (sort) then true() else false()" as="xs:boolean"/>
		<xsl:param name="field-sort-direction" select="if (sort and sort/@order eq 'asc') then 'desc' else 'asc'" as="xs:string"/>
		<xsl:param name="field-sort-param-change" select="string-join( ($datasource-sort-name,'=',@name,':',$field-sort-direction),'' )" as="xs:string"/>
		<xsl:param name="field-sort-param-reset" select="string-join( ($datasource-sort-name,'=',@name,':'),'' )" as="xs:string"/>
		<xsl:param name="field-sort-css-button" select="string-join( ('btn_sort_',(sort/@order,'default')[1]),'' )" as="xs:string"/>
		<xsl:param name="field-sort-css" select="string-join( ('button',$field-sort-css-button),' ' )" as="xs:string"/>

		<xsl:next-match>
			<xsl:with-param name="field-sortable" select="$field-sortable" tunnel="yes"/>
			<xsl:with-param name="field-sort-direction" select="$field-sort-direction" tunnel="yes"/>
			<xsl:with-param name="field-sort-param-change" select="$field-sort-param-change" tunnel="yes"/>
			<xsl:with-param name="field-sort-param-reset" select="$field-sort-param-reset" tunnel="yes"/>
			<xsl:with-param name="field-sort-css-button" select="$field-sort-css-button" tunnel="yes"/>
			<xsl:with-param name="field-sort-css" select="$field-sort-css" tunnel="yes"/>
		</xsl:next-match>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/config/meta-data/field" priority="1.25" mode="table">
		<th>
			<xsl:next-match/>
		</th>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/config/meta-data/field" priority="-2.5" mode="#all">
		<xsl:param name="datasource-id" tunnel="yes"/>
		<xsl:param name="tab-id" tunnel="yes"/>

		<xsl:param name="field-sortable" tunnel="yes"/>
		<xsl:param name="field-sort-css" tunnel="yes"/>
		<xsl:param name="field-sort-param-change" tunnel="yes"/>
		<xsl:param name="field-sort-param-reset" tunnel="yes"/>
		
		<xsl:choose>
			<xsl:when test="$field-sortable">
				<!-- link for changing sort directions -->
				<a class="{$field-sort-css}" href="{$current-url}?{$field-sort-param-change}#{$tab-id}">
					<xsl:apply-templates select="label" mode="#current"/>
				</a>
				<!-- link for reseting sort -->
				<xsl:if test="sort/@order">
					&#160;<a class="button only-icon btn_sort_cancel" href="{$current-url}?{$field-sort-param-reset}#{$tab-id}">&#160;</a>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="label" mode="#current"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/config/meta-data/field/label" priority="-2.25" mode="table">
		<xsl:apply-templates select="text()" mode="#current"/>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/config/meta-data/field/label" priority="-2.5" mode="#all">
		<xsl:apply-templates select="text()" mode="#current"/><xsl:if test="string-length(text()) &gt; 0">:&#160;</xsl:if>
	</xsl:template>

	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//field" priority="2.5" mode="#all">
		<xsl:param name="datasource-config" tunnel="yes"/>
		<xsl:param name="field-metadata" tunnel="yes"/>

		<xsl:param name="field-icons" select="icon"/>
		<xsl:param name="field-displaylength" select="if ($field-metadata/@displayLength &gt; 0) then $field-metadata/@displayLength else 80" as="xs:integer"/>
		<xsl:param name="field-value" select="value"/>
		<xsl:param name="field-value-label" select="if ($field-value = ('true','false')) then appng:search-label($field-value/text(), $datasource-config) else $field-value/text()" as="xs:string?"/>
		
		<xsl:next-match>
			<xsl:with-param name="field-icons" select="$field-icons" tunnel="yes"/>
			<xsl:with-param name="field-displaylength" select="$field-displaylength" tunnel="yes"/>
			<xsl:with-param name="field-value" select="$field-value" tunnel="yes"/>
			<xsl:with-param name="field-value-label" select="$field-value-label" tunnel="yes"/>
		</xsl:next-match>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data/result/field | datasource/data/resultset/result/field" priority="1.25" mode="table">
		<xsl:param name="result-defaultlink" tunnel="yes"/>
		<xsl:param name="result-defaultlink-url" tunnel="yes"/>
		<xsl:param name="result-defaultlink-newwindow" tunnel="yes"/>
		
		<td>
			<xsl:if test="$result-defaultlink ne ''">
				<xsl:attribute name="onclick">app.openUrl('<xsl:value-of select="$result-defaultlink-url"/>',<xsl:value-of select="$result-defaultlink-newwindow"/>);</xsl:attribute>
				<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
			</xsl:if>
			<xsl:next-match/>
		</td>
	</xsl:template>
	<xd:doc>
		<xd:short>TODU docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//field[@type eq 'file']" priority="-1.5" mode="#all">
		<xsl:param name="field-metadata" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		
		<xsl:param name="field-displaylength" select="if ($field-metadata/@displayLength &gt; 0) 
			then $field-metadata/@displayLength else 40" as="xs:integer"/>
		
		<xsl:call-template name="file-icon">
			<xsl:with-param name="file-name" select="$field-value"/>
			<xsl:with-param name="display-length" select="$field-displaylength"/>
		</xsl:call-template>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//field[@type eq 'boolean']" priority="-1.5" mode="#all">
		<xsl:param name="field-value-label" tunnel="yes"/>
		
		<xsl:apply-templates select="$field-value-label"/>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//field[@type eq 'image']" priority="-1.5" mode="#all">
		<xsl:param name="datasource-config" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		<xsl:param name="field-value-label" tunnel="yes"/>
		<xsl:param name="field-icons" tunnel="yes"/>

		<xsl:choose>
			<xsl:when test="$field-icons">
				<xsl:for-each select="$field-icons">
					<img border="0">
						<xsl:choose>
							<xsl:when test="./@type eq 'file'">
								<xsl:attribute name="src">
									<xsl:value-of select="./text()"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="src">/template/assets/spacer.png</xsl:attribute>
								<xsl:attribute name="class">icon ico_<xsl:value-of select="./text()"/></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="string-length($field-value-label) > 1">
							<xsl:attribute name="title"><xsl:value-of select="$field-value-label" /></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="$field-value-label" /></xsl:attribute>
						</xsl:if>
					</img>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<img border="0" src="{$field-value-label}" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//field[@type eq 'longtext']" priority="-1.5" mode="#all">
		<xsl:param name="field-metadata" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		
		<xsl:param name="field-displaylength" select="if ($field-metadata/@displayLength &gt; 0) then $field-metadata/@displayLength else 80" as="xs:integer"/>
		
		<span title="{normalize-space($field-value)}">
			<xsl:call-template name="replace-nl-to-br">
				<xsl:with-param name="string" select="appng:crop-by-length($field-value,$field-displaylength,'...')"/>
			</xsl:call-template>
		</span>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//field[@type eq 'text']" priority="-1.5" mode="#all">
		<xsl:param name="field-metadata" tunnel="yes"/>
		<xsl:param name="field-value" tunnel="yes"/>
		
		<xsl:param name="field-displaylength" select="if ($field-metadata/@displayLength &gt; 0) then $field-metadata/@displayLength else 40" as="xs:integer"/>
		
		<span title="{normalize-space($field-value)}">
			<xsl:value-of select="appng:crop-by-length($field-value,$field-displaylength,'...')"/>
		</span>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//field[contains(@type,'list:')]" priority="-1.5" mode="#all">

		<xsl:next-match/>
		<xsl:if test="field">
			<ul>
				<xsl:for-each select="field">
					<li>
						<xsl:apply-templates select="." mode="#current"/>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//field" priority="-2.5" mode="#all">
		<xsl:param name="field-value" tunnel="yes"/>
		
		<xsl:value-of select="$field-value/text()"/>
	</xsl:template>

	<xd:doc>
		<xd:short>SelectionGroup template, generates panel container and formular for a selectiongroup</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data/selectionGroup" priority="2.5" mode="#all">
		<xsl:param name="datasource-id" tunnel="yes"/>
		<xsl:param name="tab-id" tunnel="yes"/>
		
		<xsl:param name="selections" select="selection" as="element(selection)*"/>
		<xsl:param name="selectiongroup-htmlid" select="string-join( ('form_selection',$datasource-id,@id),'_' )" as="xs:string"/>
		<xsl:param name="selectiongroup-params" select="
			$page-urlschema/*/*[
			some $param in self::node(),
			$selection in $selections
			satisfies ( ($param/@name eq $selection/@id) )
			][text() != '']
			" as="element(*)*"/>
		<xsl:param name="selectiongroup-reseturl" select="appng:generate-reset-url('',$selectiongroup-params/@name,$tab-id)"/>
		
		<xsl:next-match>
			<xsl:with-param name="selectiongroup-htmlid" select="$selectiongroup-htmlid" tunnel="yes"/>
			<xsl:with-param name="selectiongroup-reseturl" select="$selectiongroup-reseturl" tunnel="yes"/>
		</xsl:next-match>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data/selectionGroup" priority="1.5" mode="#all">
		<div class="filter_panel">
			<xsl:next-match/>
			<p class="clr">&#160;</p>
		</div>
	</xsl:template>
	<xd:doc>
		<xd:short>SelectionGroup template, generates panel container and formular for a selectiongroup</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data/selectionGroup" priority="-1.5" mode="#all">
		<xsl:param name="tab-id" tunnel="yes"/>
		<xsl:param name="datasource-id" tunnel="yes"/>
		
		<xsl:param name="selectiongroup-htmlid" tunnel="yes"/>
		<xsl:param name="selectiongroup-reseturl" tunnel="yes"/>
		
		<form action="#{$tab-id}" method="get" name="{$selectiongroup-htmlid}">
			<input type="hidden" name="tab" value="{$tab-id}"/>
			
			<xsl:apply-templates select="selection" mode="#current"/>
			
			<input type="hidden" id="{$selectiongroup-htmlid}_ts" name="ts" value="0"/>
			<div class="buttons_panel">
				<a class="btn_save button" href="javascript:void(0)" title="{appng:search-label('submit',.)}" onclick="$('#{$selectiongroup-htmlid}_ts').val(new Date().getTime());app.submitForm('{$selectiongroup-htmlid}');">
					<xsl:value-of select="appng:search-label('submit',.)"/>
				</a>
				<a class="btn_reset button" title="{appng:search-label('reset',.)}" href="{$selectiongroup-reseturl}">
					<xsl:value-of select="appng:search-label('reset',.)"/>
				</a>
			</div>
		</form>
		<script type="text/javascript" language="javascript">
			$('form[name="<xsl:value-of select="$selectiongroup-htmlid"/>"]').bind('keypress', function(e) {
				if(e.keyCode==13){
					$('#<xsl:value-of select="$selectiongroup-htmlid"/>_ts').val(new Date().getTime());
					app.submitForm('<xsl:value-of select="$selectiongroup-htmlid"/>');}
			});
		</script>
	</xsl:template>

	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection" priority="2.5" mode="#all">
		<xsl:param name="selectiongroup-htmlid" tunnel="yes"/>
		<xsl:param name="selection-id" select="@id" as="xs:string"/>
		<xsl:param name="selection-name" select="$selection-id" as="xs:string"/>
		<xsl:param name="selection-htmlid" select="string-join( ('selection',$selection-id),'_' )" as="xs:string"/>
		<xsl:param name="selection-autosubmit" select="if (@autosubmit eq 'true') then true() else false()" as="xs:boolean"/>
		<xsl:param name="selection-autosubmit-js" select="if ($selection-autosubmit) 
			then concat('javascript:void(0);return app.submitForm(''',$selectiongroup-htmlid,''');') 
			else ''" as="xs:string"/>
		<xsl:param name="selection-format" select="@format" as="xs:string?"/>
		
		<xsl:next-match>
			<xsl:with-param name="selection-id" select="$selection-id" tunnel="yes"/>
			<xsl:with-param name="selection-name" select="$selection-name" tunnel="yes"/>
			<xsl:with-param name="selection-htmlid" select="$selection-htmlid" tunnel="yes"/>
			<xsl:with-param name="selection-autosubmit" select="$selection-autosubmit" tunnel="yes"/>
			<xsl:with-param name="selection-autosubmit-js" select="$selection-autosubmit-js" tunnel="yes"/>
			<xsl:with-param name="selection-format" select="$selection-format" tunnel="yes"/>
		</xsl:next-match>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection" priority="1.5" mode="#all">
		<div class="filter_item">
			<xsl:next-match/>
		</div>
	</xsl:template>
	<xd:doc>
		<xd:short>
			Selection template, transform selection into a select element
		</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection[@type eq 'select' or @type eq 'select:multiple' or not(@type)]" priority="-1.45" mode="#all">
		<xsl:param name="datasource-id" tunnel="yes"/>
		<xsl:param name="selectiongroup-hmtlid" tunnel="yes"/>
		
		<xsl:param name="selection-name" tunnel="yes"/>
		<xsl:param name="selection-htmlid" tunnel="yes"/>
		<xsl:param name="selection-autosubmit" tunnel="yes"/>
		<xsl:param name="selection-autosubmit-js" tunnel="yes"/>
		
		<xsl:apply-templates select="title" mode="#current"/>
		<select id="{$selection-htmlid}" name="{$selection-name}">
			<xsl:if test="$selection-autosubmit">
				<xsl:attribute name="onchange" select="$selection-autosubmit-js"/>
			</xsl:if>
			<xsl:if test="@type eq 'select:multiple'">
				<xsl:attribute name="multiple" select="'multiple'"/>
			</xsl:if>
			<xsl:next-match/>
		</select>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection" priority="-1.5" mode="#all">
		<xsl:apply-templates select="title" mode="#current"/>
		<xsl:apply-templates select="option | optionGroup" mode="#current"/>
	</xsl:template>

	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection[@type = ('date','text')]/title" priority="-1.25" mode="#all">
		<xsl:param name="selection-htmlid" tunnel="yes"/>
		<xsl:param name="option-htmlid" select="string-join( ($selection-htmlid,../option[1]/@name),'_' )" as="xs:string"/>
		
		<label for="{$option-htmlid}">
			<xsl:apply-templates select="text()"/>: 
		</label>
	</xsl:template>
	<xd:doc>
		<xd:short>TODO docu</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection/title" priority="-1.5" mode="#all">
		<xsl:param name="selection-htmlid" tunnel="yes"/>
		
		<label for="{$selection-htmlid}">
			<xsl:apply-templates select="text()"/>: 
		</label>
	</xsl:template>

	<xd:doc>
		<xd:short>Builds an option for a selection</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection//option" priority="2.5" mode="#all">
		<xsl:param name="selection-htmlid" tunnel="yes"/>
		<xsl:param name="selection-id" tunnel="yes"/>
		<xsl:param name="option-name" select="@name" as="xs:string?"/>
		<xsl:param name="option-htmlid" select="string-join( ($selection-htmlid,$option-name),'_' )" as="xs:string"/>
		<xsl:param name="option-value" select="@value" as="xs:string?"/>
		<xsl:param name="option-selected" select="if (@selected eq 'true' or not(@selected)) then true() else false()" as="xs:boolean"/>
		
		<xsl:next-match>
			<xsl:with-param name="option-name" select="$option-name" tunnel="yes"/>
			<xsl:with-param name="option-htmlid" select="$option-htmlid" tunnel="yes"/>
			<xsl:with-param name="option-value" select="$option-value" tunnel="yes"/>
			<xsl:with-param name="option-selected" select="$option-selected" tunnel="yes"/>
			<xsl:with-param name="selection-id" select="$selection-id" tunnel="yes"/>
		</xsl:next-match>
	</xsl:template>
	<xd:doc>
		<xd:short>
			Option with @type select/select:multiple template, transform option to a option element
		</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection[@type eq 'select' or @type eq 'select:multiple' or not(@type)]//option" priority="-1.5" mode="#all">
		<xsl:param name="option-name" tunnel="yes"/>
		<xsl:param name="option-value" tunnel="yes"/>
		<xsl:param name="option-selected" tunnel="yes"/>
		
		<option value="{$option-value}">
			<xsl:if test="$option-selected">
				<xsl:attribute name="selected" select="'selected'"/>
			</xsl:if>
			<xsl:value-of select="$option-name"/>
		</option>
	</xsl:template>
	<xd:doc>
		<xd:short>Option with @type *date template, transform option to a datetimepicker</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection[contains(@type,'date')]//option" priority="-1.5" mode="#all">
		<xsl:param name="selectiongroup-htmlid" tunnel="yes"/>
		<xsl:param name="selection-htmlid" tunnel="yes"/>
		<xsl:param name="selection-id" tunnel="yes"/>
		<xsl:param name="selection-autosubmit" tunnel="yes"/>
		<xsl:param name="selection-format" tunnel="yes"/>
		<xsl:param name="option-htmlid" tunnel="yes"/>
		<xsl:param name="option-name" tunnel="yes"/>
		<xsl:param name="option-value" tunnel="yes"/>
		
		<xsl:call-template name="datetime-picker">
			<xsl:with-param name="form-id" select="$selectiongroup-htmlid"/>
			<xsl:with-param name="id" select="$option-htmlid"/>
			<xsl:with-param name="name" select="$selection-id"/>
			<xsl:with-param name="next-id" select="
				if ( following-sibling::option[1]/@name != '' ) then
				string-join( ($selection-htmlid,following-sibling::option[1]/@name),'_' )
				else ''"/>
			<xsl:with-param name="datetime" select="$option-value"/>
			<xsl:with-param name="auto-submit" select="$selection-autosubmit"/>
			<xsl:with-param name="datetime-format" select="($selection-format,'yyyy-MM-dd')[1]"/>
		</xsl:call-template>
	</xsl:template>
	<xd:doc>
		<xd:short>Option with @type radio, transform option to radio input element</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection[@type eq 'radio']//option" priority="-1.5" mode="#all">
		<xsl:param name="option-name" tunnel="yes"/>
		<xsl:param name="option-htmlid" tunnel="yes"/>
		<xsl:param name="selection-id" tunnel="yes"/>
		<xsl:param name="option-value" tunnel="yes"/>
		<xsl:param name="option-selected" tunnel="yes"/>

		<input name="{$selection-id}" type="radio" value="{$option-value}">
			<xsl:if test="$option-selected">
				<xsl:attribute name="checked" select="'checked'"/>
			</xsl:if>
		</input>
		<xsl:value-of select="$option-name"/>
	</xsl:template>
	<xd:doc>
		<xd:short>Option with @type checkbox, transform option to checkbox input element</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection[@type eq 'checkbox']//option" priority="-1.5" mode="#all">
		<xsl:param name="option-name" tunnel="yes"/>
		<xsl:param name="option-htmlid" tunnel="yes"/>
		<xsl:param name="option-value" tunnel="yes"/>
		<xsl:param name="option-selected" tunnel="yes"/>
		<xsl:param name="selection-id" tunnel="yes"/>
		
		<input name="{$selection-id}" type="checkbox" value="{$option-value}">
			<xsl:if test="$option-selected">
				<xsl:attribute name="checked" select="'checked'"/>
			</xsl:if>
		</input>
		<xsl:value-of select="$option-name"/>
	</xsl:template>
	<xd:doc>
		<xd:short>Option with @type text, transform option to text input element</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection//option" priority="-2.5" mode="#all">
		<xsl:param name="option-name" tunnel="yes"/>
		<xsl:param name="option-htmlid" tunnel="yes"/>
		<xsl:param name="option-value" tunnel="yes"/>
		<xsl:param name="selection-id" tunnel="yes"/>
		<input class="text" name="{$selection-id}" id="{$option-htmlid}" type="text" value="{$option-value}"/>
	</xsl:template>
	
	<xd:doc>
		<xd:short>Optiongroup template, transform optiongroup to optiongroup element</xd:short>
	</xd:doc>
	<xsl:template match="datasource/data//selection/optionGroup" priority="-2.5" mode="#all">
		<xsl:param name="optiongroup-label" select="label"/>
		
        <optgroup label="{label}">
            <xsl:apply-templates select="option" mode="#current"/>
        </optgroup>
	</xsl:template>
	
	<xd:doc>
		linkpanel for a datasource result
	</xd:doc>
	<xsl:template match="datasource/data//result/linkpanel[@location eq 'inline']" priority="-1.25" mode="table">
		<xsl:param name="linkpanel-metadata" select="."/>
		
		<td>
			<xsl:apply-templates select="link">
				<xsl:with-param name="linkpanel-metadata" select="$linkpanel-metadata" tunnel="yes"/>
			</xsl:apply-templates>
		</td>
	</xsl:template>
	<xd:doc>
		<xd:short>
			linkpanel for a datasource 
		</xd:short>
	</xd:doc>
	<xsl:template match="datasource/config/linkpanel[@location = ('top','bottom','both')]" priority="-1.5" mode="#all">
		<xsl:param name="linkpanel-metadata" select="."/>
		
		<div class="buttons_panel">
			<div class="center">
				<xsl:apply-templates select="link" mode="#current">
					<xsl:with-param name="linkpanel-metadata" select="$linkpanel-metadata" tunnel="yes"/>
				</xsl:apply-templates>
			</div>
			<p class="clr">&#160;</p>
		</div>
	</xsl:template>

	<xd:doc>
		<xd:short>
			TODU docu 
		</xd:short>
	</xd:doc>
	<xsl:template match="datasource//linkpanel/link" mode="#all" priority="-2.5">
		<xsl:param name="linkpanel-metadata" tunnel="yes"/>
		<xsl:param name="linkpanel-location" select="$linkpanel-metadata/@location" as="xs:string"/>
		
		<xsl:param name="link-confirmation" select="( replace(string(confirmation),'''','\\'''), '' )[1]" as="xs:string"/>
		<xsl:param name="link-target" select="@target" as="xs:anyURI?"/>
		<xsl:param name="link-url" select="if ($link-target) then appng:get-absolute-url(@target,@mode) else ''" as="xs:string"/>
		<xsl:param name="link-css-icon" select="if (icon/@type='file') then '' else concat('btn_',icon/text())"/>
		<xsl:param name="link-css-onlyicon" select="if ($linkpanel-location eq 'inline') then 'only-icon' else ''" as="xs:string"/>
		<xsl:param name="link-css" select="string-join( ('button',$link-css-icon,$link-css-onlyicon),' ' )" as="xs:string"/>
		<xsl:param name="link-mode" select="@mode" as="xs:string"/>
		<xsl:param name="link-disabled" select="if (@disabled eq 'true') then true() else false()" as="xs:boolean"/>
		
		<a title="{normalize-space(label)}" target="{if ($link-mode eq 'intern') then '_self' else '_blank'}">
			<xsl:attribute name="class" select="if ($link-disabled) then string-join(($link-css, 'inactive'), ' ') else $link-css"/>
			<xsl:if test="icon/@type='file'">
				<xsl:attribute name="style" select="string-join(('background-image:url(&quot;',icon/text(),'&quot;)'),'')" />
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$link-disabled ne true() and $link-confirmation ne ''">
					<xsl:attribute name="href" select="'javascript:void(0);'"/>
					<xsl:attribute name="onclick" select="concat( 'app.showDialog(''',$link-url ,''' ,''',$link-confirmation,''');')"/>
				</xsl:when>
				<xsl:when test="$link-disabled ne true() and $link-confirmation eq ''">
					<xsl:attribute name="href" select="$link-url"/>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="$linkpanel-location ne 'inline'">
				<xsl:apply-templates select="label" mode="#current"/>
			</xsl:if>
		</a>
	</xsl:template>
	
</xsl:stylesheet>
