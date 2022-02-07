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
    // console.log("got sidebar")
  }

  toggle(){
    const side = document.getElementById("mySidebar")
    const main = document.getElementById("myMain")
    // console.log(side)
    // console.log(main)
    if (side.style.display == 'none') {
      main.style.marginLeft = "22%"
      side.style.width = "20%";
      side.style.display = "block";


    }else{
      main.style.marginLeft = "0%"
      side.style.width = "0%";
      side.style.display = "none";

    }
    // console.log("toggle me")
  }
}
