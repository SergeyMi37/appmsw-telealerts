Class appmsw.telestat.API.commands Extends appmsw.telestat.API.service
{

/// Get commands
ClassMethod GetCommands(ByRef comm, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	// Header 
	;set comm="Service for tracking the status of Ensemble and IRIS servers. Can receive commands: "_$$$NL
	//s comm("/CommandName")=$listbuild("class","method",arg."Description","routine")
	;set comm("/ServersStatus")=$listbuild("appmsw.telestat.API.status","ServersStatus","","Get a list of monitored instances","")
	;set comm("/GetLastAlerts")=$listbuild("appmsw.telestat.API.commands","GetAlerts","","Get last alerts. Server: '"_$Zu(110)_"'","")
	
	set comm="Сервис для мониторинга событий. Вы можете вводить команды: "_$$$NL
	set comm("/ServersStatus")=$listbuild("appmsw.telestat.API.status","ServersStatus","","Get a list of monitored instances","")
	set comm("/GetLastAlerts")=$listbuild("appmsw.telestat.API.commands","GetAlerts","","Get last alerts. Server: '"_$Zu(110)_"'","")
	// commands for admin
	#dim obj As appmsw.telestat.Bots
	set obj=##class(appmsw.telestat.Bots).GetObjByRoles("admin")
	if $isobject(obj) {
		if ChatId=obj.ChatId, Token=obj.TelegramToken { //if currently user is admin
			set comm("/Userlist")=$listbuild(..%ClassName(1),"UserList","","Get a list of users associated with the bot informant","")
		}
	}
	
	Quit $$$OK
}

/// Get commands for Admin
ClassMethod GetCommandsAdmin(ByRef comm, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	do ..GetCommands(.comm,ChatId,Token,NameFirst,NameLast)
	// Header replace
	set comm= "Bot administration service for tracking Ensemble and IRIS servers. Can take commands: "_$$$NL
	Quit $$$OK
}

/// do ##class(%SYS.System).WriteToConsoleLog("InterSystems Interoperability Contest",,3)
/// do ##class(appmsw.telestat.API.commands).GetAlerts(.str,.return)
ClassMethod GetAlerts(str, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	do ##class(appmsw.telestat.API.alert).GetAlertsFromServers(.str)
	;zw str q
	;set alarm=$wc($zhex("1F384")) ;U+1F384		tree
	set alarm=$wc($zhex("1F5A5")) ;	computer
	;	s alarm=$wc($zhex("1F6A8"))	;alarm
	set return=""
	set host=""
	for  { set host=$Order(str(host)) quit:host=""
		set ins=""
		for  { set ins=$Order(str(host,ins)) quit:ins=""
			set return=return_"---------"_alarm_host_"("_ins_")"_$$$NL
			set i=""
			for ii=1:1 { set i=$Order(str(host,ins,i),-1,val) quit:i=""
				if ii>10 continue
				
				set icon=$wc($zhex("1F610")) ;neutral
				if $P(val," ",3)>2 set icon=$wc($zhex("1F621")) ;rage
				set end=130
				set val=$e(val,1,end)_$s($e(val,end)'="":"...",1:"")
				set return=return_icon_$GET(val)_$$$NL
			}
		}
	}
	if return="" set return="...empty"_$$$NL
	set return=return_"/GetLastAlerts /start"_$$$NL
 quit $$$OK
}

/// w ##class(appmsw.telestat.API.commands).GetAlertOne("http://iris/apptoolsrest/alerts/7","UserTeleStat","UserTeleStat2021",.list)
ClassMethod GetAlertOne(url, user = "", pass = "", ByRef list) As %Status
{
	set st=$$$OK
	;w !,url
	if ##class(apptools.core.net).GetHttp(url,.out2,,,user, pass) {
		;w !,url zw out2
		set stream1=out2("content")
		set status=$g(out2("status"))
		do stream1.Rewind() 
		set ret=""
		while '(stream1.AtEnd) {
			set ret=ret_stream1.ReadLine()
		}
		try {
		 set instance={}.%FromJSON(ret).instance 
		 set host={}.%FromJSON(ret).host
		 set alerts={}.%FromJSON(ret).alerts
		 	 for i=0:1:alerts.%Size()-1 {
				set item = alerts.%Get(i)
				set list(host,instance,$i(list))=item.text
		 	 }
		}
		catch e {
			set st=$$$ERROR($$$GeneralError,$ze)
		}

	}
	quit st
}

/// do ##class(appmsw.telestat.API.commands).UserList()
ClassMethod UserEdit(id, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	#dim obj As appmsw.telestat.Bots
	set obj=##class(appmsw.telestat.Bots).%OpenId(id)
	if $isobject(obj) {
		;set return="Change the access rights for the user "_obj.NameFirst_" "_obj.NameLast_$$$NL
		set username=obj.NameFirst_" "_obj.NameLast
		
		set @..#GNtmp@("Admin",id)=$lb($h,obj.TelegramToken,obj.ChatId,obj.Number,obj.NameFirst,obj.NameLast)
		
		set buttons="=Access:"_$Select(obj.Access="Yes":"No",1:"Yes")_":"_id
		set buttons=buttons_",=Notify:"_$Select(obj.Notify="Yes":"No",1:"Yes")_":"_id
		
		do ##class(appmsw.telestat.API.util).ToAdmin("Change the access rights for "_username,buttons)
	}
	else {
		set return="...empty"_$$$NL
	}
	quit $$$OK
}

/// do ##class(appmsw.telestat.API.commands).UserList()
ClassMethod UserList(arg, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	set return="List of active users:"_$$$NL
	set icon = $wc($zhex("1F610")) ;neutral
	set iconrage = $wc($zhex("1F621")) ;rage
	set result=##CLASS(%ResultSet).%New("%DynamicQuery:SQL")
	set tSC=result.Prepare("select ID,NameFirst,NameLast,Number,Access,Notify,ChatId,Resource,TimeStamp,Groups,IsAdmin,Allow FROM appmsw_telestat.Bots where Roles ='informer' and ChatId  is not null order by NumCommSent desc")
	set:tSC tSC=result.Execute()
	if '$$$ISOK(tSC) {
		QUIT tSC
	}
	else {
		while result.Next() {
			set ico=icon
			set Acc=result.Data("Access")
			set id=result.Data("ID")			
			if $E(Acc,1)'="Y" set ico=iconrage
			set command="/UserEdit"_id
			set @..#GNtmp@("Command",ChatId,command)=$listbuild(..%ClassName(1),"UserEdit",id,"Get last alerts. Server: '"_$Zu(110)_"'")
			set return= return_ico_" "_command_" "_result.Data("Number")_ ", "_result.Data("NameFirst")_" "_result.Data("NameLast")_", Access:"_Acc_", Notify:"_result.Data("Notify")_$$$NL
		}
	}
	set:return="" return="...empty"_$$$NL
	quit $$$OK
}

}

