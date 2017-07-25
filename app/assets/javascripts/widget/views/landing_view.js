App.LandingView = Ember.View.extend({
    didInsertElement: function () {
        $(document).ready(function(){
            window.location="https://www.vicancy.com/widget-landing-page";
            // $('#landing_page').css('display','block');
        });
        $('#submit_try_now_email').val(App.get('clientEmail'));
        $('#submit_try_now_form input').change(function () {
            $(this).parent().removeClass('has-error');
        });
    }
});
