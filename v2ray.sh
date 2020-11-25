#!/bin/sh

# config v2ray
cat << EOF > /etc/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
            "id": "8c35bef3-d51f-41ab-ac87-7b053410495b",
            "alterId": 1
                    }
                ]
            },
            "streamSettings": {
                "network": "ws"
            }
        }
    ],

    "outbounds": [
        {
            "protocol": "freedom"
        },
        {
            "protocol": "blackhole",
            "tag": "blocked"
        },
        {
            "protocol": "socks",
            "tag": "sockstor",
            "settings": {
                "servers": [
                    {
                        "address": "127.0.0.1",
                        "port": 9050
                    }
                ]
            }
        }
    ],

    "routing": {
        "rules": [
            {
                "type": "field",
                "outboundTag": "sockstor",
                "domain": [
                    "geosite:tor"
                ]
            },
            {
                "type": "field",
                "outboundTag": "blocked",
                "domain": [
                    "geosite:category-ads-all"
                ]
            }
        ]
    }
}		
EOF

# start tor and v2ray
nohup tor &
v2ray -config /etc/config.json
