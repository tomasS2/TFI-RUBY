import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["stock", "sizesContainer", "sizeStock"];

  connect() {
    this.toggleSizesVisibility();
    this.preventNegativeSignOnKeydown();
  }

  toggleSizesVisibility() {
    if (this.stockTarget.value && this.stockTarget.value >= 0) {
      this.sizesContainerTarget.style.display = "none"; 
    } else {
      this.sizesContainerTarget.style.display = "block"; 
    }
  }

  updateStock(event) {
    this.toggleSizesVisibility();
  }

  preventNegativeSignOnKeydown() {
    this.stockTarget.addEventListener("keydown", (event) => {
      if (event.key === "-" || event.key === "e" || event.key === "E") {
        event.preventDefault();  
      }
    });

    this.sizeStockTargets.forEach((sizeStock) => {
      sizeStock.addEventListener("keydown", (event) => {
        if (event.key === "-" || event.key === "e" || event.key === "E") {
          event.preventDefault();
        }
      });
    });
  }
}
