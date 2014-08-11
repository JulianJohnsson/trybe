flashCallback = ->
    $(".alert").animate
      height: 0
      opacity: 0
    , 350
    , ->
      $(this).remove()

$ ->
    $(".alert").bind 'click', (ev) =>
        flashCallback()
    setTimeout flashCallback, 2500