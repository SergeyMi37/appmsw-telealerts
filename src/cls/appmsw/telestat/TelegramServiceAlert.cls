/// Alerting service
Class appmsw.telestat.TelegramServiceAlert Extends appmsw.telestat.API.service
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property ServiceList As %String(MAXLEN = "");

Parameter SETTINGS = "ServiceList";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	do ##class(appmsw.telestat.API.alert).Alerts(pInput)
	return $$$OK
}

}

