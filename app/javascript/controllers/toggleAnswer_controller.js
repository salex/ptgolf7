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
  static targets = [  ]

  connect() {
    console.log("got question ")
  }

  toggle(){
    let answer = event.target.children[0]
    console.log(answer)
    if (answer.classList.contains('w3-hide')) {
      answer.classList.remove('w3-hide')
      answer.classList.add('w3-show')

    }else{
      answer.classList.remove('w3-show')
      answer.classList.add('w3-hide')

    }
  }

}
