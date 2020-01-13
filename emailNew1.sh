#!/bin/bash
echo ""
echo ""
echo "===###===="

# SynDDOSAttack=0
SynDDOSAttackStatus="Aman"
SynDDOSAttack=$(grep "Syn DDOS Attack Detected" /var/log/auth.log -c)
#bodySynDDOSAttack=$(grep "Syn DDOS Attack Detected" /var/log/auth.log | head -n 1)

# SQLINJECTIONAttack=0
SQLINJECTIONAttackStatus="Aman"
SQLINJECTIONAttack=$(grep "SQL INJECTION Attack Detected" /var/log/auth.log -c)
#bodySQLINJECTIONAttack=$(grep "SQL INJECTION Attack Detected" /var/log/auth.log | head -n 1)

# PingAttack=4001
PingAttackStatus="Aman"
PingAttack=$(grep "Ping DDOS Attack Detected" /var/log/auth.log -c)
#bodyPingAttack=$(grep "Ping DDOS Attack Detected" /var/log/auth.log | head -n 1)

BatasWaspada=400
BatasBahaya=4000

StatusWaspada=0
StatusBahaya=0

if [[ "$SQLINJECTIONAttack" -gt "$BatasWaspada" || "$UDPPortScan" -gt "$BatasWaspada" || "$PingAttack" -gt "$BatasWaspada" ]]; then
    StatusWaspada=1

    if [[ "$SQLINJECTIONAttack" -gt "$BatasWaspada" ]]; then
        SQLINJECTIONAttackStatus="Waspada"
    fi

    if [[ "$UDPPortScan" -gt "$BatasWaspada" ]]; then
        UDPPortScanStatus="Waspada"
    fi

    if [[ "$PingAttack" -gt "$BatasWaspada" ]]; then
        PingAttackStatus="Waspada"
    fi
fi

if [[ "$SQLINJECTIONAttack" -gt "$BatasBahaya" || "$UDPPortScan" -gt "$BatasBahaya" || "$PingAttack" -gt "$BatasBahaya" ]]; then
    StatusBahaya=1

    if [[ "$SQLINJECTIONAttack" -gt "$BatasBahaya" ]]; then
        SQLINJECTIONAttackStatus="Bahaya"
    fi

    if [[ "$UDPPortScan" -gt "$BatasBahaya" ]]; then
        UDPPortScanStatus="Bahaya"
    fi

    if [[ "$PingAttack" -gt "$BatasBahaya" ]]; then
        PingAttackStatus="Bahaya"
    fi
fi

if [[ "$StatusWaspada" -eq "1" || "$StatusBahaya" -eq "1" ]]; then

    body='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
            <html>
            <head><title>Attack List</title>
            </head>
            <body>
            <table border="1">
                <tr>
                    <td>Attack Type</td>
                    <td>Total Attack</td>
                    <td>Category</td>
                </tr>'
    telegramBody='Laporan Serangan'
    if [[ "$SynDDOSAttackStatus" != "Aman" ]]; then
        body=''"${body}"' <tr>
                        <td>Syn DDOS Attack</td>
                        <td>'"$SynDDOSAttack"'</td>
                        <td>'"$SynDDOSAttackStatus"'</td>
                    </tr>'
        telegramBody='
        '"${telegramBody}"' 
        Attack Type : Syn DDOS Attack
        Total : '"$SynDDOSAttack"'
        Category : '"$SynDDOSAttackStatus"
    fi

    if [[ "$SQLINJECTIONAttackStatus" != "Aman" ]]; then
        body=''"${body}"' <tr>
                        <td>SQL Injection Attack</td>
                        <td>'"$SQLINJECTIONAttack"'</td>
                        <td>'"$SQLINJECTIONAttackStatus"'</td>
                    </tr>'
        telegramBody='
        '"${telegramBody}"' 
        Attack Type : SQL Injection Attack
        Total : '"$SQLINJECTIONAttack"'
        Category : '"$SQLINJECTIONAttack"
    fi

    if [[ "$PingAttackStatus" != "Aman" ]]; then
        body=''"${body}"' <tr>
                        <td>Ping Attack</td>
                        <td>'"$PingAttack"'</td>
                        <td>'"$PingAttackStatus"'</td>
                    </tr>'
        telegramBody='
        '"${telegramBody}"' 
        Attack Type : Ping Attack
        Total : '"$PingAttack"'
        Category : '"$PingAttackStatus"
    fi

    body=''"${body}"' </table>
            </body>
            </html>'


    echo $body | mail -a "From: me@example.com" -a "MIME-Version: 1.0" -a "Content-Type: text/html" -s "This is the subject" rezki.nurhadi92@gmail.com
    curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$telegramBody" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
    # echo "Terdapat serangan dengan batas waspada"
    # echo "asdasdasd"
    truncate /var/log/auth.log --size 0
fi

exit 0;
# if [[ "$SynDDOSAttack" -gt 50 && "$TCPPortScan" -eq 0 && "$SQLINJECTIONAttack" -eq 0 ]]; then
#         echo "Masuk Syn Flood ==> $SynDDOSAttack"
#         echo $bodySynDDOSAttack
#         echo "$bodySynDDOSAttack" | mailx -s subject rezki.nurhadi92@gmail.com
#         curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$bodySynDDOSAttack" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
#         truncate /var/log/auth.log --size 0
# fi



