// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.fancybox
//= require_tree .

jQuery(function() {
  $("a[rel~=popover], .has-popover").popover();
  $("a[rel~=tooltip], .has-tooltip").tooltip();
  $('.delete-video').bind('ajax:beforeSend', function() {
    $(this).children('i')
      .removeClass('fa-trash-o')
      .addClass('fa-spinner fa-spin fa-lg');
  });
  $('.delete-video').bind('ajax:success', function() {
    $(this).children('i')
    		.removeClass('fa-trash-o fa-spinner fa-spin fa-lg')
    		.addClass('fa-check');
   	$(this).children('span')
    		.html('Requested');
  });
});
$(document).ready(function() {
	$('.preview-video').fancybox({
    padding: 0,
    width       : 800,
    height      : 450,
    aspectRatio : true,
    scrolling   : 'no',
    helpers : {
          media : {},
          title: null
        }
  });
  $('.new-video').fancybox({
      padding: 0,
      width: '90%',
      height: '100%',
      autoSize: false,
      helpers : {
            title: null
          }
    });
  $('.edit-video').fancybox({
      autoSize: true,
      maxWidth: 600,
      helpers : {
            title: null
          }
    });

  $('.btn-share').click(function(e) {
    e.preventDefault();
    width = $(this).data('window-width') || 640;
    height = $(this).data('window-height') || 320;
    window.open($(this).attr('href'), 'facebook_share', 'height=' + height + ', width=' + width + ', toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, directories=no, status=no, top=200, left=200');
  });
  $('.btn-embed').fancybox({
    helpers: { title: null },
    width: 500,
    height: 240,
    autoSize: false
  });
  $('.embed-code textarea').focus(function() {
    var $this = $(this);

    $this.select();

    window.setTimeout(function() {
        $this.select();
    }, 1);

    // Work around WebKit's little problem
    function mouseUpHandler() {
        // Prevent further mouseup intervention
        $this.off("mouseup", mouseUpHandler);
        return false;
    }

    $this.mouseup(mouseUpHandler);
  });

});
