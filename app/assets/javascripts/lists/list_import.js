var initListImport = function () {
  var sseListImport = new EventSource('/lists/import-progress');

  sseListImport.addEventListener('message', function (e) {
    console.log(JSON.parse(e.data)); // Só falta isso!
  });
};
