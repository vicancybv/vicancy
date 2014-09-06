App.LandingView = Ember.View.extend({
    didInsertElement: function () {
        $('#submit_try_now_email').val(App.get('clientEmail'));
        $('#submit_try_now_form input').change(function () {
            $(this).parent().removeClass('has-error');
        });
    }
});
