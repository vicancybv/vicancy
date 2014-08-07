App.ShareController = Ember.ObjectController.extend({
    actions: {
        twitter: function (url) {
            width = 640;
            height = 260;
            window.open(this.get('twitter_share'), '', "height=" + height + ", width=" + width + ", toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, directories=no, status=no, top=200, left=200");
            this.send('closeModal');
        },
        facebook: function (url) {
            width = 640;
            height = 320;
            window.open(this.get('facebook_share'), '', "height=" + height + ", width=" + width + ", toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, directories=no, status=no, top=200, left=200");
            this.send('closeModal');
        },
        linkedin: function (url) {
            width = 600;
            height = 320;
            window.open(this.get('linkedin_share'), '', "height=" + height + ", width=" + width + ", toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, directories=no, status=no, top=200, left=200");
            this.send('closeModal');
        }
    }
});
