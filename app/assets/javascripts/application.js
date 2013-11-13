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
  $('.delete-video').bind('ajax:success', function() {
    $(this).children('i')
    		.removeClass('fa-trash-o')
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
  $('.edit-video, .new-video').fancybox({
      padding: 0,
      fitToView: false,
      width: '90%',
      height: '90%',
      helpers : {
            title: null
          }
    });
});
