Class appmsw.telestat.API.alert Extends appmsw.telestat.API.service
{

/// Check and receive alerts from different servers and send them to subscribed users
ClassMethod Alerts(nodens, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	do ##class(appmsw.telestat.API.alert).GetAlertsFromServers(.str)
	s alarm=$wc($zhex("1F6A8"))	
	
	set return=""
	set host=""
	for  { set host=$Order(str(host)) quit:host=""
		set ins=""
		for  { set ins=$Order(str(host,ins)) quit:ins=""
			set alarmhostins="---------"_alarm_host_" ("_ins_")"_$$$NL
			set i="",ret=""
			for ii=1:1 { set i=$Order(str(host,ins,i),-1,val) quit:i=""
				if ii>10 quit
				if '$D(@..#GNtmp@("Alert",host,ins,$P(val," ",1,2))) {
					set Alert=$G(Alert)+1
					,@..#GNtmp@("Alert",host,ins,$P(val," ",1,2))=$h
					,last=val
							
					set icon=$wc($zhex("1F610")) ;neutral
					if $P(val," ",3)>2 set icon=$wc($zhex("1F621")) ;rage
					set end=130
					set val=$e(val,1,end)_$s($e(val,end)'="":"...",1:"")
					set ret=ret_icon_$GET(val)_$$$NL
				}
			}
			if ret'="" {
				set return=return_alarmhostins_ret
			}
			
		}
		
	}
	if return="" set return="...empty"_$$$NL
	set return=return_"/GetLastAlerts /start"_$$$NL
	
	if $G(Alert) {
		$$$TRACE("Error "_last)
		set message=$G(return)
		set result=##CLASS(%ResultSet).%New("%DynamicQuery:SQL")
		set tSC=result.Prepare("select ID,NameFirst,NameLast,Number,Access,Notify,TelegramToken,ChatId,Resource,TimeStamp,Groups,IsAdmin,Allow FROM appmsw_telestat.Bots where Notify ='Yes' and ChatId is not null")
		set:tSC tSC=result.Execute()
		if '$$$ISOK(tSC) {
			QUIT tSC
		}
		else {
			while result.Next() {
				set ChatId=result.Data("ChatId")
				set TelegramToken =result.Data("TelegramToken")
				set st=##class(appmsw.telestat.API.util).TelegramSendMessage(TelegramToken ,ChatId,"sendMessage",message)
				$$$TRACE("Sent "_result.Data("NameFirst")_" "_result.Data("NameLast"))
			}
		}
	}
	quit $$$OK
}

ClassMethod GetAlertsFromServers(str) As %Status
{
	;do ##class(%SYSTEM.Monitor).GetAlerts(,.str,.last)
	set ret="Status sytems:"_$$$NL
	do ##class(appmsw.telestat.API.status).GetListServers(.res)
	;zw res
	set r="0"
	for { set r=$o(res(r),1,D) quit:r=""
		set user=$lg(D,2)
		set pass=$lg(D,3)
		set url=$lg(D,5) 
		set ok=##class(appmsw.telestat.API.commands).GetAlertOne(url,user,pass,.str) 
		;w !,ok
	}
 quit $$$OK
}

}

