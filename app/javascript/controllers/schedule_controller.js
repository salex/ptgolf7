
import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = [ 'added',"scheduled", "players","group","pot","currentPlayers",'update','updatep','form','formbtn' ]

  connect() {
    this.preferences = JSON.parse(this.groupTarget.dataset.preferences)
    this.setPlayers()
  }

  addPlayer(){
    var node = event.target
    var sched = document.getElementById('schedule')
    var clone = node.cloneNode(true)
    clone.dataset.action = "click->schedule#removePlayer"
    clone.dataset.scheduleTarget = "scheduled"
    clone.classList.add('btn-sqr-green')

    clone.id += 'R'
    sched.appendChild(clone)
    node.style.display = 'none'
    this.setPlayers()
  } 

  removePlayer(){
    var node = event.target
    var pid = node.id.replace('R','')
    var sched = document.getElementById(pid)
    sched.style.display = 'block'
    node.parentNode.removeChild(node)
    this.setPlayers()
  }

  submit(){

    var new_players = document.getElementById('new_players')
    var add_players = this.scheduledTargets
    var btn =  event.target

    for (var i = 0;  i < add_players.length; i++) {
      const pid = add_players[i].dataset.playerid
      var inputtag = document.createElement('input')
      inputtag.type = "hidden"
      inputtag.name = "add_players[]"
      inputtag.value = pid
      new_players.appendChild(inputtag)
    }
    // Rails.fire(this.formTarget,'submit')
    Turbo.navigator.submitForm(this.formTarget)
    btn.style.display = 'none'



  }
  update_player(){
    // player delete or change tee
    // let curr_players = this.currentPlayersTargets.length

    this.updatepTarget.style.display = 'block'
    // if (this.hasFormbtnTarget) {
    //   this.formbtnTarget.style.display = 'none'
    // }
    // if (this.hasFormbtnTarget && curr_players > 0) {
    //   this.formbtnTarget.style.display = 'block' 
    // }


  }

  setPlayers(){
    let new_players = this.scheduledTargets.length 
    let curr_players = this.currentPlayersTargets.length

    let players = new_players + curr_players
    // console.log(`new players ${new_players} curr ${curr_players}`)
    this.playersTarget.innerHTML = players
    if (new_players > 0) {
      this.updateTarget.style.display = 'block'
      // console.log(`n curr players ${curr_players} has ${this.hasFormbtnTarget}`)

      if (this.hasFormbtnTarget) {
        this.formbtnTarget.style.display = 'none'
      }
    }else{
      this.updateTarget.style.display = 'none'
      // console.log(`x curr players ${curr_players} has ${this.hasFormbtnTarget}`)
      if (this.hasFormbtnTarget && curr_players > 0) {
        this.formbtnTarget.style.display = 'block' 
      }
      // if this.formbtnTarget

    }

    let pot = players * this.preferences['dues']
    let side = pot/3
    this.potTarget.innerHTML = `${pot}/${side}`
  }

}
