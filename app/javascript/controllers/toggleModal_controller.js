import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['modal']

  connect(){
    console.log("modal")
  }

  openModal(){
    console.log('click')
    this.modalTarget.style.display = 'block'
  }

  closeModal(){
    this.modalTarget.style.display = 'none'
  }

}