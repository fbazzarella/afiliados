var initListImport = function () {
  var inputContainer = $('.choose.fileinput-button'),
      inputLabel     = inputContainer.find('span');

  var sseListImport = new EventSource('/lists/import-progress'),
      emailsCount   = $('.emails-count'),
      progressBar   = $('.import .progress-bar');

  sseListImport.addEventListener('message', function (e) {
    var data = JSON.parse(e.data);

    emailsCount.text(data.emails_count);
    refreshProgress(progressBar, data.imported_lines, data.lines_count);

    if (data.finished) {
      inputLabel.text('Concluído');
      sseListImport.close();
    };
  });
};
