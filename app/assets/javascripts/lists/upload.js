var initListUpload = function () {
  var modalContainer = $('#new-list'),
      uploadRequest  = null;

  var inputContainer = modalContainer.find('.fileinput-button'),
      inputLabel     = inputContainer.find('span'),
      input          = inputContainer.find('input');
      
  var progressBar  = modalContainer.find('.progress-bar'),
      cancelButton = modalContainer.find('.cancel');

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

  var uploadAdd = function (e, data) {
    uploadRequest = data.submit();
  };

  var uploadStart = function () {
    inputContainer.addClass('disabled');
    inputLabel.text('Enviando...')
  };

  var progressAll = function (e, data) {
    refreshProgress(progressBar, data.loaded, data.total);
  };

  var uploadStop = function () {
    inputLabel.text('Concluído');
    location.reload();
  };

  var resetModalState = function () {
    inputContainer.removeClass('disabled');
    inputLabel.text('Selecionar...')
    refreshProgress(progressBar, 0, 1);
  };

  input.fileupload({formData: formData, acceptFileTypes: /(\.|\/)(txt|csv)$/i})
    .bind('fileuploadadd',         uploadAdd)
    .bind('fileuploadstart',       uploadStart)
    .bind('fileuploadprogressall', progressAll)
    .bind('fileuploadstop',        uploadStop);

  modalContainer.on('hide.bs.modal', function (e) {
    if (uploadRequest) uploadRequest.abort();
  }).on('hidden.bs.modal', function (e) {
    resetModalState();
  });
};
