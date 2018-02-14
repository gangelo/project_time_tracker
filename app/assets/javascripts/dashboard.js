// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  function startTaskTimer() {
    if (window.$durationElement.length == 0) {
      return;
    }
    window.addEventListener("beforeunload", function(event) {
      clearInterval(window.taskTimerIntervalId);
    });
    window.taskTimerIntervalId = setInterval(incrementTaskTimer, 1000);
  }

  function incrementTaskTimer() {
    let seconds = parseInt(window.$durationElement.text());
    window.$durationElement.text(++seconds);
  }

  window.$durationElement  = $('.started');
  startTaskTimer();
})
