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
    var progress = parsePerc(loaded, total);

    if (progress > 0 && progress < 100) {
      inputLabel.text(progress + '%');
    } else if (progress == 100) {
      inputLabel.text('Finalizando...');
    } else {
      inputLabel.text('Selecione...');
    };

    progressBar.css('width', progress + '%');
  };

  var uploadStart = function () {
    inputContainer.addClass('disabled');
  };

  var progressAll = function (e, data) {
    refreshProgress(data.loaded, data.total);
  };

  var uploadStop = function () {
    refreshProgress(0, 1);
    inputContainer.removeClass('disabled');
  };

  input.fileupload({formData: formData, acceptFileTypes: /(\.|\/)(txt|csv)$/i})
    .bind('fileuploadstart',       uploadStart)
    .bind('fileuploadprogressall', progressAll)
    .bind('fileuploadstop',        uploadStop);
};
