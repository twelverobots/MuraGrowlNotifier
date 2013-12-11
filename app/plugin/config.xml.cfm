<?xml version="1.0" encoding="UTF-8"?>
<plugin>
	<name>NotifierPlugin</name>
	<package>NotifierPlugin</package>
	<loadPriority>5</loadPriority>
	<version>0.3</version>
    <autodeploy>true</autodeploy>
	<provider>Jason P. Dean</provider>
	<providerURL>http://www.12robots.com</providerURL>
	<category>Application</category>
	<settings>
		<setting>
			<name>dbTablePrefix</name>
			<label>DB table Prefix</label>
			<hint>This plugin creates a few database tables. If you are worried about conflict, use this field to place a unique prefix on the table names (Include an underscore if you want one)</hint>
			<type>text</type>
			<required>false</required>
			<validation>regex</validation>
			<regex>[A-Za-z0-9_]*</regex>
			<message>Table prefix can be alphanumeric with underscores only</message>
			<defaultValue></defaultValue>
			<optionList></optionList>
			<optionLabelList></optionLabelList>
		</setting>
		<setting>
			<name>isEnabled</name>
			<label>Enable</label>
			<hint>Chances are you do not want to enable this by default. Notifier will likely be used sporadically</hint>
			<type>select</type>
			<required>true</required>
			<validation>regex</validation>
			<regex>(true|false)</regex>
			<message>Only true or false are acceptable values</message>
			<defaultValue>false</defaultValue>
			<optionList>true^false</optionList>
			<optionLabelList></optionLabelList>
		</setting>
		<setting>
			<name>loadJGrowl</name>
			<label>Load the jGrowl Library?</label>
			<hint>If you are already using jGrowl and have it loaded in your site, you don't want to load it again</hint>
			<type>select</type>
			<required>true</required>
			<validation>regex</validation>
			<regex>(true|false)</regex>
			<message>Only true or false are acceptable values</message>
			<defaultValue>true</defaultValue>
			<optionList>true^false</optionList>
			<optionLabelList></optionLabelList>
		</setting>
		<setting>
			<name>loadJQueryCookie</name>
			<label>Load the jQuery Cookie Library?</label>
			<hint>If you are already using jQuery Cookie and have it loaded in your site, you don't want to load it again</hint>
			<type>select</type>
			<required>true</required>
			<validation>regex</validation>
			<regex>(true|false)</regex>
			<message>Only true or false are acceptable values</message>
			<defaultValue>true</defaultValue>
			<optionList>true^false</optionList>
			<optionLabelList></optionLabelList>
		</setting>
	</settings>
	<EventHandlers>
		<eventHandler event="onApplicationLoad" component="eventHandlers.notifierEventHandlers.notifierHandler" persist="false" />
	</EventHandlers>
	<DisplayObjects />
	<directoryFormat>packageOnly</directoryFormat>
	<loadPriortiy>10</loadPriortiy>
</plugin>