/// Instances
Class appmsw.telestat.API.inst Extends %Persistent
{

/// Name
Property Name As %String;

/// User Name 
Property UserName As %String;

/// User Password 
Property UserPass As %String;

/// Is Enabled
Property Enabled As %Integer;

/// Host:Port
Property HostPort As %String;

/// Date and time last change
Property EditedDataTime As %TimeStamp [ InitialExpression = {$zdt($h, 3, 1)} ];

/// Endpoint Service Products http://servname/apptoolsrest/products/ ;  ##class(apptools.core.rest).getProductions
Property ServiceProducts As %String;

/// Endpoint Service Alerts http://servname/apptoolsrest/alerts/3" ;alerts for 3 days  ##class(apptools.core.rest).GetAlerts
Property ServiceAlerts As %String;

Index idxName On Name;

Index idxEditedDataTime On EditedDataTime [ Type = bitslice ];

/// if ##class(appmsw.telestat.API.inst).GetList(,.list)
ClassMethod GetList(Name = "", ByRef list) As %Status
{
	 set sql="Select ServiceProducts,UserName,UserPass,Name,ServiceAlerts,Enabled FROM appmsw_telestat_API.inst"
	 if Name'="" set sql=sql_" where Name='"_Name_"'"
	 do ##class(apptools.core.sys).SaveSQL(sql,"^||list")
	 merge list=^||list
 	quit $$$OK
}

/// write ##class(appmsw.telestat.API.inst).AddInst("test",1,"_system","SYS","http://test:52773/apptoolsrest/products/","http://test:52773/apptoolsrest/products/alerts/3")
ClassMethod AddInst(Name, Enabled = "", UserName = "", UserPass = "", ServiceProducts = "", ServiceAlerts = "") As %Status
{
	set obj=##class(appmsw.telestat.API.inst).%New()
	set obj.Name=Name
	set obj.Enabled=Enabled
	set obj.UserName=UserName
	set obj.UserPass=UserPass
	set obj.ServiceProducts=ServiceProducts
	set obj.ServiceAlerts=ServiceAlerts
	quit obj.%Save()
}

Storage Default
{
<Data name="instDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>UserName</Value>
</Value>
<Value name="4">
<Value>UserPass</Value>
</Value>
<Value name="5">
<Value>Enabled</Value>
</Value>
<Value name="6">
<Value>HostPort</Value>
</Value>
<Value name="7">
<Value>EditedDataTime</Value>
</Value>
<Value name="8">
<Value>ServiceProducts</Value>
</Value>
<Value name="9">
<Value>ServiceAlerts</Value>
</Value>
</Data>
<DataLocation>^appmsw.telestat.API.instD</DataLocation>
<DefaultData>instDefaultData</DefaultData>
<IdLocation>^appmsw.telestat.API.instD</IdLocation>
<IndexLocation>^appmsw.telestat.API.instI</IndexLocation>
<StreamLocation>^appmsw.telestat.API.instS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

