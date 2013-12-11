<!--- This file is used for things that need to happen at install, update, or removal of the plugin --->
<cfcomponent extends="mura.plugin.plugincfc" output="false">
	
	<cffunction name="install" returntype="void" access="public" output="false" hint="This method runs when the plugin is installed. ">
		<cfset super.install() />
		
		<!--- Create the needed DB table --->
		<!--- Not the use of the dbTablePrefix. This is a plugin setting that the user is asked for when the plugin 
			is installed incase they want to use a prefix to avoid conflicts. This prefix needs to be used in ALL queries for this table --->
		<cfquery name="createMessageTable" datasource="#application.configBean.getDatasource()#">
			CREATE TABLE IF NOT EXISTS #pluginConfig.getSetting("dbTablePrefix")#notifiermessages (
				messageid CHAR(35) NOT NULL PRIMARY KEY,
				title VARCHAR(255),
				message VARCHAR(400),
				startToDisplayDate DATE,
				displayUntilDate DATE,
				theme VARCHAR(30),
				backgroundColor VARCHAR(8),
				borderColor VARCHAR(8),
				icon VARCHAR(400),
				textColor VARCHAR(8),
				active INTEGER
			) <cfif application.configBean.getDBType() eq "mysql">ENGINE = INNODB</cfif>
		</cfquery>

        <cfquery name="addSampleMessages" datasource="#application.configBean.getDatasource()#">
            INSERT INTO #pluginConfig.getSetting("dbTablePrefix")#notifiermessages (
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
            ) VALUE (
                1,
                'Test Message 1',
                'This is the first test message',
                #createODBCDateTime(now())#,
                #createODBCDateTime(dateAdd("d", 1, now()))#,
                'attention',
                null,
                null,
                null,
                null,
                true
            ),
            (
                2,
                'Test Message 2',
                'This is the second test message',
                #createODBCDateTime(now())#,
                #createODBCDateTime(dateAdd("d", 1, now()))#,
                'alert',
                null,
                null,
                null,
                null,
                true
            )
        </cfquery>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfset super.delete() />
		
		<!--- Delete the DB Table, the plugin is being rmeoved and we don't need it anymore --->
		<cfquery name="removeMessageTable" datasource="#application.configBean.getDatasource()#">
			DROP TABLE #pluginConfig.getSetting("dbTablePrefix")#notifiermessages
		</cfquery>		
	</cffunction>
</cfcomponent>