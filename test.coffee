# implicit parents
#fail at start
console.log  "a"

#works
console.log "a"


#fail at opening
fun = ( a,b,c) ->
  console.log "a", a, "b", b, "c", c

#fail at closing
fun = (a,b,c ) ->
  console.log "a", a, "b", b, "c", c

#fail at both
fun = ( a,b,c ) ->
  console.log "a", a, "b", b, "c", c

#works
fun = (a,b,c) ->
  console.log "a", a, "b", b, "c", c

#List
#fail on open
a = [ 'a']

#fail on close
a = ['a' ]

#fail on both
a = [ 'a' ]

#works
a = ['a']

#Object
#fail on open
a = { "key":"value"}

#fail on close
a = {"key":"value" }

#fail on both
a = { "key":"value" }

#works
a = {"key":"value"}
