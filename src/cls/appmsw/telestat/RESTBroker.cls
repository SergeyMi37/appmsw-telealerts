Include apptools.core

/// 
Class appmsw.telestat.RESTBroker Extends %CSP.REST
{

XData UrlMap
{
<Routes>
	<Route Url="/update" Method="POST" Call="ProcessUpdate" />
</Routes>
}

ClassMethod ProcessUpdate() As %Status
{
	set obj = ##class(%DynamicAbstractObject).%FromJSON(%request.Content)
	
	//set ^t($h) = obj.%ToJSON() // log all updates 
	if $get(@##class(appmsw.telestat.API.service).#GNdebug) set $$$AppL("RST","RESTBroker")=$$$AppObJs(obj)
	Set tSC=$$$OK
	do {
		Set tSC=##class(Ens.Director).CreateBusinessService("appmsw.telestat.TelegramService",.tService)
		If ($$$ISERR(tSC)) Quit
		Set tSC=tService.ProcessInput(obj,.output)
		If ($$$ISERR(tSC)) Quit
	} while (0)
	If ($$$ISERR(tSC)) {
		// Error: assume system is not running
	}	
	return $$$OK
}

}

