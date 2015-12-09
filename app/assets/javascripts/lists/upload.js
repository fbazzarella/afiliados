var initListUpload = function () {
  var inputContainer = $('.choose.fileinput-button'),
      inputLabel     = inputContainer.find('span'),
      input          = inputContainer.find('input');

  var progressBar = $('.upload .progress-bar');

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

  var uploadStart = function () {
    inputContainer.addClass('disabled');
    inputLabel.text('Aguarde a Importação...');

    initListImport();
  };

  var progressAll = function (e, data) {
    refreshProgress(progressBar, data.loaded, data.total);
  };

  input.fileupload({formData: formData, acceptFileTypes: /(\.|\/)(txt|csv)$/i})
    .bind('fileuploadstart',       uploadStart)
    .bind('fileuploadprogressall', progressAll);
};
