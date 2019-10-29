'script for searching users in Active Ditectory,
'which can register on a given computer

compname = ""
Do
  compname = InputBox("Enter computername", "Searching users which can register on a computer",compname)
  If compname = "" Then Exit Do

  Set objConnection = CreateObject("ADODB.Connection")
  objConnection.Open "Provider=ADsDSOObject;"
  Set objCommand = CreateObject("ADODB.Command")
  objCommand.ActiveConnection = objConnection

  objCommand.CommandText = _
          "<LDAP://dc=domain,dc=ru>;" & _
      "(&(objectCategory=user)(userWorkstations=*));" & _
        "userWorkstations,sAMAccountName,cn,telephoneNumber,adspath,description;subtree"
  Set objRecordSet = objCommand.Execute
 
  username = compname & VbCrLf
  While Not objRecordset.EOF
    strUserWorkstations = objRecordset.Fields("userWorkstations")
    if InStr(1, strUserWorkstations, compname, vbTextCompare) THEN
    	description=objRecordset.Fields("description")
      username = username & objRecordset.Fields("sAMAccountName") & ", " & _
        objRecordset.Fields("cn") & ", " & _
        objRecordset.Fields("telephoneNumber") & ", " & _
        description(0) & VbCrLf
    End If
    objRecordSet.MoveNext
  Wend
  Wscript.Echo username
Loop

