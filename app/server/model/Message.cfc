<cfcomponent accessors="true">
	
	<cfproperty name="id" type="numeric"/>
    <cfproperty name="title" type="string" />
    <cfproperty name="message" type="string" />
    <cfproperty name="startToDisplay" type="string" />
    <cfproperty name="displayUntil" type="string" />
    <cfproperty name="theme" type="string" />
    <cfproperty name="backGroundColor" type="string" />
    <cfproperty name="borderColor" type="string" />
    <cfproperty name="icon" type="string" />
    <cfproperty name="textColor" type="string" />
    <cfproperty name="active" type="string" />
	
	<cffunction name="init" access="public" returntype="any" output="false">
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

</cfcomponent>