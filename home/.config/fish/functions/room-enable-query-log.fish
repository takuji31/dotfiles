# Defined in /var/folders/9g/2zbs6ph55vb5bbtfdtn0pdk40000gn/T//fish.m8EZhJ/room-enable-query-log.fish @ line 1
function room-enable-query-log
  adb shell getprop log.tag.SQLiteStatements
  adb shell setprop log.tag.SQLiteStatements VERBOSE
  adb shell setprop log.tag.SQLiteStatements VERBOSE
end
