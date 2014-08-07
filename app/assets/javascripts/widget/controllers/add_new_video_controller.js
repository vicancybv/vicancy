App.AddNewVideoController = Ember.ObjectController.extend({
    actions: {
        submit: function () {
            Ember.$.post("/api/v1/client/videos/request", {
                "api_token": App.get('apiToken'),
                "client_token": App.get('clientToken'),
                "request": {
                    "link": $('#add_new_video_link').val(),
                    "comment": $('#add_new_video_comments').val()
                } });
            this.send('closeModal');
        }
    }
});