App.WidgetView = Ember.View.extend({
    didInsertElement: function () {
        window.Intercom('boot', {
            app_id: 'y20z33mu',
            email: App.get('clientEmail'),
            user_id: App.get('clientIntercomId'),
            created_at: App.get('clientIntercomCreatedAt'),
            widget: {
                activator: '#intercom-activator'
            }
        });
    }
});
