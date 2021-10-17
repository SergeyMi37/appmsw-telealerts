Class appmsw.telestat.API.status Extends appmsw.telestat.API.service
{

/// do ##class(appmsw.telestat.API.status).ServersStatus()
ClassMethod ServersStatus(arg, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	;set icon = $wc($zhex("1F610")) ;neutral
	set ret = ##class(appmsw.telestat.API.status).GetStat(ChatId)
	set return=ret
	set:$GET(ret)="" return="...empty"_$$$NL
	quit $$$OK
}

/// Get URL for all systems
/// do ##class(appmsw.telestat.API.status).GetListServers(.srv)
ClassMethod GetListServers(res) As %Status
{
	set url="http://servname/apptoolsrest/products/" ;  ##class(apptools.core.rest).getProductions
	set aurl="http://servname/apptoolsrest/alerts/3" ;alerts for 3 days  ##class(apptools.core.rest).GetAlerts
	
	;set res("prod")=$lb($replace(url,"servname","iris"),"UserTeleStat","UserTeleStat2021","iris",$replace(aurl,"servname","iris"))
	;set res("test")=$lb($replace(url,"servname","iris-test"),"UserTeleStat","UserTeleStat2021","iris-test",$replace(aurl,"servname","iris-test"))
	;set res("test20203")=$lb($replace(url,"servname","iris-test:52773"),"UserTeleStat","UserTeleStat2021","IRIS20203",$replace(aurl,"servname","iris-test:52773"))
	;set res("docker215")=$lb($replace(url,"servname","172.16.253.215:49157"),"UserTeleStat","UserTeleStat2021","Docker",$replace(aurl,"servname","172.16.253.215:49157"))
	if ##class(appmsw.telestat.API.inst).GetList(,.res)
}

/// Get a brief status of all systems
/// do ##class(appmsw.telestat.API.status).GetStat()
ClassMethod GetStat(ChatId) As %Status
{
	set ret="Status sytems:"_$$$NL
	do ..GetListServers(.res)
	set r="0"
	for { set r=$o(res(r),1,D) quit:r=""
		set user=$lg(D,2)
		set pass=$lg(D,3)
		set name=$lg(D,4)
		set url=$lg(D,1)_"0" 
		set ok=..GetStatOne(url,user,pass) 
		if ok["OK" {
			set stat="OK",icon=$wc($zhex("1F610"))_"/" 
			set @..#GNtmp@("Command",ChatId,"/server_"_name)=$lb("appmsw.telestat.API.status","GetProductServer",name)
			}
		else { 
			set stat="Error",icon=$wc($zhex("1F621"))_"\" 
			}
		set ret=ret_icon_"server_"_name_" "_stat_$$$NL
		if stat="Error" s err=ok
	}
	quit ret
}

/// Get products in areas with a number of errors
ClassMethod GetProductServer(node, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	do ##class(appmsw.telestat.API.inst).GetList(node,.res)
	set str=$g(res(1))
	set ret="Status productions of "_$lg(str,4)_$$$NL
	set ok=..GetStatOne($lg(str,1)_1,$lg(str,2),$lg(str,3),.prods,ChatId,node)
	set return=ret_$GET(prods)_"/ServersStatus /GetLastAlerts"_$$$NL
	quit $$$OK
}

/// w ##class(appmsw.telestat.API.status).GetStatOne("http://iris/apptoolsrest/products/0","UserTeleStat","Pass2021") 	; OK or Error
/// w ##class(appmsw.telestat.API.status).GetStatOne("http://iris/apptoolsrest/products/1","UserTeleStat","Pass2021") 	; products list
/// w ##class(appmsw.telestat.API.status).GetStatOne("http://iris/apptoolsrest/productslist/-MVK","UserTeleStat","Pass2021") ;
ClassMethod GetStatOne(url, user = "", pass = "", ByRef prods, ChatId = "", node = "") As %Status
{
	set status=""
	set prods=""
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
		 set server={}.%FromJSON(ret).server 
		 if $e(url,*-1,*)="/1" {   // get the number of errors
		 set ns={}.%FromJSON(ret).ns
		 ;zw ns
		 	 for i=0:1:ns.%Size()-1 {
				set item = ns.%Get(i)
				if item.counterrors {
					set icon=$wc($zhex("1F621"))_"/"
					set @..#GNtmp@("Command",ChatId,"/"_item.namespace)=$lb("appmsw.telestat.API.status","GetProductErr",$lb(node,item.namespace))
				}
				else {
					set icon=$wc($zhex("1F610"))_"\"
				}
				set prods=prods_icon_item.namespace_" Errors: "_item.counterrors_$$$NL
				;set Prod(item.namespace)=item.counterrors
		 	 }
		 }
		 elseif $e(url,*-1,*)'="/0" {  //get a list of errors
			set ns={}.%FromJSON(ret).ns
		 	for i=0:1:ns.%Size()-1 {
				set item = ns.%Get(i)
				set err=item.errors
		 	 	for ii=0:1:err.%Size()-1 {
					set er = err.%Get(ii)
					;w !,"----",ii zw er w !!!								continue
					set icon=$wc($zhex("1F621"))
					set prods=prods_icon_" "_er.TimeLogged_" "_er.Text_$$$NL
			 	 	
			 	 	}
				set prods=$e(prods,1,4024)_$s($e(prods,4024)'="":"...",1:"")_$$$NL
		 	 }
		 }
		}
		catch e {
			set server=""
		}
		if server'="" quit "OK"
	}
	quit "Error"
}

ClassMethod GetProductErr(nodens, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	set node=$lg(nodens,1)
	set ns=$lg(nodens,2)
	do ##class(appmsw.telestat.API.inst).GetList(node.res)
	set str=$g(res(1))
	set ret="List first errors of "_ns_$$$NL
	if str="" { 
		set prods="not found node "_node
	}
	else {
		set url=$replace($lg(str,1),"/products/","/productslist/-"_ns)
		set ok=..GetStatOne(url,$lg(str,2),$lg(str,3),.prods,ChatId,node)
	}
	set return=ret_$g(prods)_"/ServersStatus /GetLastAlerts"_$$$NL
	quit $$$OK
}

}

