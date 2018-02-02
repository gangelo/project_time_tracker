// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  var logoutButtonSelector = '.btn-logout';

  $(logoutButtonSelector).each(function() {
    $(this).click(function(event) {
      event.preventDefault();
      showLogoutModal(this);
    });
  });

  function showLogoutModal(logout_button) {
    $('.modal').on('show.bs.modal', function (event) {
      var modal = $(this);
      modal.find('.modal-title').html('<span class="fa-2x">Leaving so soon?</i>');
      modal.find('.modal-header').addClass('app-highlight');
      modal.find('.modal-body').html("Are you sure you want to log out?");
      modal.find('.btn-ok').addClass('btn-special dark')
        .text("Yep, log me out!")
        .click(function() { $(logout_button).off('click'); $(logout_button).click(); });
      modal.find('.btn-cancel').addClass('btn-default').text('Cancel');
    });
    showModal();
  };

  function showModal() {
    $('.modal').modal().show();
  };
});
