#!/bin/bash
echo ""
echo ""
echo "===###===="

# SynDDOSAttack=0
SynDDOSAttackStatus="Aman"
SynDDOSAttack=$(grep "TCP SYN flood attack detected" /var/log/auth.log -c)
#bodySynDDOSAttack=$(grep "TCP SYN flood attack detected" /var/log/auth.log | head -n 1)

# SQLINJECTIONAttack=0
SQLINJECTIONAttackStatus="Aman"
SQLINJECTIONAttack=$(grep "SQL INJECTION Attack Detected" /var/log/auth.log -c)
#bodySQLINJECTIONAttack=$(grep "SQL INJECTION Attack Detected" /var/log/auth.log | head -n 1)

# PingAttack=4001
PingAttackStatus="Aman"
PingAttack=$(grep "Ping DDOS Attack Detected" /var/log/auth.log -c)
#bodyPingAttack=$(grep "Ping DDOS Attack Detected" /var/log/auth.log | head -n 1)

BatasWaspada=5
BatasBahaya=8

StatusWaspada=0
StatusBahaya=0


if [[ "$SQLINJECTIONAttack" -gt "$BatasWaspada" || "$SynDDOSAttack" -gt "$BatasWaspada" || "$PingAttack" -gt "$BatasWaspada" ]]; then
    StatusWaspada=1

    if [[ "$SQLINJECTIONAttack" -gt "$BatasWaspada" ]]; then
        SQLINJECTIONAttackStatus="Waspada"
    fi

    if [[ "$SynDDOSAttack" -gt "$BatasWaspada" ]]; then
        SynDDOSAttackStatus="Waspada"
    fi

    if [[ "$PingAttack" -gt "$BatasWaspada" ]]; then
        PingAttackStatus="Waspada"
    fi
fi
#echo $SynDDOSAttack
if [[ "$SQLINJECTIONAttack" -gt "$BatasBahaya" || "$SynDDOSAttack" -gt "$BatasBahaya" || "$PingAttack" -gt "$BatasBahaya" ]]; then
    StatusBahaya=1

    if [[ "$SQLINJECTIONAttack" -gt "$BatasBahaya" ]]; then
        SQLINJECTIONAttackStatus="Bahaya"
    fi

    if [[ "$SynDDOSAttack" -gt "$BatasBahaya" ]]; then
        SynDDOSAttackStatus="Bahaya"
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
        # sed '/Syn DDOS Attack Detected/d' -i /var/log/auth.log
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
        # sed '/SQL INJECTION Attack Detected/d' -i /var/log/auth.log
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
        # sed '/Ping DDOS Attack Detected/d' -i /var/log/auth.log

    fi

    body=''"${body}"' </table>
            </body>
            </html>'

    #if [[ "$StatusBahaya" -eq "1" ]]; then
        if [[ "$SynDDOSAttackStatus" == "Bahaya" ]]; then
            sed '/TCP SYN flood attack detected/d' -i /var/log/auth.log
        fi
        if [[ "$SQLINJECTIONAttackStatus" == "Bahaya" ]]; then
            sed '/SQL INJECTION Attack Detected/d' -i /var/log/auth.log
        fi
        if [[ "$PingAttackStatus" == "Bahaya" ]]; then
            sed '/Ping DDOS Attack Detected/d' -i /var/log/auth.log
        fi
    #fi

    echo $body | mail -a "From: me@example.com" -a "MIME-Version: 1.0" -a "Content-Type: text/html" -s "This is the subject" rezki.nurhadi92@gmail.com
    curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$telegramBody" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
    # echo "Terdapat serangan dengan batas waspada"
    # echo "asdasdasd"
#    truncate /var/log/auth.log --size 0
fi

exit 0;
# if [[ "$SynDDOSAttack" -gt 50 && "$TCPPortScan" -eq 0 && "$SQLINJECTIONAttack" -eq 0 ]]; then
#         echo "Masuk Syn Flood ==> $SynDDOSAttack"
#         echo $bodySynDDOSAttack
#         echo "$bodySynDDOSAttack" | mailx -s subject rezki.nurhadi92@gmail.com
#         curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$bodySynDDOSAttack" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
#         truncate /var/log/auth.log --size 0
# fi
