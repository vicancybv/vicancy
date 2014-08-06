App.VideoController = Ember.ObjectController.extend({
    actions: {
        share: function() {
            console.log('share!');
            $.sidr('open', 'sidr');
        }
    }
});