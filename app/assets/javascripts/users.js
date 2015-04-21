$(function() {
  $('#leaderboard-buttons a').click(function(event) {
    var active_class = 'btn-primary'
    $('#leaderboard-buttons a').removeClass(active_class);
    $(this).addClass(active_class);
  })
});
