document.addEventListener("turbo:load", function () {
  const searchButtonList = document.querySelectorAll(".search-toggle-button");
  const searchFormContainer = document.getElementById("search-form-container");

  if (searchButtonList.length > 0 && searchFormContainer) {
    searchButtonList.forEach(button => {
      button.addEventListener("click", function (event) {
        event.preventDefault();
        searchFormContainer.classList.toggle("hidden");
      });
    });
  }
});