<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
	xmlns="http://www.appng.org/schema/platform" xmlns:ait="http://aiticon.de" xmlns:appng="http://appng.org"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc"
	xpath-default-namespace="http://www.appng.org/schema/platform">
	<xd:doc type="stylesheet">
		<xd:short>Page XSLT templates, where your html page comes.</xd:short>
		<xd:detail>
			<p>XSLT templates who mainly generates the html main structure of the target document.</p>
			
			<p>Content element is transformered via two modes:</p>
			<ul>
				<li>html-head: generates html head with meta informations, title, CSS and JS, etc.</li>
				<li>html-body: generates html body and main structure of the html page</li>
			</ul>
		</xd:detail>
	</xd:doc>

	<xd:doc>
		<xd:short>content template which generates the html head</xd:short>
	</xd:doc>
	<xsl:template match="content" priority="-2.5" mode="html-head">
		<head>
			
			<title>
				<xsl:value-of select="string-join( (/platform/config/title,/platform/navigation//item[@selected eq 'true'][1]/label),' - ' )"/>
			</title>
			<meta content="text/html; charset={$charset}" http-equiv="content-type"/>
			<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
			<meta content="{$language}" name="language"/>

			<meta content="{../config/author}" name="author"/>
			<meta content="{../config/author}" name="publisher"/>
			<meta content="{../config/author}, Frankfurt am Main" name="copyright"/>
			<meta content="noindex,nofollow" name="robots"/>

			<link href="/template/resources/tools_stylesheet_screen.css" rel="stylesheet"
				type="text/css"/>
			<xsl:text disable-output-escaping="yes">
			<![CDATA[
				<!--[if IE 7]>
					<link rel="stylesheet" type="text/css" href="/template/resources/tools_stylesheet_screen_ie7.css" media="screen" />
				<![endif]--> 
				<!--[if IE 6]>
					<link rel="stylesheet" type="text/css" href="/template/resources/tools_stylesheet_screen_ie6.css" media="screen" />
				<![endif]-->
			]]>
			</xsl:text>
			
			<link href="/template/resources/tools_stylesheet_jquery-ui-1.8.22.custom.css" rel="stylesheet" type="text/css"/>
			<link href="/template/resources/tools_stylesheet_default_theme.css" rel="stylesheet" type="text/css"/>
			
			<link rel="shortcut icon" href="/template/assets/favicon.ico" type="image/x-icon"/>
			
			<script language="javascript" src="/template/resources/tools_javascript_jquery.js" type="text/javascript"/>
			<script language="javascript" src="/template/resources/tools_javascript_jquery-ui.js" type="text/javascript"/>
			<script language="javascript" src="/template/resources/tools_javascript_jquery_tree.js" type="text/javascript"/>
			<script language="javascript" src="/template/resources/tools_javascript_jquery_format-1.2.min.js" type="text/javascript"/>
			<script language="javascript" src="/template/resources/tools_javascript_timepicker.js" type="text/javascript"/>
			
			<xsl:if test="$language != 'en'">
				<script language="javascript" type="text/javascript" src="/template/resources/i18n/jquery-ui-datepicker-{$language}.js"/>
				<script language="javascript" type="text/javascript" src="/template/resources/i18n/jquery-ui-timepicker-{$language}.js"/>
			</xsl:if>

			<script type="text/javascript" src="/template/resources/shCore.js"/>
			<script type="text/javascript" src="/template/resources/shBrushXml.js"/>
			<link href="/template/resources/tools_stylesheet_shCoreDefault.css" rel="stylesheet" type="text/css"/>
			
			<script language="javascript" src="/template/resources/tools_javascript_jquery-picklist.min.js" type="text/javascript" ></script>
			<script language="javascript" src="/template/resources/tools_javascript_prettify.js" type="text/javascript" ></script>
			<script language="javascript" src="/template/resources/tools_javascript_jquery.multiselect.min.js" type="text/javascript" ></script>

			<script language="javascript" src="/template/resources/tools_javascript_ait_slideBox.js" type="text/javascript"/>
			<script language="javascript" src="/template/resources/tools_javascript_ait_lightwindow.js" type="text/javascript"/>
			<script language="javascript" src="/template/resources/tools_javascript_ait_tabBox.js" type="text/javascript"/>
			<script language="javascript" src="/template/resources/tools_javascript_ait-syntaxHighlighter.js" type="text/javascript" />
			<script language="javascript" src="/template/resources/tools_javascript_ait_form.js" type="text/javascript"/>		
			<script language="javascript" src="/template/resources/tools_javascript_ait_manager.js" type="text/javascript"/>
			
			<script type="text/javascript" src="/template/resources/tiny_mce/jquery.tinymce.js"></script>
			<script type="text/javascript" src="/template/resources/tiny_mce/tiny_mce.js"></script>
			<script type="text/javascript" src="/template/resources/tools_javascript_autosize.js"></script>
			
		</head>
	</xsl:template>

	<xd:doc>
		<xd:short>content template which generates the html body and main structure of the html page</xd:short>
		<xd:detail>
			<p>The main structure of the html page contains:</p>
			<ul>
				<li>Left:
					<ul>
						<li>HTML Markup for template-logo</li>
						<li>Generates navigation for sites and user related links via navigation element (mode = navigation-site, navigation-user)</li>
						<li>Generates user infobox</li>
					</ul>
				</li>
				<li>Right:
					<ul>
						<li>Generates navigation for pages of the current active application</li>
						<li>Transforms page sections as a tab-box containing all section elements (datasources/actions)</li>
						<li>
							Footer:
							<ul>
								<li>Outputs copyright information</li>
								<li>Initialises javascript objects (tab-box, syntaxhighlighter, lightwindow, ...)</li>
							</ul>
						</li>
					</ul>
				</li>
			</ul>
		</xd:detail>
	</xd:doc>
	<xsl:template match="content" priority="-2.5" mode="html-body">
		<xsl:param name="subject-ico" select="($subject/name,$subject/username,'anonymous')[1]" as="xs:string"/>
		
		<body>
			<div id="container">
				<table border="0" id="positioner">
					<tr>
						<td id="left">
							<div id="logo">
								<a href="{$base-url}">
									<img alt="" border="" height="110" src="/template/assets/logo_trans.png" title="" width="220"/>
								</a>
							</div>

							<!-- site navigation -->
							<xsl:apply-templates select="../navigation" mode="navigation-site"/>

							<div id="box_info">
								<div class="wrapper">
									<table>
										<!-- user infobox -->
										<tr>
											<td class="col1">
												<img alt="{$subject-ico}" title="{$subject-ico}" border="0" class="icon ico_user" src="/template/assets/spacer.png"/>
											</td>
											<td class="col2">
												<span class="head">
													<xsl:value-of select="appng:search-label('logged.in',.)"/>:
												</span>
												<xsl:text disable-output-escaping="yes"><![CDATA[<br/>]]></xsl:text>
												<span>
													<xsl:apply-templates select="$subject/username"/>
													<xsl:text disable-output-escaping="yes"><![CDATA[<br/>]]></xsl:text>
													<xsl:apply-templates select="$subject/name"/>
												</span>
											</td>
										</tr>

										<!-- output-format and -type switcher -->
										<xsl:if	test="count(
											/platform/config/output-format[@id eq $output-format]
											/output-type[.//permission[@mode eq 'set' and text() eq 'true']]) &gt; 1 
											and /platform/content/*">
											<tr>
												<td class="col1"/>
												<td class="col2">
												<span class="head">
													<xsl:value-of select="appng:search-label('switch.output-type',.)"/>:
												</span>
												<xsl:text disable-output-escaping="yes"><![CDATA[<br/>]]></xsl:text>
												<xsl:for-each select="/platform/config/output-format[@id eq $output-format]/output-type[.//permission[@mode eq 'set' and text() eq 'true']]">
													<span class="text">
														<a href="{string-join(($base-url,string-join(('_',$output-format),''),string-join(('_',@id),''),$current-site,$current-application),'/')}">
															<xsl:choose>
																<xsl:when test="@id eq $output-type">
																	<xsl:attribute name="style">text-decoration: underline;</xsl:attribute>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:attribute name="style">color: #ccc;</xsl:attribute>
																</xsl:otherwise>
															</xsl:choose>
															<xsl:value-of select="appng:search-label(permissions/permission/@ref,.)"/>
														</a>
													</span>
													<xsl:text disable-output-escaping="yes"><![CDATA[<br/>]]></xsl:text>
												</xsl:for-each>
												</td>
											</tr>
										</xsl:if>

										<!-- root anchor navigation -->
										<xsl:apply-templates select="../navigation" mode="navigation-user"/>
									</table>
								</div>
							</div>
						</td>
						<td id="right">
							<div id="lock"/>
							<div id="content">
								<xsl:apply-templates select="application/pages/page"/>
							</div>
							<div id="footer">
								&#169; appNG <xsl:value-of select="/platform/@version" /> with 
								<xsl:value-of select="application/@id" />&#160;<xsl:value-of select="application/@version" />
							</div>
							<script language="javascript" type="text/javascript">
								<xsl:text disable-output-escaping="yes">
								<![CDATA[
								function initGlobalTabBox() {
									var config = {
										id: 'tab_box',
										buttonPanelId: "buttons_panel_js",
										itemClass: 'tab_box_item',
										itemTitleClass: 'tab_buttons_panel',
										buttonPrefixTemplate:  '',
										buttonSuffixTemplate: ''
									}
									tabBox.addItem(config);
									var tabName = '';
									if (!tabName) tabName = app.getURLVar('tab'); 
									if (app.getAnchorFromURL() != '') tabName = app.getAnchorFromURL();
									tabBox.activateTabByName(tabName);
								}
								$(document).ready(function(){ 
									if(typeof richTextItems != 'undefined'){
										var elements ="";
										for (var i = 0; i < richTextItems.length; i++) {
											elements = elements + ((elements != '')? ',':'') + richTextItems[i].selector.replace('#', '');
										}
										for (var i = 0; i < richTextItems.length; i++) {
											app.initRichTextEditor(richTextItems[i].selector, richTextItems[i].options, elements);
										}
									}else{
										initGlobalTabBox();
									}
																
								syntaxHighlighter.initGlobal();
								
								lightwindow.init( {
											overlayId: 'overlay',
											lightwindowId: 'lightwindow',
											lightwindowTopDelta: 70,
											overlayOnClick: function(){ lightwindow.hide(); }
								});
								
								app.preloadImages(['/template/assets/bg.gif','/template/assets/overlay.png','/template/assets/ajax-loader.gif']);
								
								app.setLabels({
									inProcess: ']]></xsl:text><xsl:value-of select="appng:search-label('in.process',.)"/><xsl:text disable-output-escaping="yes"><![CDATA[',
									buttonYes: ']]></xsl:text><xsl:value-of select="appng:search-label('yes',.)"/><xsl:text disable-output-escaping="yes"><![CDATA[',
									buttonNo: ']]></xsl:text><xsl:value-of select="appng:search-label('no',.)"/><xsl:text disable-output-escaping="yes"><![CDATA[',
									buttonAbort: ']]></xsl:text><xsl:value-of select="appng:search-label('abort',.)"/><xsl:text disable-output-escaping="yes"><![CDATA[',
									buttonRejectUpdates: ']]></xsl:text><xsl:value-of select="appng:search-label('reject.updates',.)"/><xsl:text disable-output-escaping="yes"><![CDATA[',
									uploadedItem: ']]></xsl:text><xsl:value-of select="appng:search-label('uploaded.item',.)"/><xsl:text disable-output-escaping="yes"><![CDATA[',
									uploadedItems: ']]></xsl:text><xsl:value-of select="appng:search-label('uploaded.items',.)"/><xsl:text disable-output-escaping="yes"><![CDATA[',
									buttonClose: ']]></xsl:text><xsl:value-of select="appng:search-label('close',.)"/><xsl:text disable-output-escaping="yes"><![CDATA[',
									previewText: ']]></xsl:text><xsl:value-of select="appng:search-label('preview.text',.)"/><xsl:text disable-output-escaping="yes"><![CDATA['
								});
								
								});
								]]></xsl:text>
							</script>
						</td>
					</tr>
				</table>
			</div>
		</body>
	</xsl:template>

	<xd:doc>
		<xd:short>page template which assemblies the main content structure</xd:short>
		<xd:detail>
			<ul>
				<li>Applies application title</li>
				<li>Applies linkpanel[@location = top] which represents a page navigation of the current application</li>
				<li>Applies page description</li>
				<li>Applies page messages</li>
				<li>Applies sections</li>
				<li>Generates tab-box with debug functions</li>
				<li>Applies linkpanel[@location = bottom], currently unused</li>
			</ul>
		</xd:detail>
	</xd:doc>
	<xsl:template match="page" priority="-2.5">
		<xsl:param name="page-config" select="config"/>
		<xsl:param name="page-mode" select="$page-config/mode/@id"/>
		
		<div class="heading">
			<h2>
				<xsl:apply-templates select="../../config/title"/>
			</h2>
			<xsl:apply-templates select="config/linkpanel[@location='top']"/>
		</div>
		
		<div class="hr"/>
		
		<xsl:apply-templates select="config/description"/>
		
		<div class="tab_buttons_panel" id="buttons_panel_js"> </div>
		<div id="tab_box">
			<xsl:apply-templates select="messages"/>
			<p class="clr">&#160;</p>
			
			<!-- sections -->
			<xsl:apply-templates select="structure/section[not(@hidden eq 'true')]"/>

			<!-- section debug -->
			<xsl:if test="$debug">
				<div class="tab_box_item" id="tab_debug" rel="tab_debug">
					<div class="tab_buttons_panel">
						<ul>
							<li class="selected">
								<a class="option" href="#tab_debug">
									<span>
										Debug
									</span>
								</a>
							</li>
						</ul>
						<p class="clr">&#160;</p>
					</div>
					<div class="envtreeScroll" id="xml_syntaxhighlighter">
						<pre class='brush: xml; toolbar: false;'><xsl:apply-templates select="/platform" mode="formattedtext"/></pre>
					</div>
				</div>
			</xsl:if>
			
			<xsl:apply-templates select="config/linkpanel[@location='bottom']"/>
		</div>
	</xsl:template>
	
	<xd:doc>
		<xd:short>section template which transforms a section to an tabbed-box representation</xd:short>
		<xd:detail>
			<p>Each tab-box contains a tab-buttons-panel and applies all further section elements</p>
			<ul>
				<li>section-title is per default the title or the first valid (not @passive and has a title text node) element / element-child title</li>
				<li>section-id is per default the first valid (not @passive and has a title text node) element id</li>
				<li>section-htmlid is per default the section-id prefixed with string 'tab_'</li>
			</ul>
			<p>For </p>
		</xd:detail>
	</xd:doc>
	<xsl:template match="page/structure/section" priority="-2.5">
		<xsl:param name="section-title" select="
			if ( string-length( 
				( title/text(),element[@passive ne 'true' or (not (@passive))][1]/title/text(),element[@passive ne 'true' or (not (@passive))][1]/*/config/title/text() )[1]
			) gt 1)
			then ( title/text(),element[@passive ne 'true' or (not (@passive))][1]/title/text(),element[@passive ne 'true' or (not (@passive))][1]/*/config/title/text() )[1]
			else 'unknown_section_title'" as="xs:string"/>
		<xsl:param name="section-id" select="(element[@passive ne 'true' or (not (@passive))][1]/*/@id,'unknown')[1]" as="xs:string"/>
		<xsl:param name="section-htmlid" select="string-join(('tab',$section-id),'_')" as="xs:string"/>

		<div class="tab_box_item" id="{$section-htmlid}" rel="{$section-htmlid}">
			<div class="tab_buttons_panel">
				<ul>
					<li class="selected">
						<a class="option" href="#{$section-htmlid}">
							<span>
								<xsl:value-of select="$section-title"/>
							</span>
						</a>
					</li>
				</ul>
				<p class="clr">&#160;</p>
			</div>
			<xsl:apply-templates select="element">
				<xsl:with-param name="tab-id" select="$section-htmlid" tunnel="yes"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>
	
	<xd:doc>
		<xd:short>section/element template which assemblies the structure of an section/element</xd:short>
		<xd:detail>
			<ul>
				<li>Applies all element messages</li>
				<li>Generates html strucuture for head and body of an element</li>
				<li>If element is foldable, slidebox javascript is initialised</li>
			</ul>
		</xd:detail>
	</xd:doc>
	<xsl:template match="page/structure/section/element" priority="-2.5">
		<xsl:param name="tab-id" tunnel="yes"/>
		
		<xsl:param name="element-abs-position" as="xs:integer">
			<xsl:number level="any"/>
		</xsl:param>
		
		<xsl:param name="element-id" select="(*[1]/@id,'unknown_element')[1]" as="xs:string"/>
		<xsl:param name="element-htmlid" select="string-join((name(*[1 and @id]),$element-id,string($element-abs-position)),'_')" as="xs:string"/>
		
		<xsl:param name="element-foldable" select="(exists(@folded),false())[1]" as="xs:boolean"/>
		<xsl:param name="element-folded" select="(@folded,false())[1]" as="xs:boolean"/>
		<xsl:param name="element-passive" select="(@passive,false())[1]" as="xs:boolean"/>

		<xsl:param name="element-title" select="
			if ( string-length( 
			( title/text(),(datasource/config/title/text()|action/config/title/text())[1] )[1]
			) gt 1)
			then ( title/text(),(datasource/config/title/text()|action/config/title/text())[1] )[1]
			else 'unknown_element_title'" as="xs:string"/>

		<!-- element debug xml view -->
		<xsl:if test="$debug">
			<xsl:call-template name="debug-console">
				<xsl:with-param name="sources" select="."/>
			</xsl:call-template>
		</xsl:if>

		<!-- element message -->
		<xsl:apply-templates select="datasource/messages | action/messages"/>

		<!-- element head -->
		<div id="{$element-htmlid}">
			<div class="element_set">
				<div class="head">
					<xsl:if test="$element-foldable">
						<div class="switchIconOpen" id="{$element-htmlid}-switchIcon"/>
					</xsl:if>
					<span class="title">
						<xsl:if test="$element-foldable">
							<xsl:attribute name="style">cursor: pointer</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$element-title"/>
					</span>
				</div>
			</div>
		</div>
		
		<!-- element body -->
		<div id="{$element-htmlid}_a">
			<xsl:apply-templates select="datasource | action"/>
		</div>
		
		<xsl:if test="$element-foldable">
			<script language="javascript" type="text/javascript">
				slideBox.init('<xsl:value-of select="$element-htmlid"/>', {listType:0});
				slideBox.addItem('<xsl:value-of select="$element-htmlid"/>','<xsl:value-of select="$element-htmlid"/>','<xsl:value-of select="$element-folded"/>');
			</script>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		<xd:short>page linkpanel template which controls generation of the page navigation</xd:short>
		<xd:detail>
			<p>If count of page links is greater than five, further page links are displayed as select option</p>
		</xd:detail>
	</xd:doc>
	<xsl:template match="page/config/linkpanel" priority="-2.5">
		<xsl:param name="linkpanel-metadata" select="."/>
		<xsl:param name="linkpanel-maxLinks" select="6" as="xs:integer"/>
		<xsl:param name="linkpanel-countLinks" select="count(link)" as="xs:integer"/>
		
		<div class="navigation_page">
			<xsl:apply-templates select="link[position() lt $linkpanel-maxLinks]">
				<xsl:with-param name="linkpanel-metadata" select="$linkpanel-metadata" tunnel="yes"/>
			</xsl:apply-templates>
			<xsl:choose>
				<xsl:when test="$linkpanel-countLinks eq $linkpanel-maxLinks">
					<xsl:apply-templates select="link[position() eq $linkpanel-maxLinks]">
						<xsl:with-param name="linkpanel-metadata" select="$linkpanel-metadata" tunnel="yes"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$linkpanel-countLinks gt $linkpanel-maxLinks">
					<select class="button" onchange="location.href=this.options[this.selectedIndex].value">
						<xsl:for-each select="link[position() ge $linkpanel-maxLinks and @active eq 'true']">
							<xsl:attribute name="class" select="'button active'"/>
						</xsl:for-each>
						<option value="" disabled="disabled" selected="selected"> ... </option>
						<xsl:apply-templates select="link[position() ge $linkpanel-maxLinks]" mode="select-option">
							<xsl:with-param name="linkpanel-metadata" select="$linkpanel-metadata" tunnel="yes"/>
						</xsl:apply-templates>
					</select>
				</xsl:when>
			</xsl:choose>
			<p class="clr"></p>
		</div>
	</xsl:template>
	
	<xd:doc>
		<xd:short>page linkpanel link template which generates link as a button</xd:short>
	</xd:doc>
	<xsl:template match="page/config/linkpanel/link" priority="-2.5">
		<xsl:param name="linkpanel-metadata" tunnel="yes"/>
		<xsl:param name="link-url" select="appng:get-absolute-url(@target,@mode)" as="xs:anyURI"/>
		<xsl:param name="link-active" select="(@active,false())[1]" as="xs:boolean"/>
		<xsl:param name="link-mode" select="if (@mode eq 'intern') then '_self' else '_blank'" as="xs:string"/>
		
		<div class="button {if ($link-active) then 'active' else ''}">
			<a href="{$link-url}" target="{$link-mode}" class="button {if ($link-active) then 'active' else ''}" title="{normalize-space(label)}">
				<xsl:apply-templates select="label"/>
			</a>
		</div>
	</xsl:template>
	<xd:doc>
		<xd:short>page linkpanel link template which generates link as a select option</xd:short>
	</xd:doc>
	<xsl:template match="page/config/linkpanel/link" priority="-2.5" mode="select-option">
		<xsl:param name="linkpanel-metadata" tunnel="yes"/>
		<xsl:param name="link-url" select="appng:get-absolute-url(@target,@mode)" as="xs:anyURI"/>
		<xsl:param name="link-active" select="(@active,false())[1]" as="xs:boolean"/>

		<option value="{$link-url}" class="{if ($link-active) then 'active' else ''}">
			<xsl:if test="$link-active"><xsl:attribute name="selected" select="'selected'"/></xsl:if>
			<xsl:apply-templates select="label" mode="#current"/>
		</option>
	</xsl:template>

	<xd:doc>
		<xd:short>navigation template which generates a navigation of all available sites</xd:short>
	</xd:doc>
	<xsl:template match="platform/navigation" priority="-2.5" mode="navigation-site">
		<xsl:param name="navigation-id" select="'navigation-site'" as="xs:string"/>
		<div id="navi">
			<script language="javascript" type="text/javascript">
					<xsl:text disable-output-escaping="yes">
					<![CDATA[
						var slideBoxName = ']]></xsl:text><xsl:value-of select="$navigation-id"/><xsl:text disable-output-escaping="yes"><![CDATA[';
						slideBox.init(slideBoxName, {listType:0});
					]]>
					</xsl:text>
				</script>
			<ul>
				<!-- 1-lvl are sites only -->
				<xsl:apply-templates select="./item[@type eq 'site']" mode="#current">
					<xsl:with-param name="navigation-id" select="$navigation-id" tunnel="yes"/>
				</xsl:apply-templates>
			</ul>
		</div>
	</xsl:template>
	<xd:doc>
		<xd:short>navigation template which generates a navigation of all available anchors</xd:short>
		<xd:detail>
			<p>Navigation items of type anchor are currently user related links and are displayed in the user infobox</p>
		</xd:detail>
	</xd:doc>
	<xsl:template match="platform/navigation" priority="-2.5" mode="navigation-user">
		<xsl:apply-templates select="item[@type eq 'anchor']" mode="#current"/>
	</xsl:template>
	
	<xd:doc>
		<xd:short>navigation item template which generates a link and an unordered list of all child navigation items</xd:short>
		<xd:detail>
			
		</xd:detail>
	</xd:doc>
	<xsl:template match="platform/navigation//item" priority="-2.5" mode="navigation-site">
		<xsl:param name="navigation-id" tunnel="yes"/>
		
		<xsl:param name="item-position" select="string(position())" as="xs:string"/>
		<xsl:param name="item-preceding-url" select="$base-url" as="xs:string"/>
		<xsl:param name="item-ref" select="@ref" as="xs:string?"/>
		<xsl:param name="item-type" select="@type" as="xs:string"/>
		<xsl:param name="item-selected" select="(@selected,false())[1]" as="xs:boolean"/>
		
		<xsl:param name="item-htmlid" select="string-join(($navigation-id,string($item-position)),'_')" as="xs:string"/>
		<xsl:param name="item-url" select="if ($item-type = ('application','anchor')) then string-join(($item-preceding-url,$item-ref),'/') else 'javascript: void(0)'" as="xs:string"/>
		
		<xsl:param name="item-css" select="if ($item-selected) then
				(if ($item-preceding-url eq $base-url) then 'selected' else 'active')
				else ''" as="xs:string">
		</xsl:param>
		<xsl:param name="item-label" select="label" as="element(label)"/>
		
		<li>
			<a class="{$item-css}" href="{$item-url}" id="{$item-htmlid}" onfocus="if(this.blur)this.blur()">
				<span class="menuItem">
					<xsl:value-of select="$item-label"/>
				</span>
			</a>
			<!-- next level navigation -->
			<xsl:if test="count(item[not(@hidden) or @hidden != 'true']) &gt; 0">
				<ul id="{string-join(($item-htmlid,'a'),'_')}">
					<xsl:for-each select="item[not(@hidden) or @hidden != 'true']">
						<xsl:apply-templates select="." mode="#current">
							<xsl:with-param name="item-position" select="string-join((string($item-position),string(position())),'-')" as="xs:string"/>
							<xsl:with-param name="item-preceding-url" select="string-join(($item-preceding-url,$item-ref),'/')" as="xs:string"/>
						</xsl:apply-templates>
					</xsl:for-each>
				</ul>
			</xsl:if>
			<script type="text/javascript">
				<xsl:text disable-output-escaping="yes">
				<![CDATA[
					slideBox.addItem(slideBoxName,']]></xsl:text><xsl:value-of select="$item-htmlid"/><xsl:text disable-output-escaping="yes"><![CDATA[');
				]]>
				</xsl:text>
			</script>
		</li>
	</xsl:template>
	<xd:doc>
		<xd:short>navigation item template which generates a table row with a link for the user infobox</xd:short>
	</xd:doc>
	<xsl:template match="platform/navigation//item" priority="-2.5" mode="navigation-user">
		<xsl:param name="item-label" select="label" as="element(label)"/>
		<xsl:param name="item-icon-css" select="string-join( ('ico',lower-case(@actionValue)),'_' )" as="xs:string"/>
		<xsl:param name="item-ref" select="@ref" as="xs:string?"/>
		
		<tr>
			<td class="col1">
				<img alt="{$item-label/text()}" title="{$item-label/text()}" border="0" class="icon {$item-icon-css}" src="/template/assets/spacer.png"/>
			</td>
			<td class="col2">
				<a href="{$base-url}/{$item-ref}">
					<xsl:value-of select="appng:search-label($item-label,.)"/>	
				</a>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
