$(document).ready ->
  $("#calendar").fullCalendar(
    events: '/events.json'
  )