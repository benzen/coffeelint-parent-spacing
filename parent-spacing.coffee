_ = require "underscore"
OPENINGS = ['[',"{","(", "CALL_START", "PARAM_START"]
CLOSINGS = [']', "}", ")", "CALL_END", "PARAM_END"]
module.exports = class ParentSpacing
  rule:
    name: 'parent_spacing'
    level : 'warn'
    value: 0
    message : "Parents, brackets and braces must be properly spaced"
    description: """
        <p>This rules check to see that there is expected number of space
        after opening paren and before closing parent. This rule is trigger
        a warning by default.</p>

        <pre>
        <code>
        # If value is zero, the two following will trigger an error
        x( (a)-> a*3)
        x((a)-> a*3 )

        # This will not
        x((a)-> a*3)
        </code>
        </pre>
         """

  tokens: _.union OPENINGS, CLOSINGS

  lintToken : (token, tokenApi) ->

    # call start can generated parenthesis, don't bother checking this case
    if token[0] in ["CALL_START","CALL_END"] and token.generated?
      if token[0] is  "CALL_START"
        nt = tokenApi.peek(1)
        #one for next char, one for required creating a token
        nbSpace = (nt[2].first_column - token[2].last_column) - 2
        return nbSpace isnt @rule.value
      else return null

    # Throw error unless the following happens.
    #
    # If the token is '('
    # 1. We look at the next token to see
    # 2. If it's a space, count the number of space until a non-space char
    # 3. Compare the number of space and the value parm
    # 4. They are equal
    if token[0] in OPENINGS
      nt = tokenApi.peek(1)
      if @atEof(tokenApi) or nt[0] is "TERMINATOR" then return null
      nbSpace = (nt[2].first_column - token[2].last_column)-1
      return nbSpace isnt (@rule.value)

    if token[0] in CLOSINGS
      nt = tokenApi.peek(-1)
      nbSpace = (token[2].first_column - nt[2].last_column)-1
      return nbSpace isnt (@rule.value)

    return null

  # Are there any more meaningful tokens following the current one?
  atEof: (tokenApi) ->
    {tokens, i } = tokenApi
    for token in tokens.slice(i + 1)
      unless token.generated or token[0] in ['OUTDENT', 'TERMINATOR']
        return false
    true
