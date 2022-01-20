import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    // console.log('Hello, doubleClick!')
  }

  disable(){
    const btn = event.target
    btn.style.display = 'none'
  }
}
