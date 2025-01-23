import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.inputTargets.forEach(input => {
      input.addEventListener("keydown", this.handleKeydown.bind(this));
    });
  }

  disconnect() {
    this.inputTargets.forEach(input => {
      input.removeEventListener("keydown", this.handleKeydown.bind(this));
    });
  }

  handleKeydown(event) {
    if (event.key === "-" || event.key === "e" || event.key === "E") {
      event.preventDefault();
    }
  }
}