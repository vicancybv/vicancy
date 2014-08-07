App.Router.map(function () {
    this.resource('widget', { path: '/' }, function () {
        this.resource('videos', function () {
            this.resource('video', { path: ':video_id' });
        });
    });
});

App.WidgetRoute = Ember.Route.extend({
    queryParams: ['api_token', 'client_id', 'client_name', 'client_email', 'language'],
    model: function (params) {
        if (App.get('apiToken') == null) App.set('apiToken', params.queryParams.api_token);
        if (App.get('clientId') == null) App.set('clientId', params.queryParams.client_id);
        if (App.get('clientName') == null) App.set('clientName', params.queryParams.client_name);
        if (App.get('clientEmail') == null) App.set('clientEmail', params.queryParams.client_email);
        if (App.get('language') == null) App.set('language', params.queryParams.language);

        if (App.get('clientToken') == null) {
            return Ember.$.post("/api/v1/client/auth", { "api_token": App.get('apiToken'),
                "client": {
                    "id": App.get('clientId'),
                    "name": App.get('clientName'),
                    "email": App.get('clientEmail')
                } });
        }
    },
    afterModel: function (model, transition) {
        if (App.get('clientToken') == null) {
            App.set('clientToken', model.client_token);
        }
        I18n.locale = App.get('language');
        this.transitionTo('videos');
    },
    actions: {
        openModal: function(modalName, model) {
            this.controllerFor(modalName).set('model', model);
            this.render(modalName, {
                into: 'application',
                outlet: 'modal',
                view: 'modal'
            });
        },
        closeModal: function() {
            return this.disconnectOutlet({
                outlet: 'modal',
                parentView: 'application'
            });
        }
    }
});
//
//App.ApplicationRoute = Ember.Route.extend({
//    actions: {
//        openModal: function(modalName, model) {
//            this.controllerFor(modalName).set('model', model);
//            return this.render(modalName, {
//                into: 'application',
//                outlet: 'modal'
//            });
//        },
//
//        closeModal: function() {
//            return this.disconnectOutlet({
//                outlet: 'modal',
//                parentView: 'application'
//            });
//        }
//    }
//});

App.VideosRoute = Ember.Route.extend({
    model: function () {
        var app = this;
        if (App.get('videos') == null) {
            var videos = Ember.$.getJSON("/api/v1/client/videos", { "api_token": App.get('apiToken'), client_token: App.get('clientToken')}).then(function (data) {
                for (var i = 0; i < data.videos.length; i++) {
                    app.store.push('video', data.videos[i]);
                }
                return app.store.all('video');
            });
            App.set('videos',videos);
        }
        return App.get('videos');
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