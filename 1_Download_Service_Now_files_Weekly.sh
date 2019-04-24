if [ `ps -ef|grep firefox|wc -l` -gt 1 ]

then

echo "Is Dispatch Console open in firefox? [Yy/N]"							

read answer

if [ "$answer" != "${answer#[Yy]}" ] 

then

echo "Opening Service Now"
sleep 2

firefox --new-window "https://ibmimiap.service-now.com/nav_to.do?uri=%2Fincident_list.do%3Fsysparm_query%3Dassignment_group%253Djavascript:getMyGroups()%255Esys_created_onONLast%2520week@javascript:gs.beginningOfLastWeek()@javascript:gs.endOfLastWeek()%26sysparm_first_row%3D1%26sysparm_view%3D"

sleep 6

firefox "https://ibmimieu.service-now.com/nav_to.do?uri=%2Fincident_list.do%3Fsysparm_query%3Dassignment_group%253Djavascript:getMyGroups()%255Esys_created_onONLast%2520week@javascript:gs.beginningOfLastWeek()@javascript:gs.endOfLastWeek()%26sysparm_first_row%3D1%26sysparm_view%3D"

sleep 6

firefox "https://ibmimina.service-now.com/nav_to.do?uri=%2Fincident_list.do%3Fsysparm_query%3Dassignment_group%253Djavascript:getMyGroups()%255Esys_created_onONLast%2520week@javascript:gs.beginningOfLastWeek()@javascript:gs.endOfLastWeek()%26sysparm_first_row%3D1%26sysparm_view%3D" \

sleep 6

firefox "https://ibmimiap.service-now.com/nav_to.do?uri=%2Fchange_request_list.do%3Fsysparm_query%3Dassignment_group%253D7d85e341dbd7cb401eeb347d7c961985%255EORassignment_group%253D8285e341dbd7cb401eeb347d7c9619f5%255Estart_dateONLast%2520week@javascript:gs.beginningOfLastWeek()@javascript:gs.endOfLastWeek()%26sysparm_first_row%3D1%26sysparm_view%3D" \

sleep 6

firefox "https://ibmimieu.service-now.com/nav_to.do?uri=%2Fchange_request_list.do%3Fsysparm_query%3Dassignment_group%253D7d85e341dbd7cb401eeb347d7c961985%255EORassignment_group%253D8285e341dbd7cb401eeb347d7c9619f5%255Estart_dateONLast%2520week@javascript:gs.beginningOfLastWeek()@javascript:gs.endOfLastWeek()%26sysparm_first_row%3D1%26sysparm_view%3D" \

sleep 6

firefox "https://ibmimina.service-now.com/nav_to.do?uri=%2Fchange_request_list.do%3Fsysparm_query%3Dassignment_group%253D7d85e341dbd7cb401eeb347d7c961985%255EORassignment_group%253D8285e341dbd7cb401eeb347d7c9619f5%255Estart_dateONLast%2520week@javascript:gs.beginningOfLastWeek()@javascript:gs.endOfLastWeek()%26sysparm_first_row%3D1%26sysparm_view%3D"

else

echo "Complete Single sign on first (Keep Dispatch Console running) and rerun this script"
sleep 2
echo "Opening Dispatch Console"
sleep 2

firefox "https://ibmimiap.service-now.com/sp?id=imi_dispatch_console"

fi
fi
