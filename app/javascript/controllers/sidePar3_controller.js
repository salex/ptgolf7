
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = ['par3Cnt','otherCnt', 'par3Hide','otherHide','par3Player','otherPlayer']
  static targets = ['par3Cnt','par3Hide','par3Player']
  static values = {defaultin: String}

  connect() {
    let blank =parseInt(this.par3CntTarget.innerHTML)

    if (this.defaultinValue == 'true' && blank == 0) {
      this.togglePar3()
    }
    // console.log(` WHOA  ${parseInt(this.par3CntTarget.innerHTML)}`)
  }

  
 
  togglePar3(){
    var p
    var hides = this.par3HideTargets
    for (p = 0; p < hides.length; p++) {
      if (hides[p].classList.contains('w3-hide')) {
        hides[p].classList.remove('w3-hide')
        hides[p].classList.add('w3-show')
        this.par3PlayerTargets[p].checked = true
      }else{
        hides[p].classList.add('w3-hide')
        hides[p].classList.remove('w3-show')
        this.par3PlayerTargets[p].checked = false
      }
    }
    this.update_par3()    
  }

  // toggleOther(){
  //   // not used for now
  //   var p
  //   var hides = this.otherHideTargets
  //   for (p = 0; p < hides.length; p++) {
  //     if (hides[p].classList.contains('w3-hide')) {
  //       hides[p].classList.remove('w3-hide')
  //       hides[p].classList.add('w3-show')
  //       this.otherPlayerTargets[p].checked = true
  //     }else{
  //       hides[p].classList.add('w3-hide')
  //       hides[p].classList.remove('w3-show')
  //       this.otherPlayerTargets[p].checked = false
  //     }
  //   }
  //   this.update_other()    
  // }

  togglePar3Player(){
    const player = event.target
    var idx = Number(player.dataset.idx)
    var hideDiv = this.par3HideTargets[idx]

    if (hideDiv.classList.contains('w3-hide')) {
      hideDiv.classList.remove('w3-hide')
      hideDiv.classList.add('w3-show')
    }else{
      hideDiv.classList.add('w3-hide')
      hideDiv.classList.remove('w3-show')
    }
    this.update_par3()
  }

  // toggleOtherPlayer(){
  //   const player = event.target
  //   var idx = Number(player.dataset.idx)
  //   var hideDiv = this.otherHideTargets[idx]
  //   if (hideDiv.classList.contains('w3-hide')) {
  //     hideDiv.classList.remove('w3-hide')
  //     hideDiv.classList.add('w3-show')
  //     this.otherPlayerTargets[idx].value = 'true'
  //   }else{
  //     hideDiv.classList.add('w3-hide')
  //     hideDiv.classList.remove('w3-show')
  //     this.otherPlayerTargets[idx].value = 'false'
  //   }
  //   this.update_other()
  // }

 
  update_par3(){
    var players = this.par3PlayerTargets
    var inCount = 0
    var pin = this.par3CntTarget
    for (var i =  players.length - 1; i >= 0; i--) {
      if (players[i].checked ) {
        inCount += 1
      }
    }
    pin.innerHTML = inCount
  }

  // update_other(){
  //   var players = this.otherPlayerTargets
  //   var inCount = 0
  //   var pin = this.otherCntTarget
  //   for (var i =  players.length - 1; i >= 0; i--) {
  //     console.log(players[i].checked)
  //     if (players[i].checked ) {
  //       inCount += 1
  //     }
  //   }
  //   pin.innerHTML = inCount
  // }

  get idx() {
    return event.target.dataset.idx
  }

}
