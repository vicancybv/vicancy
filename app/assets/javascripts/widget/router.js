App.Router.map(function () {
    this.resource('widget', { path: '/' }, function () {
        this.resource('videos', function () {
            this.resource('video', { path: ':video_id' });
        });
    });
});

App.WidgetRoute = Ember.Route.extend({
    model: function () {
        if (App.get('clientToken') == null) {
            return Ember.$.post("/api/v1/client/auth", { "api_token": App.get('apiToken'),
                "client": {
                    "id": "1111",
                    "name": "Client Name",
                    "email": "client@example.com"
                } });
        }
    },
    afterModel: function (model, transition) {
        if (App.get('clientToken') == null) {
            App.set('clientToken', model.client_token);
        }
        this.transitionTo('videos');
    }
});

App.VideosRoute = Ember.Route.extend({
    model: function () {
        var app = this;
        return Ember.$.getJSON("/api/v1/client/videos", { "api_token": App.get('apiToken'), client_token: App.get('clientToken')}).then(function (data) {
            for (var i = 0; i < data.videos.length; i++) {
                app.store.push('video', data.videos[i]);
            }
            return app.store.all('video');
        });
    },
    afterModel: function (videos, transition) {
        if (videos.get('length') > 0) {
            this.transitionTo('video', videos.get('firstObject'));
        }
    }
});

App.VideoAdapter = DS.RESTAdapter.extend({
    namespace: 'api/v1/client'
});


App.VideoRoute = Ember.Route.extend({
//    model: function (params) {
//        //return this.store.all('video', params.video_id);
//    }
});