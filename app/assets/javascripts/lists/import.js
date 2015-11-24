var initListImport = function () {
  var inputContainer = $('.choose.fileinput-button'),
      inputLabel     = inputContainer.find('span');

  var sseListImport   = new EventSource('/lists/import-progress'),
      totalEmailCount = $('.total-email-count'),
      progressBar     = $('.import .progress-bar');

  sseListImport.addEventListener('message', function (e) {
    var data = JSON.parse(e.data);

    totalEmailCount.text(parseInt(totalEmailCount.text()) + data.email_increased);

    refreshProgress(progressBar, data.imported_lines, data.total_lines);

    if (data.imported_lines == data.total_lines) {
      inputLabel.text('Concluído');
      
      sseListImport.close();
    };
  });
};
