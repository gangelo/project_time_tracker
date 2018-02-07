$(function() {
  // Wires up click events for all dropdown search options.
  $("#search_options > li .search-item").each(function(index) {
    $(this).click(function(e) {
      setSearchOption(this);
    });
  });

  // Submits the form when the search button is clicked.
  $("#search_button").click(function(e) {
    $("#search_criteria_form").submit();
    e.preventDefault();
  });

  function setInitialSearchOption() {
    let optionId = $("#search_option").val();
    let $optionElement = $("#" + optionId);
    setSearchLeftText($optionElement);
    setSearchPlaceholder($optionElement);
  };

  function setSearchLeftText($optionElement) {
    let optionText = $optionElement.text();
    $("#selected_search_option").text(optionText);
  };

  function setSearchPlaceholder($optionElement) {
    let placeholder = $optionElement.data("placeholder");
    $("#search_string").attr("placeholder", placeholder);
  };

  function setHiddenSearchOptionId($optionElement) {
    let id = $optionElement.attr("id");
    $("#search_option").val(id);
  };

  function setSearchOption(searchOptionDOMElement) {
    let $searchOptionElement = $(searchOptionDOMElement);
    setSearchLeftText($searchOptionElement);
    setSearchPlaceholder($searchOptionElement);
    setHiddenSearchOptionId($searchOptionElement);
    // Hidden
    //let id = $searchOptionElement.attr("id");
    //$("#search_option").val(id);
  };

  setInitialSearchOption();
});
