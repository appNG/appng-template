<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
	xmlns="http://www.appng.org/schema/platform" xmlns:ait="http://aiticon.de" xmlns:appng="http://appng.org"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc"
	xpath-default-namespace="http://www.appng.org/schema/platform">
	<xd:doc type="stylesheet">
		<xd:short>Master XSLT template, where all transformations begins.</xd:short>
		<xd:detail>
			<ul>
				<li>defines output settings and whitespace handling</li>
				<li>defines global variables generally for convenience</li>
				<li>includes further global xslt templates</li>
				<li>starts transformation via root element match</li>
			</ul>
		</xd:detail>
		<xd:author>Björn Pritzel</xd:author>
		<xd:copyright>2013, aiticon GmbH</xd:copyright>
	</xd:doc>
	
	<!-- 
		appNG core includes XSLT templates automatically and delete this xsl:include definitions, so just used for local XSLT development
	-->
	<xsl:include href="global.xsl"/>
	<xsl:include href="page.xsl"/>
	<xsl:include href="datasource.xsl"/>
	<xsl:include href="event.xsl"/>
	<xsl:include href="utils.xsl"/>
	
	<xd:doc>
		<xd:short>Generates XHTML 1.0 Transition documents</xd:short>
		<xd:detail>Indent is set to 'no' to avoid whitespace problems</xd:detail>
	</xd:doc>
	<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" encoding="UTF-8"
		indent="no" method="xhtml" omit-xml-declaration="yes"/>

	<xd:doc>
		Strips whitespace in all source elements
	</xd:doc>
	<xsl:strip-space elements="*"/>
	<xd:doc>
		Preserves whitespace in all ait:* elements
	</xd:doc>
	<xsl:preserve-space elements="ait:*"/>

	<xd:doc>
		Currently no character maps are used
	</xd:doc>
	<xsl:character-map name="special-characters">
	</xsl:character-map>

	<xd:doc>
		Is the default output-format being used?
	</xd:doc>
	<xsl:variable name="is-default-format" select="boolean(/platform/config/output-format[@id=$output-format]/@default)" as="xs:boolean"/>
	<xd:doc>
		Is the default output-type of the output-format beeing used?
	</xd:doc>
	<xsl:variable name="is-default-type"   select="boolean(/platform/config/output-format[@id=$output-format]/output-type[@id=$output-type]/@default)" as="xs:boolean"/>

	<xd:doc>
		Base URL path to manager application, usually /manager
	</xd:doc>
	<xsl:variable name="base-url"
		select="if ($is-default-format and $is-default-type) then (/platform/config/base-url)
			else (string-join((/platform/config/base-url, concat('_',$output-format), concat('_',$output-type)),'/')) cast as xs:anyURI" as="xs:anyURI"/>
	<xd:doc>
		Current URL path
	</xd:doc>
	<xsl:variable name="current-url" select="/platform/config/current-url" as="xs:string"/>
	<xd:doc>
		URL path token of current site
	</xd:doc>
	<xsl:variable name="current-site" select="/platform/navigation//item[@type='site' and @selected='true']/@ref" as="xs:string"/>
	<xd:doc>
		URL path token of current application
	</xd:doc>
	<xsl:variable name="current-application" select="/platform/navigation//item[@type='application' and @selected='true']/@ref" as="xs:string"/>
	<xd:doc>
		URL path to of current application
	</xd:doc>
	<xsl:variable name="current-applicationurl" select="string-join( ($base-url,$current-site,$current-application),'/' ) cast as xs:anyURI" as="xs:anyURI"/>
	<xd:doc>
		URL path to be used for reloading current page
	</xd:doc>
	<xsl:variable name="reload-url" as="xs:anyURI">
		<xsl:value-of select="if (ends-with($current-url,'/')) then $current-url else string-join(($current-url,'/'),'')"/>
	</xsl:variable>
	
	<xd:doc>
		Page URL schema
	</xd:doc>
	<xsl:variable name="page-urlschema" select="/platform/content/application/pages/page/config/url-schema"/>

	<xd:doc>
		Localization settings from subject node
	</xd:doc>
	<xsl:variable name="subject-localization" select="$subject/localization" as="element(*)"/>
	<xd:doc>
		Global localization settings beeing used, relies on $subject-localization
	</xd:doc>
	<xsl:variable name="localization" select="$subject-localization" as="element(*)"/>
	<xd:doc>
		Language according to subject localization
	</xd:doc>
	<xsl:variable name="subject-language" select="($subject-localization/language,'')[1]" as="xs:string"/>
	<xd:doc>
		Used document language relies on $subject-language
	</xd:doc>
	<xsl:variable name="language" select="$subject-language" as="xs:string"/>
	<xd:doc>
		Used document charset, defaults to utf-8
	</xd:doc>
	<xsl:variable name="charset" select="'utf-8'" as="xs:string"/>

	<xd:doc>
		All Permissions in the source document tree.
		Permissions are distincted via xsl:for-each-group selection 
	</xd:doc>
	<xsl:variable name="permissions" as="node()">
		<permissions>
			<!-- grouping for distinct permissions -->
			<xsl:for-each-group group-by="@ref" select="//permission">
				<xsl:copy-of select="."/>
			</xsl:for-each-group>
		</permissions>
	</xsl:variable>

	<xd:doc>
		Output format of template
	</xd:doc>
	<xsl:variable name="output-format" select="/platform/config/output/@format" as="xs:string"/>
	<xd:doc>
		Output type of template
	</xd:doc>
	<xsl:variable name="output-type" select="/platform/config/output/@type" as="xs:string"/>
	
	<xd:doc>
		Debug state, defaults to false
	</xd:doc>
    <xsl:variable name="debug" select="($permissions//permission[@ref eq 'debug'],false())[1]" as="xs:boolean"/>
	
	<xd:doc>
		application config node tree
	</xd:doc>
	<xsl:variable name="application-config" select="/platform/content/application/config"/>
	
	<xd:doc>
		Subject node tree
	</xd:doc>
	<xsl:variable name="subject" select="/platform/subject"/>
	
	<xd:doc>
		<xd:short>Master template, matchs to root element &lt;master&gt; and starts transformation of the source document tree</xd:short>
	</xd:doc>
	<xsl:template match="/platform" priority="-2.5">
		<html lang="{$language}" xml:lang="{$language}">
			<xsl:apply-templates mode="html-head" select="content"/>
			<xsl:apply-templates mode="html-body" select="content"/>
		</html>
	</xsl:template>
	
</xsl:stylesheet>
