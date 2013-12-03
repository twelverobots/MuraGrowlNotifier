<cfparam name="url.messageid" default="" />
<cfparam name="form.action" default="getMessage" />
<cfparam name="url.action" default = "#form.action#" />
 
<!--- We need to include the plugin config to get access to the Mura scope --->
<cfinclude template="plugin/config.cfm" />

<!--- Get the plugin's application scope --->
<cfset pApp = pluginConfig.getApplication() />

<cfset messageGateway = pApp.getValue("messageGateway") />

<!--- Create JSON Util --->
<cfset jsonUtilPath = "plugins." & pluginConfig.getDirectory() & ".libs.JSONUtil" />
<cfset jsonUtil = createObject("component", jsonUtilPath) />

<cfif url.action EQ "getMessage">
	<cfset message = messageGateway.getMessageByID(url.messageid) />
	<cfset newMessage = structNew() />
	<cfscript>
			newMessage["messageid"] = message.getID();
			newMessage["title"] = message.getTitle();
			newMessage["message"] = message.getMessage();
			newMessage["startToDisplay"] = dateFormat(message.getStartToDisplay(), "mm/dd/yyyy");
			newMessage["displayUntil"] = dateFormat(message.getDisplayUntil(), "mm/dd/yyyy");
			newMessage["theme"] = message.getTheme();
			newMessage["backgroundColor"] = message.getBackgroundColor();
			newMessage["borderColor"] = message.getBorderColor();
			newMessage["icon"] = message.getIcon();
			newMessage["textColor"] = message.getTextColor();
			newMessage["active"] = message.getActive();
	</cfscript>
	
	<cfcontent reset="true" type="application/json" /><cfoutput>#jsonUtil.serializeJSON(newMessage)#</cfoutput>
	<cfabort>	
</cfif>

<cfif url.action EQ "deleteMessage">
	<cfset deleteError = messageGateway.deleteMessage($.event('messageid')) />
	<cfset result = structNew() />
	
	<cfif NOT len(deleteError)>
		<cfset result["message"] = "Message Deleted" />
		<cfset result["success"] = true />		
	<cfelse>
		<cfset result["success"] = false />
		<cfset result["message"] = deleteError />
		<cfset result["errors"] = [{field="message", message=deleteError}] />
	</cfif>
	
	<cfcontent reset="true" type="application/json" /><cfoutput>#jsonUtil.serializeJSON(result)#</cfoutput>
	<cfabort>			
</cfif>

