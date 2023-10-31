import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["menu", "toggler"]

  connect(){
    // console.log("got a toggler")
    // console.log(this.hasTogglerTarget)
    // console.log(this.hasPaysTarget)
  }

  toggleMenu() {
    // Optional toggle fa-toggle-on/off
    if (this.hasTogglerTarget){
      let classes = this.togglerTarget.classList
      if (classes.contains("fa-toggle-on") || classes.contains("fa-toggle-off") ) {
        if (classes.contains("fa-toggle-on")){
          this.togglerTarget.classList.remove("fa-toggle-on")
          this.togglerTarget.classList.add("fa-toggle-off")
        }else{
          this.togglerTarget.classList.remove("fa-toggle-off")
          this.togglerTarget.classList.add("fa-toggle-on")
        }
      }
    }

    this.menuTarget.classList.toggle('hidden');
  }

  // togglePays(){
  //   var game_id = this.game_idTarget.value
  //   var pays = this.paysTarget.value

  //   location.assign(`/games/scheduled/${game_id}/update_pays?pays=${pays}`)

  // }
}
