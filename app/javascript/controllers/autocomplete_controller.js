import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.resultsTarget.style.display = 'none';
  }

  search(event) {
    const query = event.target.value.trim();
    
    if (query.length < 2) {
      this.hideResults();
      return;
    }

    fetch(`/quiz_posts/autocomplete?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.updateResults(data);
      });
  }

  updateResults(data) {
    if (!data.length) {
      this.hideResults();
      return;
    }

    this.resultsTarget.innerHTML = data.map(item => `
      <li class="px-4 py-2 hover:bg-gray-100 cursor-pointer" 
          data-action="click->autocomplete#select"
          data-id="${item.id}" 
          data-title="${item.title}">
        ${item.title}
      </li>
    `).join('');

    this.showResults();
  }

  select(event) {
    const title = event.target.dataset.title;
    this.inputTarget.value = title;
    this.hideResults();
  }

  showResults() {
    this.resultsTarget.style.display = 'block';
  }

  hideResults() {
    this.resultsTarget.style.display = 'none';
    this.resultsTarget.innerHTML = '';
  }
}