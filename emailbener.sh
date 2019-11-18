#!/bin/bash 
echo ""
echo ""
echo "===###===="

TCPPortScan=$(grep "TCP Port Scan Attack" /var/log/auth.log -c)
bodyTCPPortScan=$(grep "TCP Port Scan Attack" /var/log/auth.log | head -n 1)

UDPPortScan=$(grep "UDP Port Scan Attack" /var/log/auth.log -c)
bodyUDPPortScan=$(grep "UDP Port Scan Attack" /var/log/auth.log | head -n 1)

SynDDOSAttack=$(grep "Syn DDOS Attack Detected" /var/log/auth.log -c)
bodySynDDOSAttack=$(grep "Syn DDOS Attack Detected" /var/log/auth.log | head -n 1)

SQLINJECTIONAttack=$(grep "SQL INJECTION Attack Detected" /var/log/auth.log -c)
bodySQLINJECTIONAttack=$(grep "SQL INJECTION Attack Detected" /var/log/auth.log | head -n 1)

PingAttack=$(grep "Ping DDOS Attack Detected" /var/log/auth.log -c)
bodyPingAttack=$(grep "Ping DDOS Attack Detected" /var/log/auth.log | head -n 1)


if [[ "$SynDDOSAttack" -gt 50 && "$TCPPortScan" -eq 0 && "$SQLINJECTIONAttack" -eq 0 ]]; then
        echo "Masuk Syn Flood ==> $SynDDOSAttack"
        echo $bodySynDDOSAttack
        echo "$bodySynDDOSAttack" | mailx -s subject rezki.nurhadi92@gmail.com
        curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$bodySynDDOSAttack" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
	truncate /var/log/auth.log --size 0
fi

if [[ "$SQLINJECTIONAttack" -gt "100" && "$SQLINJECTIONAttack" -lt "400" && "$TCPPortScan" -eq 0 ]]; then
        echo "Masuk SQLINJECTIONAttack ==> $SQLINJECTIONAttack"
        echo $bodySQLINJECTIONAttack
        echo "$bodySQLINJECTIONAttack" | mailx -s subject rezki.nurhadi92@gmail.com
        curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$bodySQLINJECTIONAttack" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
        truncate /var/log/auth.log --size 0
fi


if [[ "$PingAttack" -gt 3 && "$PingAttack" -lt 10 && "$SQLINJECTIONAttack" -eq 0 && "TCPPORTScan" -eq 0 ]]; then
        echo "Masuk PingAttack ==> $PingAttack"
        echo $bodyPingAttack
	echo "$bodyPingAttack" | mailx -s subject rezki.nurhadi92@gmail.com
        curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$bodyPingAttack" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
        truncate /var/log/auth.log --size 0
fi

if [[ "$UDPPortScan" -gt 20 && "$UDPPortScan" -lt 50 ]]; then
        echo "Masuk UDPPortScan ==> $UDPPortScan"
        echo $bodyUDPPortScan
	echo "$bodyUDPPortScan" | mailx -s subject rezki.nurhadi92@gmail.com
        curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$bodyUDPPortScan" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
        truncate /var/log/auth.log --size 0
fi

if [[ "$TCPPortScan" -gt 20 && "$TCPPortScan" -lt 40 && "$SynDDOSAttack" -gt 1500 ]]; then
        echo "Masuk TCPPortScan ==> $TCPPortScan"
        echo $bodyTCPPortScan
	echo "$bodyTCPPortScan" | mailx -s subject rezki.nurhadi92@gmail.com
        curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$bodyTCPPortScan" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
        truncate /var/log/auth.log --size 0
fi


echo ""
echo ""
echo "========"
echo "Total Data Syn Flood Attack ==> $SynDDOSAttack"
echo "Total Data SQLINJECTIONAttack ==> $SQLINJECTIONAttack"
echo "Total Data PingAttack ==> $PingAttack"
echo "Total Data TCP Port Scan Attack ==> $TCPPortScan"
echo "Total Data UDP Port Scan Attack ==> $UDPPortScan"

exit 0;
