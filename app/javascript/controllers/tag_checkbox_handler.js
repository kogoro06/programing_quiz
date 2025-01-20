document.addEventListener("turbo:load", () => {
    const tagLabels = document.querySelectorAll(".tag-label");
    const tagCheckboxes = document.querySelectorAll(".tag-checkbox");
  
    tagLabels.forEach((label, index) => {
      const checkbox = tagCheckboxes[index];
      const initialColor = label.getAttribute("data-color");
  
      // 初期状態を反映
      if (checkbox.checked) {
        label.classList.add("bg-yellow-400", "ring-4", "ring-yellow-500", "shadow-md", "shadow-yellow-300");
        label.classList.remove(initialColor);
      }
  
      // クリックイベントで選択状態を切り替え
      label.addEventListener("click", () => {
        const isErrorTag = checkbox.value === "6"; // エラータグのIDが "6" と仮定
        const otherSelectedTags = Array.from(tagCheckboxes).filter((cb) => cb.checked && cb !== checkbox);
  
        if (!checkbox.checked && !isErrorTag && 
            otherSelectedTags.some(tag => tag.value !== "6" && tag.checked)) {
          alert("エラータグ以外は同時に選択できません。");
          return;
        }
  
        // 現在のタグの選択状態を切り替え
        checkbox.checked = !checkbox.checked;
  
        if (checkbox.checked) {
          label.classList.add("bg-yellow-400", "ring-4", "ring-yellow-500", "shadow-md", "shadow-yellow-300");
          label.classList.remove(initialColor);
        } else {
          label.classList.remove("bg-yellow-400", "ring-4", "ring-yellow-500", "shadow-md", "shadow-yellow-300");
          label.classList.add(initialColor);
        }
      });
    });
  });
  