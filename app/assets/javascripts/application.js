// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


// I need a way to close these when clicked outside of them. Maybe base it off events.
$(document).on('click touch', '.dropdown', function() {
        if($('.dropdown').is(":visible")) {
            $('.dropdown').not(this).children('ul').hide();
        }
        $(this).children('ul').toggle();
});

$(document).click(function(event) { 
    if(!$(event.target).closest('.dropdown').length &&
       !$(event.target).is('.dropdown')) {
        if($('.dropdown').is(":visible")) {
            $('.dropdown').children('ul').hide();
        }
    }        
})