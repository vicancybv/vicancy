App = Ember.Application.create({
    apiToken: null,
    clientId: null,
    clientName: null,
    clientEmail: null,
    clientToken: null,
    clientIntercomId: null,
    clientIntercomCreatedAt: null,
    language: null,
    videos: null
});

Ember.Handlebars.registerHelper('i18n', function(property, options) {
    var params = options.hash,
        self = this;

    // Support variable interpolation for our string
    Object.keys(params).forEach(function (key) {
        params[key] = Em.Handlebars.get(self, params[key], options);
    });

    if (property.match(/_html$/)) {
        return new Ember.Handlebars.SafeString(I18n.t(property, params));
    } else {
        return I18n.t(property, params);
    }
});
