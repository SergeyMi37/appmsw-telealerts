/// Instances
Class appmsw.telestat.API.inst Extends %Persistent
{

/// Name
Property Name As %String(MAXLEN = "");

/// User Name 
Property UserName As %String(MAXLEN = "");

/// User Password 
Property UserPass As %String(MAXLEN = "");

/// Is Enabled
Property Enabled As %Integer;

/// Host:Port
Property HostPort As %String(MAXLEN = "");

/// Date and time last change
Property EditedDataTime As %TimeStamp [ InitialExpression = {$zdt($h, 3, 1)} ];

/// Endpoint Service Products http://servname/apptoolsrest/products/ ;  ##class(apptools.core.rest).getProductions
Property ServiceProducts As %String(MAXLEN = "");

/// Endpoint Service Alerts http://servname/apptoolsrest/alerts/3" ;alerts for 3 days  ##class(apptools.core.rest).GetAlerts
Property ServiceAlerts As %String(MAXLEN = "");

Index idxName On Name;

Index idxEditedDataTime On EditedDataTime [ Type = bitslice ];

/// if ##class(appmsw.telestat.API.inst).GetList(,.list)
ClassMethod GetList(Name = "", ByRef list) As %Status
{
	 set sql="Select ServiceProducts,UserName,UserPass,Name,ServiceAlerts,Enabled FROM appmsw_telestat_API.inst where Enabled=1"
	 if Name'="" set sql=sql_" and Name='"_Name_"'"
	 do ##class(apptools.core.sys).SaveSQL(sql,"^||list")
	 merge list=^||list
 	quit $$$OK
}

/// write $System.Status.GetErrorText(##class(appmsw.telestat.API.inst).EditInst("test",1,"_system","SYS","http://localhost:52773"))
ClassMethod EditInst(Name, Enabled = "", UserName = "", UserPass = "", HostPort = "") As %Status
{
	#dim obj As appmsw.telestat.API.inst = ""
	if Name="" $$$ThrowOnError($$$ERROR($$$GeneralError,"Name is empty"))
	do ..GetByName(Name,.id)
	if id'="" set obj=..%OpenId(id)
	if '$iso(obj) Set obj = ..%New()
	set ServiceProducts=HostPort_"/apptoolsrest/products/"
	set ServiceAlerts=HostPort_"/apptoolsrest/alerts/3"
	set obj.Name=Name
	set obj.Enabled=Enabled
	set obj.UserName=UserName
	set obj.UserPass=UserPass
	set obj.ServiceProducts=ServiceProducts
	set obj.ServiceAlerts=ServiceAlerts
	quit obj.%Save()
}

/// Get instance
/// do ##class(appmsw.telestat.API.inst).GetByName("test",.id) 
ClassMethod GetByName(name, id) As %Status
{
	Set tQuery = "select * from appmsw_telestat_API.inst where Name='"_name_"'"
	Set tRes = ##class(%SQL.Statement).%ExecDirect(,tQuery)
	set name="",id=""
	If (tRes.%SQLCODE < 0) {
		Throw ##class(%Exception.SQL).CreateFromSQLCODE(tRes.%SQLCODE,tRes.%Message)
	}
	While tRes.%Next(.tSC) {
		$$$ThrowOnError(tSC)
		Set name=tRes.%Get("Name")
		set id=tRes.%Get("ID")
	}
	quit $$$OK
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

