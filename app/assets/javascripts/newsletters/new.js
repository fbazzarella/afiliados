var initNewsletterNew = function () {
  var modalContainer = $('#new-newsletter');

  modalContainer.on('hidden.bs.modal', function () {
    $(this).find('form')[0].reset();    
  });
};
