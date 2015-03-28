info = (msg) ->
  console.log msg
  $('#log').prepend $('<li>').text msg

morseCode =
  A: ".-"
  B: "-..."
  C: "-.-."
  D: "-.."
  E: "."
  F: "..-."
  G: "--."
  H: "...."
  I: ".."
  J: ".---"
  K: "-.-"
  L: ".-.."
  M: "--"
  N: "-."
  O: "---"
  P: ".--."
  Q: "--.-"
  R: ".-."
  S: "..."
  T: "-"
  U: "..-"
  V: "...-"
  W: ".--"
  X: "-..-"
  Y: "-.--"
  Z: "--.."


playMorseStr = (str) ->
  Promise.each str.split(''), (c) ->
    playMorseCode c
    .then ->
      return new Promise (resolve, reject) ->
        setTimeout ->
          resolve()
        , 1000


playMorseCode = (code) ->
  return new Promise (resolve, reject) ->
    return reject "'#{code}'.length must be 1" if code.length isnt 1
    return reject "A-Z is ok" unless /[a-z]/i.test code
    code = code.toUpperCase()
    pattern = morseCode[code].split('').join(' ').split('').map (i) ->
      switch i
        when '.' then 100
        when '-' then 300
        when ' ' then 300

    info "#{code}: #{morseCode[code]}"
    navigator.vibrate pattern
    setTimeout ->
      resolve()
    , pattern.reduce (a,b) -> a+b

start = ->
  playMorseStr $('#sourceText').val()
  .then ->
    start()

$ ->
  info "start"
  return if typeof navigator?.vibrate isnt 'function'
  info "navigator.vibrate found"

  start()
