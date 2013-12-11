<cfsilent>
    <cfinclude template="plugin/config.cfm"/>

    <cfset pluginPath = '/plugins/' & pluginConfig.getDirectory()/>
    <cfset iconPath = pluginPath & '/images'/>
    <cfset iconDir = expandPath(iconPath)/>
</cfsilent>

<cfset headText = "" />
<cfsavecontent variable="headText">
    <cfoutput>
    <link rel="stylesheet" href="styles/main.css">

    <!-- Add jGrowl styles if not already there -->
    <cfif pluginConfig.getSetting("loadJGrowl")>
        <link href="libs/jgrowl/css/jquery.jgrowl.min.css" rel="stylesheet" />
    </cfif>

    <!-- Note: jgrowl JS not needed on the admin side --->

    <!--- Load custom jGrowl styles --->
    <link href="libs/jgrowl/css/jquery.jgrowl.custom.css" rel="stylesheet" />

    <!-- Add minicolors -->
    <link href="libs/miniColors/jquery.minicolors.css" rel="stylesheet" />
    <script src="libs/miniColors/jquery.minicolors.min.js"></script>

    <!-- Load Plugin Styles -->
    <link href="css/notifierStyles.css" rel="stylesheet" />

    <!-- Load Notifier Scripts -->
    <script src="scripts/notifier.js"></script>
    </cfoutput>
</cfsavecontent>

<cfhtmlhead text="#headText#" />

<cfsavecontent variable="plugin_body">
    <body ng-app="notifierPluginApp">
    <!--[if lt IE 9]>
    <script src="bower_components/es5-shim/es5-shim.js"></script>
    <script src="bower_components/json3/lib/json3.min.js"></script>
    <![endif]-->

    <!-- Add your site or application content here -->
    <div class="container" ng-view=""></div>


    <script src="bower_components/angular/angular.js"></script>

    <!-- build:js scripts/modules.js -->
    <script src="bower_components/angular-resource/angular-resource.js"></script>
    <script src="bower_components/angular-cookies/angular-cookies.js"></script>
    <script src="bower_components/angular-sanitize/angular-sanitize.js"></script>
    <script src="bower_components/angular-route/angular-route.js"></script>
    <!-- endbuild -->

    <!-- build:js({.tmp,app}) scripts/scripts.js -->
    <script src="scripts/app.js"></script>
    <script src="scripts/controllers/main.js"></script>
    <!-- endbuild -->
</cfsavecontent>

<cfoutput>
<!--- This will render the page inside of the mura admin template --->
    #$.getBean('pluginmanager').renderAdminTemplate(body = plugin_body, pageTitle = pluginConfig.getName())#
</cfoutput>
