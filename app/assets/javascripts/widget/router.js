App.Router.map(function () {
    this.resource('widget', { path: '/' }, function () {
        this.resource('videos', function () {
            this.resource('video', { path: ':video_id' });
        });
    });
    this.resource('landing', { path: '/landing' });
    this.resource('request_processing', { path: '/request_processing' });
});

App.Flashy = Ember.Mixin.create({
    actions: {
        flashAlert: function (type, message) {
            var obj = $("#alert-" + type);
            obj.css('display', 'none').removeClass('animated').removeClass('fadeOutDown');
            $("#alert-" + type + " span.alert-text").text(message);
            obj.addClass('fadeInDown').addClass('animated').css('display', 'block');
            obj.click(function () {
                obj.removeClass('animated').removeClass('fadeInDown').addClass('fadeOutDown').addClass('animated');
            });
            var timeout = 3000;
            if (type == 'danger') timeout = 6000;
            window.setTimeout(function () {
                obj.removeClass('animated').removeClass('fadeInDown').addClass('fadeOutDown').addClass('animated');
            }, timeout);
        },
        flashOk: function (message) {
            this.send('flashAlert', 'success', message);
        },
        flashError: function (message) {
            this.send('flashAlert', 'danger', message);
        }
    }
});

App.WidgetRoute = Ember.Route.extend(App.Flashy, {
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
        if (App.get('clientToken') == null) App.set('clientToken', model.client_token);
        if (App.get('clientIntercomId') == null) App.set('clientIntercomId', model.intercom_id);
        if (App.get('clientIntercomCreatedAt') == null) App.set('clientIntercomCreatedAt', model.intercom_created_at);
        I18n.locale = App.get('language');
        transition.send('initIntercom');
        this.transitionTo('videos');
    },
    actions: {
        openModal: function (modalName, model) {
            this.controllerFor(modalName).set('model', model);
            this.render(modalName, {
                into: 'application',
                outlet: 'modal',
                view: 'modal'
            });
        },
        closeModal: function () {
            return this.disconnectOutlet({
                outlet: 'modal',
                parentView: 'application'
            });
        },
        initIntercom: function () {
//            window.Intercom('boot', {
//                app_id: 'y20z33mu',
//                email: App.get('clientEmail'),
//                user_id: App.get('clientIntercomId'),
//                created_at: App.get('clientIntercomCreatedAt'),
//                widget: {
//                    activator: '#intercom-activator'
//                }
//            });
        }

    }
});

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
                App.set('requests', data.requests);
                return app.store.all('video');
            });
            App.set('videos', videos);
        }
        return App.get('videos');
    },
    afterModel: function (videos, transition) {
        if (videos.get('length') > 0) {
            this.transitionTo('video', videos.get('firstObject'));
        } else {
            if (App.get('requests')) {
                this.transitionTo('request_processing');
            } else {
                this.transitionTo('landing');
            }
        }
    },
    setupController: function (controller, videos) {
        controller.set('videos', videos);
    }
});

App.VideoAdapter = DS.RESTAdapter.extend({
    namespace: 'api/v1/client'
});


App.VideoRoute = Ember.Route.extend({
});

App.LandingRoute = Ember.Route.extend(App.Flashy, {
});