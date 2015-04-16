$(function() {
  $('#video-search input').keyup(videoSearch);
  $('#status-filter input').change(videoSearch);

  $('#video-search input').keyup();
  $('#search').focus();

  $('[data-toggle="tooltip"]').tooltip();

  // Disable form submission advances:
  $('#video-search').bind('keypress', function(e) {
    if (e.keyCode == 13) {
      return false;
    }
  });
  $('#search').bind('blur', function(e) {
    this.focus();
  });
});

function starClick(element) {
  var wrapper = $(element.parentNode);
  wrapper.html('<i class="fa fa-spinner fa-pulse fa-lg fa-fw"></i>');
}

function videoSearch() {
  $.get($('#video-search').attr('action'), $('#video-search').serialize(), null, 'script');
  return false;
}
