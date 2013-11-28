#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap/collapse
#= require twitter/bootstrap/transition
#= require twitter/bootstrap/modal
#= require jquery.fancybox
#= require jquery.sticky
#= require_tree .



jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
  $(".delete-video").bind "ajax:beforeSend", ->
    $(this).children("i").removeClass("fa-trash-o").addClass "fa-spinner fa-spin fa-lg"

  $(".delete-video").bind "ajax:success", ->
    $(this).children("i").removeClass("fa-trash-o fa-spinner fa-spin fa-lg").addClass "fa-check"
    $(this).children("span").html "Requested"


$(document).ready ->
  $(".preview-video").fancybox
    padding: 0
    width: 800
    height: 450
    aspectRatio: true
    scrolling: "no"
    helpers:
      media: {}
      title: null

  $(".new-video").fancybox
    padding: 0
    width: "90%"
    height: "100%"
    autoSize: false
    helpers:
      title: null

    onUpdate: ->
      @content[0].contentWindow.postMessage "resizeWufooForm", "*"

  $(".edit-video").fancybox
    autoSize: true
    maxWidth: 600
    helpers:
      title: null

  $(".btn-share").click (e) ->
    e.preventDefault()
    width = $(this).data("window-width") or 640
    height = $(this).data("window-height") or 320
    window.open $(this).attr("href"), "facebook_share", "height=" + height + ", width=" + width + ", toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, directories=no, status=no, top=200, left=200"

  $(".btn-embed").fancybox
    helpers:
      title: null

    width: 500
    height: 240
    autoSize: false

  $(".embed-code textarea").focus ->
    
    # Work around WebKit's little problem
    mouseUpHandler = ->
      
      # Prevent further mouseup intervention
      $this.off "mouseup", mouseUpHandler
      false
    $this = $(this)
    $this.select()
    window.setTimeout (->
      $this.select()
    ), 1
    $this.mouseup mouseUpHandler

  # Actiontips javascript
  $("#actiontip-edit").hide()
  $(".edit-video").hover (->
    $("#actiontip-edit").show(0)
  ), ->
    $("#actiontip-edit").hide(0)

  $("#actiontip-delete").hide()
  $(".delete-video").hover (->
    $("#actiontip-delete").show(0)
  ), ->
    $("#actiontip-delete").hide(0)

  $("#actiontip-twitter").hide()
  $(".btn-twitter").hover (->
    $("#actiontip-twitter").show(0)
  ), ->
    $("#actiontip-twitter").hide(0)

  $("#actiontip-facebook").hide()
  $(".btn-facebook").hover (->
    $("#actiontip-facebook").show(0)
  ), ->
    $("#actiontip-facebook").hide(0)

  $("#actiontip-linkedin").hide()
  $(".btn-linkedin").hover (->
    $("#actiontip-linkedin").show(0)
  ), ->
    $("#actiontip-linkedin").hide(0)

  $("#actiontip-embed").hide()
  $(".btn-embed").hover (->
    $("#actiontip-embed").show(0)
  ), ->
    $("#actiontip-embed").hide(0)

  # Sticky Navigation with jquery.sticky.js
  $(".navigation").sticky topSpacing: 0

