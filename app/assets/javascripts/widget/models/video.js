App.Video = DS.Model.extend({
    company: DS.attr('string'),
    job_title: DS.attr('string'),
    youtube_id: DS.attr('string'),
    vimeo_id: DS.attr('string'),
    vimeo_url: function() {
        return '//player.vimeo.com/video/'+this.get('vimeo_id');
    }.property('vimeo_id'),
    youtube_preview_url: function() {
        return '//img.youtube.com/vi/'+this.get('youtube_id')+'/maxresdefault.jpg';
    }.property('youtube_id')

});

App.Video.FIXTURES = [
    {
        id: 1,
        title: 'Manager',
        location: 'Amsterdam, NL',
        isSelected: true
    },
    {
        id: 2,
        title: 'Software Engineer',
        location: 'Amsterdam, NL',
        isSelected: false
    },
    {
        id: 3,
        title: 'Senior Manager',
        location: 'Amsterdam, NL',
        isSelected: false
    }
];