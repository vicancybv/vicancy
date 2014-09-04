App.AddNewVideoController = Ember.ObjectController.extend({
    actions: {
        submit: function () {
            var c = this;
            Ember.$.post("/api/v1/client/videos/request", {
                "api_token": App.get('apiToken'),
                "client_token": App.get('clientToken'),
                "request": {
                    "link": $('#add_new_video_link').val(),
                    "comment": $('#add_new_video_comments').val()
                } }).done(function () {
                c.send('flashOk', I18n.t('add_new_video.flash_ok'));
            }).fail(function (xhr) {
                c.send('flashError', xhr.responseJSON.error_text);
            });
            this.send('closeModal');
        }
    }
});