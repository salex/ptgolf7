// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "options" , "submit"]

  connect() {
    console.log(this.submitTarget)
  }

  blind() {
    // console.log("clicked blind, set individual, only choice")
    this.optionsTargets[0].checked = true
  }

  checkOptions(){
    const all = this.optionsTargets
    var btn = event.target
    var ckd = false
    this.submitTarget.disabled = false
    for (var i = 0;  i < all.length; i++) {
      if(all[i].checked) {
        ckd = true
      }
    }
    if (!ckd) {
      event.preventDefault()
      alert("Your have not seleted a Team Makeup Option")
    }else{
      // btn.style.display = 'none'
      this.submitTarget.disabled = false

      return true
    }
  }
}
