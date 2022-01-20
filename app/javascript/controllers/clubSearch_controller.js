import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = ['modal']

  static get targets() {
    return [ "modal" ]
  }

  connect(){
    console.log( "club opended")

    document.addEventListener('autocomplete.change', function(e) {
      const { value, textValue } = e.detail
      location.assign(`/clubs/player?pid=${value}`)
    })

  }

  openModal(){
    this.modalTarget.style.display = 'block'
  }

  closeModal(){
    this.modalTarget.style.display = 'none'
  }

}