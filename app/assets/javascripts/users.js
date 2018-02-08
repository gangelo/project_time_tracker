$(function() {
  // Wires up click events for all dropdown search options.
  $("#search_options > li .search-item").each(function(index) {
    $(this).click(function(e) {
      clearSearchString();
      setSearchOption(this);
      enableSearchString(this);
      if (isSearchAll()) {
        submitForm();
      }
    });
  });

  // Submits the form when the search button is clicked.
  $("#search_button").click(function(e) {
    submitForm();
    e.preventDefault();
  });

  function submitForm() {
    $("#search_criteria_form").submit();
  };

  function isSearchAll() {
    let optionId = $("#search_option").val();
    let $optionElement = $(document.getElementById(optionId));
    let id = $optionElement.attr("id");
    return id == "show_all";
  };

  function enableSearchString(searchOptionDOMElement) {
    $("#search_string").prop("disabled", isSearchAll());
  };

  function setInitialSearchOption() {
    let optionId = $("#search_option").val();
    let $optionElement = $("#" + optionId);
    setSearchLeftText($optionElement);
    setSearchPlaceholder($optionElement);
    enableSearchString(document.getElementById(optionId));
  };

  function setSearchOption(searchOptionDOMElement) {
    let $searchOptionElement = $(searchOptionDOMElement);
    setSearchLeftText($searchOptionElement);
    setSearchPlaceholder($searchOptionElement);
    setHiddenSearchOptionId($searchOptionElement);
  };

  function setSearchLeftText($optionElement) {
    let optionText = $optionElement.text();
    $("#selected_search_option").text(optionText);
  };

  function setSearchPlaceholder($optionElement) {
    let placeholder = $optionElement.data("placeholder");
    $("#search_string").attr("placeholder", placeholder);
  };

  function clearSearchString() {
    $("#search_string").val("");
  };

  function setHiddenSearchOptionId($optionElement) {
    let id = $optionElement.attr("id");
    $("#search_option").val(id);
  };

  setInitialSearchOption();
});
