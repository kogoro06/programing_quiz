function setInitialTagSelection() {
    const tagSelect = document.getElementById('tag-select');
    if (!tagSelect) return;
  
    const currentPath = window.location.pathname; 
    const currentTagId = currentPath.match(/\/tags\/(\d+)/)?.[1];
  
    if (currentTagId) {
      const selectedOption = [...tagSelect.options].find(opt => opt.value === `/tags/${currentTagId}`);
      if (selectedOption) {
        selectedOption.selected = true;
        const bgColor = selectedOption.getAttribute('data-color');
        updateTagSelectStyle(tagSelect, bgColor);
      }
    } else {
      const defaultOption = tagSelect.options[0];
      const bgColor = defaultOption.getAttribute('data-color');
      updateTagSelectStyle(tagSelect, bgColor);
    }
  }
  
  function updateTagSelectStyle(tagSelect, bgColor) {
    tagSelect.className = `w-1/4 h-12 text-3xl text-white font-bold text-center text-nowrap rounded-lg flex items-center justify-center ${bgColor}`;
  }
  
  function setupTagSelect() {
    const tagSelect = document.getElementById('tag-select');
    const quizContent = document.getElementById('quiz_content');
    if (!tagSelect || !quizContent) return;
  
    tagSelect.addEventListener('change', function () {
      const selectedOption = this.options[this.selectedIndex];
      const bgColor = selectedOption.getAttribute('data-color');
      updateTagSelectStyle(this, bgColor);
  
      const selectedValue = selectedOption.value;
  
      if (selectedValue.startsWith('/tags/')) {

        if (window.location.pathname !== selectedValue) {
          Turbo.visit(selectedValue, { action: "replace" });
        }
      } else {

        fetch(`/tags/${selectedValue}.json`, {
          headers: {
            "X-Requested-With": "XMLHttpRequest"
          }
        })
          .then(response => {
            if (!response.ok) {
              throw new Error('Network response was not ok');
            }
            return response.json();
          })
          .then(data => {
            quizContent.innerHTML = data.quizzes_html;
          })
          .catch(error => {
            console.error("Error fetching quiz content:", error);
          });
      }
    });
  }

  document.addEventListener("turbo:load", () => {
    setInitialTagSelection();
    setupTagSelect();
  });
  
  document.addEventListener("turbo:render", () => {
    setInitialTagSelection();
    setupTagSelect();
  });