%dw 2.0
output application/json

fun xmlTextMaskSensitiveData(xml, fields) = do {

    (flatten(

    fields map ((field, idx) ->

				xml scan ("(\<$(field)\>)(.+)(\<\/$(field)\>)" as Regex) map ((found, index) ->

					if(!isEmpty(found[2]))
							{
									o: "$(field)>"++ found[2] ++"</$(field)",
									r: "$(field)>***</$(field)",
							}
					else
					null

				)

			)

    ) filter !isEmpty($) )

    reduce ((texto, x = xml) ->
      x
        replace (texto.o as String)
        with (texto.r as String)
    )

}
---
{
    original: payload.XML,
    masked: xmlTextMaskSensitiveData(payload.'XML', (Mule::p("logger.dataMaskingFieldsCSV") splitBy  ",") )
}