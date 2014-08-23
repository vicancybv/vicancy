App.VideosController = Ember.ArrayController.extend({
    results: function(){
        var searchTerm = this.get('searchTerm'),
            results    = this.get('videos');

        if (!Ember.empty(searchTerm)) {
            results = results.filter(function (video) {
                var pass = false;
                if (pass == false) pass = video.get('job_title').toLowerCase().indexOf(searchTerm.toLowerCase()) > -1;
                if (pass == false) pass = video.get('company').toLowerCase().indexOf(searchTerm.toLowerCase()) > -1;
                return pass;
            });
            this.set('searchCount', results.length);
        } else {
            this.set('searchCount', null);
        }
        return results;
    }.property('searchTerm'),

    noSearchResults: function() {
        return (this.get('searchCount') == 0);
    }.property('searchCount')
});