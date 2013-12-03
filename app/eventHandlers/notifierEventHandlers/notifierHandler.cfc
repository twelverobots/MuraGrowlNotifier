<cfcomponent extends="mura.cfobject" output="false">
	
	<cffunction name="onApplicationLoad">
		<cfargument name="$" hint="Mura Scope" />
		
		<!--- Get the plugin configuration info, we need it to get the dbTablePrefix and the plugins application scope--->
		<cfset variables.pluginConfig = $.getBean('pluginManager').getConfig('NotifierPlugin') />
		
		<!--- get the plugins application scope --->
		<cfset pApp = variables.pluginConfig.getApplication() />

		<!--- put the messageGateway into the plugin's app scope (singleton) --->
		<cfset pApp.setValue("messageGateway", createObject("component","NotifierPlugin.model.messageGateway").init(application.configBean.getDataSource(), variables.pluginConfig.getSetting("dbTablePrefix"))) />

		<!--- Register event handlers --->
		<cfset variables.pluginConfig.addEventHandler(this) />
	</cffunction>
	
	<cffunction name="onRenderEnd" access="public" returntype="void" output="false">
		<cfargument name="event" required="true" />
		
		<cfset var headerStuff = "" />
		<cfset msgGateway = pApp.getValue("messageGateway") />

		<cfif variables.pluginConfig.getSetting("isEnabled")>
			
			<cfset var messages = msgGateway.getTodaysMessages() />
			
			<cfsavecontent variable="headerStuff">			
				<cfoutput>
					<cfif pluginConfig.getSetting("loadJGrowl")>
						<link href="/plugins/#pluginConfig.getDirectory()#/css/jquery.jgrowl.css" rel="stylesheet" />
						<script type="text/javascript" src="/plugins/#pluginConfig.getDirectory()#/js/jquery.jgrowl_minimized.js"></script>
					</cfif>
						
					<link href="/plugins/#pluginConfig.getDirectory()#/css/jquery.jgrowl.custom.css" rel="stylesheet" />
								
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