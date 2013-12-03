<cfcomponent>
	
	<cfset variables.dsn = "" />
	<cfset variables.prefix = "" />
	
	<cffunction name="init" access="public" returntype="NotifierPlugin.model.MessageGateway" output="false">
		<cfargument name="dsn" type="string" />
		<cfargument name="tablePrefix" />
		
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.prefix = arguments.tablePrefix />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllMessages" access="public" returntype="Array" output="false">
		<!--- This method will return all of the message in the DB as an array of Message objects --->
		<cfset var returnArray = ArrayNew(1) />
		<cfset var currentMessage = "" />
		<cfset var getMessages = "" />
		
		<cfquery name="getMessages" datasource="#variables.dsn#">
			SELECT messageid, title, message, startToDisplayDate, displayUntilDate, theme, backgroundColor, borderColor, icon, textColor, active
			FROM #variables.prefix#notifiermessages
			ORDER BY startToDisplayDate ASC
		</cfquery>
		
		<cfreturn createMessageArray(getMessages) />
	</cffunction>
	
	<cffunction name="getTodaysMessages" access="public" returntype="Array" output="false">
		<cfargument name="today" type="Date" required="false" default="#now()#" />
		
		<cfquery name="getMessages" datasource="#variables.dsn#">
			SELECT messageid, title, message, startToDisplayDate, displayUntilDate, theme, backgroundColor, borderColor, icon, textColor, active
			FROM #variables.prefix#notifiermessages
			WHERE active = 1
				AND startToDisplayDate <= <cfqueryparam value="#arguments.today#" cfsqltype="cf_sql_date" />
				AND displayUntilDate >= <cfqueryparam value="#arguments.today#" cfsqltype="cf_sql_date" />
			ORDER BY startToDisplayDate ASC
		</cfquery>
		
		<cfreturn createMessageArray(getMessages) />
	</cffunction>
	
	<cffunction name="addMessage" access="public" returntype="String" output="false" hint="Returns a string to be used as an error message">
		<cfargument name="title" type="String" required="true" />
		<cfargument name="message" type="String" required="true" />
		<cfargument name="startToDisplay" type="Date" required="true" />
		<cfargument name="displayUntil" type="Date" required="true" />
		<cfargument name="theme" type="String" required="true" />
		<cfargument name="backgroundColor" type="String" required="true" />
		<cfargument name="borderColor" type="String" required="true" />
		<cfargument name="icon" type="String" required="true" />
		<cfargument name="textColor" type="String" required="true" />
		<cfargument name="active" type="numeric" required="true" />
		
		<cfset var qCheck = "" />
		<cfset var error = "" />
		
		<cftry>
			<!--- check to see if the message already exists --->
			<cfquery name="qCheck" datasource="#variables.dsn#">
				SELECT messageid
				FROM #variables.prefix#notifiermessages
				WHERE message = <cfqueryparam value="#trim(arguments.message)#" cfsqltype="cf_sql_varchar" />
					AND title = <cfqueryparam value="#trim(arguments.title)#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfif qCheck.RecordCount GT 0>
				<!--- Return error message --->
				<cfreturn "This exact message already exists" />
			</cfif>
			
			<cfquery name="insertMessage" datasource="#variables.dsn#">
				INSERT INTO #variables.prefix#notifiermessages (
					messageid,
					title,
					message,
					startToDisplayDate, 
					displayUntilDate,
					theme,
					backgroundColor,
					borderColor,
					icon,
					textColor,
					active
				) VALUES (
					<cfqueryparam value="#createUUID()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#trim(arguments.title)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#trim(arguments.message)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#createODBCDate(arguments.startToDisplay)#" cfsqltype="cf_sql_date" />,
					<cfqueryparam value="#createODBCDate(arguments.displayUntil)#" cfsqltype="cf_sql_date" />,
					<cfqueryparam value="#trim(arguments.theme)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#trim(arguments.backgroundColor)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#trim(arguments.borderColor)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#trim(arguments.icon)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#trim(arguments.textColor)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.active#" cfsqltype="cf_sql_integer" />
					
				)
			</cfquery>
			
			<cfcatch>
				<!--- If something fails, return the error message --->
				<cfset error = cfcatch.message />
			</cfcatch>
		</cftry>
		<cfreturn error />
		
	</cffunction>
	
	<cffunction name="getMessageByID" access="remote" returntype="NotifierPlugin.model.Message" output="false">
		<cfargument name="messageid" />
		
		<cfset var getMessage = "" />
		<cfset var currentMessage = "" />
		
		<cfquery name="getMessage" datasource="#variables.dsn#">
			SELECT messageid, title, message, startToDisplayDate, displayUntilDate, theme, backgroundColor, borderColor, icon, textColor, active
			FROM #variables.prefix#notifiermessages
			WHERE messageid = <cfqueryparam value="#arguments.messageid#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfloop query="getMessage">
			<cfset currentMessage = createObject("component","NotifierPlugin.model.Message").init(
				getMessage.messageid, 
				getMessage..title,
				getMessage.message, 
				getMessage.startToDisplayDate, 
				getMessage.displayUntilDate,
				getMessage.theme,
				getMessage.backgroundColor,
				getMessage.borderColor,
				getMessage.icon,
				getMessage.textColor,
				getMessage.active
			) />
		</cfloop>
		
		<cfreturn currentMessage />
	</cffunction>
	
	<cffunction name="updateMessage" access="public" returntype="String" output="false" hint="Returns a string to be used as an error message">
		<cfargument name="messageid" type="String" required="true" />
		<cfargument name="title" type="String" required="true" />
		<cfargument name="message" type="String" required="true" />
		<cfargument name="startToDisplay" type="Date" required="true" />
		<cfargument name="displayUntil" type="Date" required="true" />
		<cfargument name="theme" type="String" required="true" />
		<cfargument name="backgroundColor" type="String" required="true" />
		<cfargument name="borderColor" type="String" required="true" />
		<cfargument name="icon" type="String" required="true" />
		<cfargument name="textColor" type="String" required="true" />
		<cfargument name="active" type="numeric" required="true" />
		
		<cfset var qCheck = "" />
		<cfset var error = "" />
		
		<cftry>
			<!--- Check to see if the subject exists, other than the one we're actually editing --->
			<cfquery name="qCheck" datasource="#variables.dsn#">
				SELECT messageid
				FROM #variables.prefix#notifiermessages
				WHERE message = <cfqueryparam value="#arguments.message#" cfsqltype="cf_sql_varchar" />
					AND title = <cfqueryparam value="#trim(arguments.message)#" cfsqltype="cf_sql_varchar" />
					AND messageid <> <cfqueryparam value="#arguments.messageid#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfif qCheck.RecordCount GT 0>
				<cfreturn "This exact message already exists" />
			</cfif>
			
			<cfquery name="updateMessage" datasource="#variables.dsn#">
				UPDATE #variables.prefix#notifiermessages 
				SET title = <cfqueryparam value="#trim(arguments.title)#" cfsqltype="cf_sql_varchar" />,
					message = <cfqueryparam value="#trim(arguments.message)#" cfsqltype="cf_sql_varchar" />,
					startToDisplayDate = <cfqueryparam value="#createODBCDate(arguments.startToDisplay)#" cfsqltype="cf_sql_date" />,
					displayUntilDate = <cfqueryparam value="#createODBCDate(arguments.displayUntil)#" cfsqltype="cf_sql_date" />,
					theme = <cfqueryparam value="#trim(arguments.theme)#" cfsqltype="cf_sql_varchar" />,
					backgroundColor = <cfqueryparam value="#trim(arguments.backgroundColor)#" cfsqltype="cf_sql_varchar" />,
					borderColor = <cfqueryparam value="#trim(arguments.borderColor)#" cfsqltype="cf_sql_varchar" />,
					icon = <cfqueryparam value="#trim(arguments.icon)#" cfsqltype="cf_sql_varchar" />,
					textColor = <cfqueryparam value="#trim(arguments.textColor)#" cfsqltype="cf_sql_varchar" />,
					active = <cfqueryparam value="#trim(arguments.active)#" cfsqltype="cf_sql_integer" />
				WHERE messageid = <cfqueryparam value="#arguments.messageid#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfcatch>
				<cfdump var="#cfcatch#"><cfabort>
				<cfset error = cfcatch.message />
			</cfcatch>
		</cftry>
		<cfreturn error />
		
	</cffunction>

	<cffunction name="deleteMessage" access="public" returntype="String" output="false" hint="Returns a string to be used as an error message">
		<cfargument name="messageid" type="string" />
		
		<cfset var deleteMessage = "" />
		
		<cftry>
			<cfquery name="deleteMessage" datasource="#variables.dsn#">
				DELETE FROM #variables.prefix#notifiermessages
				WHERE messageid = <cfqueryparam value="#arguments.messageid#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfcatch>
				<cfreturn "There was a problem deleting the message, please try again later" />
			</cfcatch>	
		</cftry>
		
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="createMessageArray" access="private" returntype="Array" ooutput="false">
		<cfargument name="messages" type="query" required="true" />
		
		<cfset var msgArray = ArrayNew(1) />
		<cfset var currentMessage = "" />
		<cfset var msgQuery = arguments.messages />
		
		<cfloop query="msgQuery">
			<cfset currentMessage = createObject("component","NotifierPlugin.model.Message").init(
				msgQuery.messageid, 
				msgQuery.title,
				msgQuery.message, 
				msgQuery.startToDisplayDate, 
				msgQuery.displayUntilDate,
				msgQuery.theme,
				msgQuery.backgroundColor,
				msgQuery.borderColor,
				msgQuery.icon,
				msgQuery.textColor,
				msgQuery.active
			) />
			
			<cfset arrayAppend(msgArray, currentMessage) />
		</cfloop>
		
		<cfreturn msgArray />
		
	</cffunction>
</cfcomponent>