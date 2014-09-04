App.DeleteController = Ember.ObjectController.extend({
    actions: {
        submit: function () {
            var c = this;
            Ember.$.post("/api/v1/client/videos/"+this.get('id')+"/delete", {
                "api_token": App.get('apiToken'),
                "client_token": App.get('clientToken')
            }).done(function () {
                c.send('flashOk', I18n.t('video.delete.flash_ok') );
            }).fail(function (xhr) {
                c.send('flashError',xhr.responseJSON.error_text);
            });
            this.send('closeModal');
        }
    }
});
