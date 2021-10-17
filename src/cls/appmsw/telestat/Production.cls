Class appmsw.telestat.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="appmsw.telestat.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="appmsw.telestat.TelegramService" Category="" ClassName="appmsw.telestat.TelegramService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">telestat</Setting>
    <Setting Target="Adapter" Name="TelegramToken">1125853026:AAHpEWzcpdLeYOnLpbZCilI67dxsKuQeaEU</Setting>
    <Setting Target="Adapter" Name="CallInterval">20</Setting>
    <Setting Target="Host" Name="TelegramOperation">appmsw.telestat.TelegramOperation</Setting>
    <Setting Target="Host" Name="ClassMessage">appmsw.telestat.API.service</Setting>
    <Setting Target="Adapter" Name="TelegramName">1125853026:AAHpEWzcpdLeYOnLpbZCilI67dxsKuQeaEU</Setting>
  </Item>
  <Item Name="appmsw.telestat.TelegramOperation" Category="" ClassName="appmsw.telestat.TelegramOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">telestat</Setting>
    <Setting Target="Adapter" Name="TelegramToken">1125853026:AAHpEWzcpdLeYOnLpbZCilI67dxsKuQeaEU</Setting>
    <Setting Target="Adapter" Name="TelegramName">1125853026:AAHpEWzcpdLeYOnLpbZCilI67dxsKuQeaEU</Setting>
  </Item>
  <Item Name="appmsw.telestat.TelegramServiceAlert" Category="" ClassName="appmsw.telestat.TelegramServiceAlert" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TelegramToken">1125853026:AAHpEWzcpdLeYOnLpbZCilI67dxsKuQeaEU</Setting>
    <Setting Target="Host" Name="SSLConfiguration">DefaultSSL</Setting>
    <Setting Target="Adapter" Name="CallInterval">300</Setting>
    <Setting Target="Host" Name="TelegramName">1125853026:AAHpEWzcpdLeYOnLpbZCilI67dxsKuQeaEU</Setting>
  </Item>
  <Item Name="appmsw.telestat.TelegramOperationAdmin" Category="" ClassName="appmsw.telestat.TelegramOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">telestat</Setting>
    <Setting Target="Adapter" Name="TelegramToken">1280096169:AAG-vrP6ErsBIM4j86b6zh6GEgE1m59zuwA</Setting>
    <Setting Target="Adapter" Name="TelegramName">AdBot</Setting>
  </Item>
  <Item Name="appmsw.telestat.TelegramServiceAdmin" Category="" ClassName="appmsw.telestat.TelegramService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">telestat</Setting>
    <Setting Target="Adapter" Name="TelegramToken">1280096169:AAG-vrP6ErsBIM4j86b6zh6GEgE1m59zuwA</Setting>
    <Setting Target="Adapter" Name="CallInterval">20</Setting>
    <Setting Target="Host" Name="TelegramOperation">appmsw.telestat.TelegramOperationAdmin</Setting>
    <Setting Target="Host" Name="ClassMessage">appmsw.telestat.API.admin</Setting>
    <Setting Target="Adapter" Name="TelegramName">AdBot</Setting>
  </Item>
</Production>
}

}

