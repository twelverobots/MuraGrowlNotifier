<cfcomponent extends="mura.plugin.pluginGenericEventHandler" output="false">

    <cffunction name="onApplicationLoad">
        <cfargument name="$" hint="Mura Scope" />
        <cfobjectcache action="clear" />

        <!--- Get the site id --->
        <cfset var siteid = application.serviceFactory.getBean("contentServer").bindToDomain() />

        <!--- Get the site directory/package name --->
        <cfset var packageName = "#pluginConfig.getDirectory()#" />

        <!--- Set up default properties for ColdSpring --->
        <cfset var defaultProperties = {} />
        <cfset defaultProperties.dsn = application.configBean.getDataSource() />
        <cfset defaultproperties.tablePrefix = pluginConfig.getSetting("dbTablePrefix") />

        <!--- Read in the ColdSpring Config --->
        <cffile action="read" variable="coldspringConfig" file="#expandPath( '/plugins' )#/#pluginConfig.getDirectory()#/server/config/coldspring.xml" />

        <!--- Replace instances of ${packageName} with the actual package name --->
        <cfset coldspringConfig = replaceNoCase(coldspringConfig, "${packageName}", packageName, "all") />

        <!--- Create CS bean factory --->
        <cfset application[packageName & "BeanFactory"] = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory').init(defaultProperties = defaultProperties) />
        <cfset application[packageName & "BeanFactory"].loadBeansFromXMLRaw(coldspringConfig) />

        <!--- Initialize the remote proxy --->
        <cfset application[packageName & "BeanFactory"].getBean("remoteMessageService") />

		<!--- Register event handlers --->
		<cfset pluginConfig.addEventHandler(this) />
	</cffunction>

	<cffunction name="onRenderEnd" access="public" returntype="void" output="false">
		<cfargument name="event" required="true" />

        <!--- This code will display the notifier on the page --->
		<cfset var headerStuff = "" />
        <cfset var packageName = pluginConfig.getDirectory() />
        <cfset var msgGateway = application[packageName & "BeanFactory"].getBean("notifierMessageGateway") />

		<cfif variables.pluginConfig.getSetting("isEnabled")>

			<cfset var messages = msgGateway.getTodaysMessages() />

			<cfsavecontent variable="headerStuff">
				<cfoutput>
					<cfif pluginConfig.getSetting("loadJGrowl")>
						<link href="/plugins/#pluginConfig.getDirectory()#/libs/jgrowl/css/jquery.jgrowl.css" rel="stylesheet" />
						<script type="text/javascript" src="/plugins/#pluginConfig.getDirectory()#/libs/jgrowl/scripts/jquery.jgrowl.min.js"></script>
					</cfif>

					<link href="/plugins/#pluginConfig.getDirectory()#/libs/jgrowl/css/jquery.jgrowl.custom.css" rel="stylesheet" />

					<script>

						$(function() {
							<cfloop array="#messages#" index="msgIndex">
								var currentjGrowl = $.jGrowl(
									"#JSStringFormat(msgIndex.getMessage())#",
									{
										header: "#JSStringFormat(msgIndex.getTitle())#",
										theme:"#JSStringFormat(msgIndex.getTheme())#",
										sticky: true,
										<cfif msgIndex.getTheme() EQ "custom">
											beforeOpen: function() {
												$(this).css({
													"background-color": "#msgIndex.getBackgroundColor()#",
													"color": "#msgIndex.getTextColor()#",
													"border": "1px solid " + "#msgIndex.getBorderColor()#"<cfif msgIndex.getIcon() NEQ "">,

													"background-image": "url(#msgIndex.getIcon()#)",
													"background-repeat": "no-repeat",
													"background-position": "10px 10px",
													"padding-left": "60px"
													</cfif>
												})
											},
										</cfif>
										open: function() {
											$(this).attr("id", "#msgIndex.getID()#");
										},
										close: function() {
											console.log($(this));
										}
									}
								);
							</cfloop>
						});

					</script>

				</cfoutput>
			</cfsavecontent>

			<cfhtmlhead text="#headerStuff#" />
		</cfif>
	</cffunction>
</cfcomponent>