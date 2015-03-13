$(function() {
  $('#video-search input').keyup(function() {
    $.get($('#video-search').attr('action'), $('#video-search').serialize(), null, 'script');
    return false;
  });
});
