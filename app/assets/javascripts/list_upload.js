var initListUpload = function () {
  var listUpload     = $('.list-upload'),
      progressBar    = listUpload.find('.progress-bar'),
      inputContainer = listUpload.find('.fileinput-button'),
      inputLabel     = inputContainer.find('span'),
      input          = inputContainer.find('input');

  var formData = function (form) {
    var formFields     = form.serializeArray(),
        filteredFields = [];

    $.each(formFields, function (i, field) {
      var utf8      = field.name == 'utf8',
          authToken = field.name == 'authenticity_token';

      if (utf8 || authToken) filteredFields.push(field);
    });

    return filteredFields;
  };

  var refreshProgress = function (loaded, total) {
    var progress = parseInt(loaded / total * 100, 10) + '%';

    progressBar.css('width', progress).text(progress);
  };

  var uploadStart = function () {
    inputContainer.addClass('disabled');
    inputLabel.text('Enviando...');
  };

  var progressAll = function (e, data) {
    refreshProgress(data.loaded, data.total);
  };

  var uploadStop = function () {
    inputLabel.text('Envio Concluído');
  };

  input.fileupload({formData: formData, acceptFileTypes: /(\.|\/)(txt|csv)$/i})
    .bind('fileuploadstart', uploadStart)
    .bind('fileuploadprogressall', progressAll)
    .bind('fileuploadstop', uploadStop);
};
