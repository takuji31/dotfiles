# Defined in /var/folders/r9/bt0bb6n151n_3d8kwl2nw7880000gn/T//fish.pYit19/react-adb-reverse.fish @ line 1
function react-adb-reverse
	adb reverse tcp:7007 tcp:7007
  adb reverse tcp:9001 tcp:9001
  adb reverse tcp:8081 tcp:8081
end
