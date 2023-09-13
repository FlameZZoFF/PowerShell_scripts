$CAtagopen = "<ca>"
$CAtagclose = "</ca>"
$CERTtagopen = "<cert>"
$CERTtagclose = "</cert>"
$KEYtagopen = "<key>"
$KEYtagclose = "</key>"
$TLStagopen = "<tls-auth>"
$TLStagclose = "</tls-auth>"
$CA = Get-Content -Path  .\ca.crt 
$CERT = Get-Content -Path .\*.crt -Exclude ca*
$KEY = Get-Content -Path .\*.key -Exclude ta*
$TLS = Get-Content -Path .\ta.key

foreach($item in $CERT){
  if($item.StartsWith("-----BEGIN CERTIFICATE")){
  $x = $CERT.IndexOf($item)
  $CERT = $CERT[$x..200]
  }
}

foreach($item in $TLS){
  if($item.StartsWith("-----BEGIN OpenVPN")){
  $x = $TLS.IndexOf($item)
  $TLS = $TLS[$x..200]
  }
}

#Вводим ниже свои настройки конфигурации

New-Item -Path . -Name "cert_for_current_user.ovpn" -ItemType "file" -Value "client                             
proto tcp-client              
dev tun                          
remote   
remote    
tls-auth [inline] 1           
remote-cert-tls server   
cipher   
user nobody
group abrt
verb 2                           
mute 20                       
keepalive 10 120          
comp-lzo                      
persist-key                   
persist-tun                    
float                            
resolv-retry infinite  
auth-user-pass     
nobind                                   
pull 


"
Add-Content -Path .\cert_for_current_user.ovpn -Value $CAtagopen
Add-Content -Path .\cert_for_current_user.ovpn -Value $CA
Add-Content -Path .\cert_for_current_user.ovpn -Value $CAtagclose
Add-Content -Path .\cert_for_current_user.ovpn -Value $CERTtagopen
Add-Content -Path .\cert_for_current_user.ovpn -Value $CERT
Add-Content -Path .\cert_for_current_user.ovpn -Value $CERTtagclose
Add-Content -Path .\cert_for_current_user.ovpn -Value $KEYtagopen
Add-Content -Path .\cert_for_current_user.ovpn -Value $KEY
Add-Content -Path .\cert_for_current_user.ovpn -Value $KEYtagclose
Add-Content -Path .\cert_for_current_user.ovpn -Value $TLStagopen
Add-Content -Path .\cert_for_current_user.ovpn -Value $TLS
Add-Content -Path .\cert_for_current_user.ovpn -Value $TLStagclose