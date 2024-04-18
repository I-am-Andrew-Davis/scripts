#!/usr/bin/bash
#
FIG_PATH=/home/gtv6bk/Documents/weeklyMeetings/2024/April/10/figures
CHART_PATH=/home/gtv6bk/Documents/weeklyMeetings/2024/April/10/charts
DATA_PATH=/home/gtv6bk/Documents/weeklyMeetings/2024/April/10/charts/data
while getopts "fcd:" flag; do
    case $flag in
        f) # moved files to the weekly meeting figures directory
            mv ${@:2} $FIG_PATH
            ;;
        c)  # moved files to the weekly meeting charts directory
            mv ${@:2} $CHART_PATH
            ;;
        d) # moved files to the weekly meeting data directory
            mv ${@:2} $DATA_PATH
            ;;
        \?)
            # Handle invalid options
            echo 'Select f - for figures, c - for charts, d - for data'
            exit 1
            ;;
    esac
done
