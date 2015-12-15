var initListIndex = function () {
  var sseListImport = new EventSource('/imports/progress');

  sseListImport.addEventListener('message', function (e) {
    var data = JSON.parse(e.data),
        text = data.imported_lines + ' / ' + data.lines_count;

    $('.emails-count-' + data.list_id).text(text);
  });
};
