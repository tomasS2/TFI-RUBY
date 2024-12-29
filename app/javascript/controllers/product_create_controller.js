import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["stock", "sizesContainer"];
  connect() {
    this.toggleSizesVisibility();
    //console.log("me vinculééééée")
  }
  toggleSizesVisibility() {
    if (this.stockTarget.value && this.stockTarget.value >= 0) {
      this.sizesContainerTarget.style.display = "none"; 
    } else {
      this.sizesContainerTarget.style.display = "block"; 
    }
  }
  updateStock() {
    this.toggleSizesVisibility();
  }
}
