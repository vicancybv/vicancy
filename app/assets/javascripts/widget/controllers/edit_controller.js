App.EditController = Ember.ObjectController.extend({
    actions: {
        submit: function () {
            Ember.$.post("/api/v1/client/videos/"+this.get('id')+"/edit", {
                "api_token": App.get('apiToken'),
                "client_token": App.get('clientToken'),
                "edit": {
                    "comments": $('#edit_video_comments').val()
                } });
            this.send('closeModal');
        }
    }
});
