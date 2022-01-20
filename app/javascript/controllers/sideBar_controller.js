
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    // console.log("side bar")
  }
 
  dropdown(){
    console.log("dropdown click")
    const drop = event.target
    const sibl = drop.nextSibling
    console.log(sibl)
    if (sibl.className.indexOf("w3-show") == -1) {
      sibl.className += " w3-show";
      sibl.previousElementSibling.className += " w3-green";
    } else { 
      sibl.className = sibl.className.replace(" w3-show", "");
      sibl.previousElementSibling.className = 
      sibl.previousElementSibling.className.replace(" w3-green", "");
    }
  }

  accordian(){
    console.log("accordian click")
    const accord = event.target
    const sibl = accord.nextSibling
    console.log(sibl)
    if (sibl.className.indexOf("w3-show") == -1) {
      sibl.className += " w3-show";
      sibl.previousElementSibling.className += " w3-green";
    } else { 
      sibl.className = sibl.className.replace(" w3-show", "");
      sibl.previousElementSibling.className = 
      sibl.previousElementSibling.className.replace(" w3-green", "");
    }
  }

}
