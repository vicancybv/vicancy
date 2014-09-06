App.LandingController = Ember.ObjectController.extend({
    actions: {
        scrollTryNow: function() {
            $('html,body').animate({scrollTop: $('#try_now').offset().top});
        },
        submit: function() {
            var c = this;
            $('#submit_try_now_form .form-group').removeClass('has-error')
            var email = $('#submit_try_now_email').val();
            var url = $('#submit_try_now_url').val();
            var comments = $('#submit_try_now_comments').val()+"";
            comments = email+"\n"+comments;
            if ((email) == false) {
                $('#submit_try_now_email').addClass('animated');
                $('#submit_try_now_email').addClass('shake');
                $('#submit_try_now_email').parent().addClass('has-error');
            }
            if ((url) == false) {
                $('#submit_try_now_url').addClass('animated');
                $('#submit_try_now_url').addClass('shake');
                $('#submit_try_now_url').parent().addClass('has-error');
            }
            if (((url)&&(email)) == false) {
                window.setTimeout(function(){
                    $('#submit_try_now_form input').removeClass('animated')
                    $('#submit_try_now_form input').removeClass('shake')
                },1000);
                return false;
            }
            Ember.$.post("/api/v1/client/videos/request", {
                "api_token": App.get('apiToken'),
                "client_token": App.get('clientToken'),
                "request": {
                    "link": url,
                    "comment": comments
                } }).done(function () {
//                c.send('flashOk', I18n.t('add_new_video.flash_ok'));
                c.transitionTo('/request_processing');
            }).fail(function (xhr) {
                c.send('flashError', xhr.responseJSON.error_text);
                $('#submit_try_now_spinner').css('display', 'none');
                $('#submit_try_now_form textarea').attr('disabled',null);
                $('#submit_try_now_form input').attr('disabled',null);
            });
            $('#submit_try_now_spinner').css('display', 'inline');
            $('#submit_try_now_form textarea').attr('disabled','disabled');
            $('#submit_try_now_form input').attr('disabled','disabled');
        }
    }
});
