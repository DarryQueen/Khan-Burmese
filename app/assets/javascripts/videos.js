$(function() {
  $('#video-search input').keyup(videoSearch);
  $('#status-filter input').change(videoSearch);
  $('#subject-filter').change(videoSearch);

  $('#video-search input').keyup();
  $('#search').focus();

  $('[data-toggle="tooltip"]').tooltip();

  // Tooltips for translations frame:
  $('#review-link').click(function() {
    $('#review').tooltip('show');
    setTimeout(function() { $('#review').tooltip('destroy'); }, 3000);
  });

  // Disable form submission advances:
  $('#video-search').bind('keypress', function(e) {
    if (e.keyCode == 13) {
      return false;
    }
  });
});

function starClick(element) {
  var wrapper = $(element.parentNode);
  wrapper.html('<i class="fa fa-spinner fa-pulse fa-lg fa-fw"></i>');
}

function videoSearch() {
  $('#video-results').removeClass().addClass('panel-empty');
  $('#video-results').html(" \
    <i class=\"fa fa-spinner fa-pulse fa-inline\"></i> \
    Searching, please wait... \
  ");
  $.get($('#video-search').attr('action'), $('#video-search').serialize(), null, 'script');
  return false;
}
