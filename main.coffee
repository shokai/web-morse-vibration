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

sleep = (msec) ->
  return new Promise (resolve) ->
    setTimeout ->
      resolve()
    , msec

playMorseStr = (str) ->
  Promise.each str.split(''), (c) ->
    playMorseCode c
    .then -> sleep 1000

playMorseCode = (code) ->
  return new Promise (resolve, reject) ->
    return reject "\"#{code}\".length must be 1" if code.length isnt 1
    return reject "\"#{code}\": A-Z is ok" unless /^[a-z]$/i.test code
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
  str = $('#sourceText').val()
  info "play \"#{str}\""
  playMorseStr str
  .then ->
    sleep 1000
  .then ->
    start()
  .catch (err) ->
    info err
    sleep 3000
    .then -> start()

$ ->
  info "start"
  if typeof navigator?.vibrate isnt 'function'
    return info "noavigator.vibrate not found"
  info "navigator.vibrate found"

  start()
