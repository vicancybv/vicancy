App.ModalView = Ember.View.extend({
    didInsertElement: function() {
        console.log('didInsertElement');
//        $('.wg-container').foggy({
//            blurRadius: 24
//        });
    },
    willDestroyElement: function() {
//        $('.wg-container').foggy(false);
    }
});
