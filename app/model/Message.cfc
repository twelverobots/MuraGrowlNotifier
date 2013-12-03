<cfcomponent>
	
	<cfset variables.id = "" />
	<cfset title = "" />
	<cfset variables.message = "" />
	<cfset variables.startToDisplay = "" />
	<cfset variables.displayUntil = "" />
	<cfset variables.theme = "" />
	<cfset variables.backGroundColor = "" />
	<cfset variables.borderColor = "" />
	<cfset variables.icon = "" />
	<cfset variables.textColor = "" />
	<cfset variables.active = false />
	
	<cffunction name="init" access="public" returntype="NotifierPlugin.model.Message" output="false">
		<cfargument name="id" type="String" required="false" />
		<cfargument name="title" type="string" required="false" />
		<cfargument name="message" type="string" required="false" />		
		<cfargument name="startToDisplay" type="Date" required="false" />
		<cfargument name="displayUntil" type="Date" required="false" />
		<cfargument name="theme" type="String" required="false" />
		<cfargument name="backgroundColor" type="string" required="false" />
		<cfargument name="borderColor" type="string" required="false" />
		<cfargument name="icon" type="string" required="false" />
		<cfargument name="textColor" type="string" required="false" />
		<cfargument name="active" type="boolean" required="false" />
		
		<cfset setID(arguments.id) />
		<cfset setTitle(arguments.title) />
		<cfset setMessage(arguments.message) />
		<cfset setStartToDisplay(arguments.startToDisplay) />
		<cfset setDisplayUntil(arguments.displayUntil) />
		<cfset setTheme(arguments.theme) />
		<cfset setBackgroundColor(arguments.backgroundColor) />
		<cfset setBorderColor(arguments.borderColor) />
		<cfset setIcon(arguments.icon) />
		<cfset setTextColor(arguments.textColor) />
		<cfset setActive(arguments.active) />
		
		<cfreturn this />
	</cffunction>

	<!--- Getters --->
	<cffunction name="getID" access="public" returntype="String" output="false">
		<cfreturn variables.id />
	</cffunction>
	
	<cffunction name="getTitle" access="public" returntype="String" output="false">
		<cfreturn variables.title />
	</cffunction>
	
	<cffunction name="getMessage" access="public" returntype="String" output="false">
		<cfreturn variables.message />
	</cffunction>
	
	<cffunction name="getStartToDisplay" access="public" returntype="Date" output="false">
		<cfreturn variables.startToDisplay />
	</cffunction>

	<cffunction name="getDisplayUntil" access="public" returntype="Date" output="false">
		<cfreturn variables.displayUntil />
	</cffunction>
	
	<cffunction name="getTheme" access="public" returntype="String" output="false">
		<cfreturn variables.theme />
	</cffunction>
	
	<cffunction name="getbackgroundColor" access="public" returntype="String" output="false">
		<cfreturn variables.backGroundColor />
	</cffunction>
	
	<cffunction name="getBorderColor" access="public" returntype="String" output="false">
		<cfreturn variables.borderColor />
	</cffunction>
	
	<cffunction name="getIcon" access="public" returntype="String" output="false">
		<cfreturn variables.icon />
	</cffunction>
	
	<cffunction name="getTextColor" access="public" returntype="String" output="false">
		<cfreturn variables.textColor />
	</cffunction>
	
	<cffunction name="getActive" access="public" returntype="boolean" output="false">
		<cfreturn variables.active />
	</cffunction>
	
	
	<!---Setters--->
	<cffunction name="setID" access="public" returntype="void" output="false">
		<cfargument name="id" type="string" required="true" />
		
		<cfset variables.id = arguments.id />
	</cffunction>
	
	<cffunction name="setTitle" access="public" returntype="void" output="false">
		<cfargument name="title" type="string" required="true" />
		
		<cfset variables.title = arguments.title />
	</cffunction>
	
	<cffunction name="setMessage" access="public" returntype="void" output="false">
		<cfargument name="message" type="string" required="true" />
		
		<cfset variables.message = arguments.message />
	</cffunction>
	
	<cffunction name="setStartToDisplay" access="public" returntype="void" output="false">
		<cfargument name="startToDisplay" type="date" required="true" />
		
		<cfset variables.startToDisplay = arguments.startToDisplay />
	</cffunction>

	<cffunction name="setDisplayUntil" access="public" returntype="void" output="false">
		<cfargument name="displayUntil" type="date" required="true" />
		
		<cfset variables.displayUntil = arguments.displayUntil />
	</cffunction>
	
	<cffunction name="setTheme" access="public" returntype="void" output="false">
		<cfargument name="theme" type="string" required="true" />
		
		<cfset variables.theme = arguments.theme />
	</cffunction>
	
	<cffunction name="setBackgroundColor" access="public" returntype="void" output="false">
		<cfargument name="backgroundColor" type="string" required="true" />
		
		<cfset variables.backGroundColor = arguments.backgroundColor />
	</cffunction>
	
	<cffunction name="setBorderColor" access="public" returntype="void" output="false">
		<cfargument name="borderColor" type="string" required="true" />
		
		<cfset variables.borderColor = arguments.borderColor />
	</cffunction>
	
	<cffunction name="setIcon" access="public" returntype="void" output="false">
		<cfargument name="icon" type="string" required="true" />
		
		<cfset variables.icon = arguments.icon />
	</cffunction>
	
	<cffunction name="setTextColor" access="public" returntype="void" output="false">
		<cfargument name="textColor" type="string" required="true" />
		
		<cfset variables.textColor = arguments.textColor />
	</cffunction>
	
	<cffunction name="setActive" access="public" returntype="void" output="false">
		<cfargument name="active" type="boolean" required="true" />
		
		<cfset variables.active = arguments.active />
	</cffunction>
</cfcomponent>