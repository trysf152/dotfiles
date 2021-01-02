#!/usr/bin/env bash

# print charging battery sign from nerd fonts
# (arg1: bool(charging), arg2: int(capacity))
function print_batt_sign() {
    if [[ $1 == true ]]; then
        # nerd fonts charging bat stat array (20, 20, 20, 30, 40, 40, 60, 80, 90, 100)
        batt_signs=('\UF585' '\UF585' '\UF585' '\UF586' '\UF587' '\UF587' \
                            '\UF588' '\UF588' '\UF589' '\UF58A' '\UF584')
    else
        # nerd fonts non charging bat stat array (00 to 100)
        batt_signs=('\UF58D' '\UF579' '\UF57A' '\UF57B' '\UF57C' '\UF57D' \
                                    '\UF57E' '\UF57F' '\UF580' '\UF581' '\UF578')
    fi

    bat_idx=$(expr $2 / 10)
    if ((0 <= ${bat_idx})) && ((${bat_idx} <= 10)); then
        printf ${batt_signs[bat_idx]}
    else
        printf '\UF582'
    fi
}
pwr_conn='\UFBA3'
pwr_discn='\UFBA4'

# printf battery glyph from nerd fonts

case $(uname) in
    Darwin)
        function print_mac_batt_stat() {
            case "$2" in
                'AC')
                    printf "${pwr_conn} $(print_batt_sign false $1) $1%%"
                        ;;
                'charging')
                    printf "${pwr_conn} $(print_batt_sign true $1) $1%%"
                        ;;
                'discharging')
                    printf "${pwr_discn} $(print_batt_sign false $1) $1%%"
                        ;;
                'charged')
                    printf "${pwr_discn} $(print_batt_sign false $1) $1%%"
                        ;;
                *)
                    printf "${pwr_conn} $(print_batt_sign false $1) $1%%"
                        ;;
            esac
        }
        print_mac_batt_stat $(pmset -g batt | \
                              awk 'NR==2{print($3 $4)}' | \
                              sed -e 's/;//g' -e 's/%/\ /')
        ;;
    Linux*)
        # check if battery is available
        batpath="/sys/class/power_supply/BAT0"
        if [[ -d ${batpath} ]]; then
            case $(<${batpath}/status) in
                Charging)
                    battery_stat="\UF587"
                ;;
                Discharging)
                    battery_stat="\UF57D"
                    ;;
                Full)
                    battery_stat="\UF578"
                    ;;
                "Not charging")
                    battery_stat="\UF57D"
                    ;;
                *)
                    battery_stat="\UF590"
                    ;;
            esac

            printf ${battery_stat}\ $(< ${batpath}/capacity)'%%'
        else
            printf "\UFBA3"\ "\UF590"
        fi

        ;;
    *)
        printf "\UF00D"
esac
