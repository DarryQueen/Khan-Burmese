$(function() {
  $('#video-search input').keyup(function() {
    $.get($('#video-search').attr('action'), $('#video-search').serialize(), null, 'script');
    return false;
  });
  $('#video-search input').keyup();
  $('#search').focus();
});

function starClick(element) {
  wrapper = $(element.parentNode);
  wrapper.html('<i class="fa fa-spinner fa-pulse fa-starry fa-lg fa-fw"></i>');
}
