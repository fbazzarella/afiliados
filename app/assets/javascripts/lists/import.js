var initListImport = function () {
  var sseListImport = new EventSource('/lists/import-progress'),
      listImport    = $('.list-import'),
      progressBar   = listImport.find('.progress-bar'),
      inputLabel    = listImport.find('span');

  var refreshProgress = function (imported, total) {
    var progress = parsePerc(imported, total);

    if (progress > 0 && progress < 100) {
      inputLabel.text(progress + '%');
    } else if (progress == 100) {
      inputLabel.text('Concluído');
    };

    progressBar.css('width', progress + '%');
  };

  sseListImport.addEventListener('message', function (e) {
    var data = JSON.parse(e.data);

    refreshProgress(data.imported_lines, data.total_lines);
  });
};
