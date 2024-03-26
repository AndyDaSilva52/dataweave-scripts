%dw 2.0
var root = 'Root'
var arrayKeys = ["Emails", "Phones", "Mobiles"]
var objectKeys = keysOf( (payload.'$(root)' default {}) as Object) -- (arrayKeys)
---
{
	(objectKeys map {
		(($): ((payload.'$(root)'.'$($)' default {}) as Object mapObject ((value, key, index) ->
        (key): (value match {
            case is String -> (
              if(trim(value) ~= "NULL") null else trim(value)
            )
            else -> value
        })
    )))
	}),
	(
		arrayKeys map {
		(
			($): (
				(payload.'$(root)'.*'$($)' default []) as Array map ((item, index) ->
					item as Object mapObject ((value, key, index) ->
						(key): (value match {
                case is String -> (
                  if(trim(value) ~= "NULL") null else trim(value)
                )
                else -> value
            })
					)
				)
			)
		) if(payload.'$(root)'.'$($)'?)
	})
}