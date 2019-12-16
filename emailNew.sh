#!/bin/bash
echo ""
echo ""
echo "===###===="

# TCPPortScan=401
TCPPortScanStatus="Aman"
TCPPortScan=$(grep "TCP Port Scan Attack" /var/log/auth.log -c)
#bodyTCPPortScan=$(grep "TCP Port Scan Attack" /var/log/auth.log | head -n 1)

# UDPPortScan=0
UDPPortScanStatus="Aman"
UDPPortScan=$(grep "UDP Port Scan Attack" /var/log/auth.log -c)
#bodyUDPPortScan=$(grep "UDP Port Scan Attack" /var/log/auth.log | head -n 1)

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

echo $TCPPortScan
echo $UDPPortScan
echo $SQLINJECTIONAttack
echo $PingAttack
echo $SynDDOSAttack

if [[ "$SynDDOSAttack" -gt "$BatasWaspada" || "$TCPPortScan" -gt "$BatasWaspada" || "$SQLINJECTIONAttack" -gt "$BatasWaspada" || "$UDPPortScan" -gt "$BatasWaspada" || "$PingAttack" -gt "$BatasWaspada" ]]; then
    StatusWaspada=1

    if [[ "$SynDDOSAttack" -gt "$BatasWaspada" ]]; then
        SynDDOSAttackStatus="Waspada"
    fi

    if [[ "$TCPPortScan" -gt "$BatasWaspada" ]]; then
        TCPPortScanStatus="Waspada"
    fi

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

if [[ "$SynDDOSAttack" -gt "$BatasBahaya" || "$TCPPortScan" -gt "$BatasBahaya" || "$SQLINJECTIONAttack" -gt "$BatasBahaya" || "$UDPPortScan" -gt "$BatasBahaya" || "$PingAttack" -gt "$BatasBahaya" ]]; then
    StatusBahaya=1

    if [[ "$SynDDOSAttack" -gt "$BatasBahaya" ]]; then
        SynDDOSAttackStatus="Bahaya"
    fi

    if [[ "$TCPPortScan" -gt "$BatasBahaya" ]]; then
        TCPPortScanStatus="Bahaya"
    fi

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
            <head><title>Daftar Serangan</title>
            </head>
            <body>
            <table border="1">
                <tr>
                    <td>Tipe Serangan</td>
                    <td>Jumlah Serangan</td>
                    <td>Kategori</td>
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
        Jenis Serangan : Syn DDOS Attack
        Jumlah Serangan : '"$SynDDOSAttack"'
        Kategori : '"$SynDDOSAttackStatus"
    fi

    if [[ $TCPPortScanStatus != "Aman" ]]; then
        body=''"${body}"' <tr>
                        <td>TCP Port Attack</td>
                        <td>'"$TCPPortScan"'</td>
                        <td>'"$TCPPortScanStatus"'</td>
                    </tr>'
        telegramBody='
        '"${telegramBody}"' 
        Jenis Serangan : TCP Port Attack
        Jumlah Serangan : '"$TCPPortScan"'
        Kategori : '"$TCPPortScanStatus"
    fi

    if [[ "$SQLINJECTIONAttackStatus" != "Aman" ]]; then
        body=''"${body}"' <tr>
                        <td>SQL Injection Attack</td>
                        <td>'"$SQLINJECTIONAttack"'</td>
                        <td>'"$SQLINJECTIONAttackStatus"'</td>
                    </tr>'
        telegramBody='
        '"${telegramBody}"' 
        Jenis Serangan : SQL Injection Attack
        Jumlah Serangan : '"$SQLINJECTIONAttack"'
        Kategori : '"$SQLINJECTIONAttack"
    fi

    if [[ "$UDPPortScanStatus" != "Aman" ]]; then
        body=''"${body}"' <tr>
                        <td>UDP Port Scan</td>
                        <td>'"$UDPPortScan"'</td>
                        <td>'"$UDPPortScanStatus"'</td>
                    </tr>'
        telegramBody='
        '"${telegramBody}"' 
        Jenis Serangan : UDP Port Scan
        Jumlah Serangan : '"$UDPPortScan"'
        Kategori : '"$UDPPortScanStatus"
    fi

    if [[ "$PingAttackStatus" != "Aman" ]]; then
        body=''"${body}"' <tr>
                        <td>Ping Attack</td>
                        <td>'"$PingAttack"'</td>
                        <td>'"$PingAttackStatus"'</td>
                    </tr>'
        telegramBody='
        '"${telegramBody}"' 
        Jenis Serangan : Ping Attack
        Jumlah Serangan : '"$PingAttack"'
        Kategori : '"$PingAttackStatus"
    fi

    body=''"${body}"' </table>
            </body>
            </html>'

    
    echo $body | mail -a "From: me@example.com" -a "MIME-Version: 1.0" -a "Content-Type: text/html" -s "This is the subject" danurwijayanto@gmail.com
    curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$telegramBody" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
    # echo "Terdapat serangan dengan batas waspada"
    # echo "asdasdasd"
fi

exit 0;
# if [[ "$SynDDOSAttack" -gt 50 && "$TCPPortScan" -eq 0 && "$SQLINJECTIONAttack" -eq 0 ]]; then
#         echo "Masuk Syn Flood ==> $SynDDOSAttack"
#         echo $bodySynDDOSAttack
#         echo "$bodySynDDOSAttack" | mailx -s subject rezki.nurhadi92@gmail.com
#         curl -s –max-time 10 -d "chat_id=761990521&disable_web_page_preview=1&text=$bodySynDDOSAttack" https://api.telegram.org/bot963681097:AAFot3ghz6Lnl1mNyx4h9FnaQUZySaQ9l4c/sendMessage
#         truncate /var/log/auth.log --size 0
# fi



