// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  var deleteButtonSelector = '.btn-danger';

  $(deleteButtonSelector).each(function() {
    $(this).click(function(event) {
      //event.preventDefault();
      showDeleteModal(this);
      return false;
    });
  });

  function showDeleteModal(delete_button) {
    let dialogTitle = $(delete_button).data('dialog-title');
    let userEmail = $(delete_button).data('user-email');
    $('.modal').on('show.bs.modal', function (event) {
      var modal = $(this);
      modal.find('.modal-title').html('<span class="fa-2x">' + dialogTitle + '</i>');
      modal.find('.modal-header').addClass('app-highlight');
      modal.find('.modal-body').html("Are you sure you want to delete user " + userEmail + "?");
      modal.find('.btn-ok').addClass('btn-special dark')
        .text("Yes, delete it!")
        .click(function() { $(delete_button).off('click'); $(delete_button).click(); });
      modal.find('.btn-cancel').addClass('btn-default').text('Cancel');
    });
    showModal();
  };

  function showModal() {
    $('.modal').modal().show();
  };
});
