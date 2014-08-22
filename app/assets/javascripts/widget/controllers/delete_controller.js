App.DeleteController = Ember.ObjectController.extend({
    actions: {
        submit: function () {
            Ember.$.post("/api/v1/client/videos/"+this.get('id')+"/delete", {
                "api_token": App.get('apiToken'),
                "client_token": App.get('clientToken')
            });
            this.send('closeModal');
        }
    }
});
