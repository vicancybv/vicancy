$(document).ready(function() {

	var isVisible = false;
	var clickedAway = false;

	$('.customize').popover({
	        html: true,
	        trigger: 'manual'
	    }).click(function(e) {
	        $(this).popover('show');
	        clickedAway = false
	        isVisible = true
	        e.preventDefault()
	            $('.customize').bind('click',function() {
	                clickedAway = false
	                //alert('popover has been clicked!');
	            });
	    });

	$(document).click(function(e) {
	  if(isVisible && clickedAway)
	  {
	    $('.customize').popover('hide')
	    isVisible = clickedAway = false
	  }
	  else
	  {
	    clickedAway = true
	  }
	});
});
