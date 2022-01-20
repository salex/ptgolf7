// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "answer",'ask']

  connect() {
    console.log('asking for answer')
  }

  answered(){
    console.log('clicked on answer')
    let ask = this.askTarget.innerHTML
    let ans = event.target.innerHTML
    this.answerTarget.value = `${ans}|${ask}`
  }
}
