import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['modal','search','subject','mates']
  connect(){
    // document.addEventListener('autocomplete.change', function(e) {
    //   const { value, textValue } = e.detail
    //   location.assign(`/players/${value}`)
    // })
    console.log("pairing")
  }

  openModal(){
    this.modalTarget.style.display = 'block'
  }

  closeModal(){
    this.modalTarget.style.display = 'none'
  }

  search(){
    console.log("clicked on search")
    console.log(this.subjectTarget.value)
    let selected = this.matesTarget
    let arr = Array.from(selected.options).filter(option => option.selected).map(option => option.value);
    console.log(arr)
      // .filter(option => option.selected).map(option => option.value))
  }

}