$(document).ready(function() {
    $('.vote-control').on('ajax:success', '.vote-up, .vote-down, .revoke-vote', function (e, data) {
        var object = $(this).parent('.vote-control[data-object-id="' + data.object + '"]');
        object.children('.object-vote-result').text(data.rating);

        object.children('.vote-control-link').toggleClass('hidden');
    });
});