%dw 2.0

fun p(arg: String) = if(arg == "logger.dataMaskingFieldsCSV")
  "Email,PhoneNumber,DocumentNumber"
  else arg