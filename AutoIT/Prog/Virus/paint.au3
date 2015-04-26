ProgressOn("Download Progress", "Trojan Horse Transfer ...", "0 percent")
For $i = 5 to 100 step 5
sleep(600)
ProgressSet( $i, $i & " %")
Next
ProgressSet(100 , "Done", "Complete")
sleep(500)
ProgressOff()