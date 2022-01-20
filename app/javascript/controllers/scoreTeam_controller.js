
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["teamQuota","teamFront","teamBack","teamTotal","teamPM","mateFront","mateBack"]

  connect() {
    this.status = document.getElementById('status_box')
    this.matesPM = document.getElementsByClassName('mate-pm')
    this.compute()
  }

  compute(){
    // sum up mates total for front, back and total and set team nodes
    const quota = Number(this.teamQuotaTarget.value)
    const side = quota/2.0
    const mfront = this.front
    const mback = this.back
    const mtotal = mfront + mback

    this.teamFrontTarget.innerHTML = `${mfront}/${mfront - side}`
    this.teamBackTarget.innerHTML = `${mback}/${mback - side}`
    this.teamTotalTarget.innerHTML = `${mtotal}/${mtotal - quota}`
    this.teamPMTarget.innerHTML = mtotal - quota
    this.setScoreStatus()
  }

  get front(){
    const mates = this.mateFrontTargets
    var total = 0
    for (var i = 0;  i < mates.length; i++) {
      const toNum =  Number(mates[i].value)
      if (!isNaN(toNum)) {
        total += toNum
      }
    }
    return total
  }

  get back(){
    const mates = this.mateBackTargets
    var total = 0
    for (var i = 0;  i < mates.length; i++) {
      const toNum =  Number(mates[i].value)
      if (!isNaN(toNum)) {
        total += toNum
      }
    }
    return total
  }

  setScoreStatus(){
    /*
      Set status_box to current status
      Uses team mates plus/minus cell to control status (uses class to get all mates on all teams)
      blank is unscored, some value scored
    */
    const players = this.matesPM.length
    var unscored = 0
    for (var i = 0;  i < this.matesPM.length; i++) {
      if (this.matesPM[i].innerHTML === '') {
        unscored += 1
      }
    }
    if (unscored === 0){
      var sb = document.getElementById('submit_form')
      sb.removeAttribute('disabled')
      sb.classList.remove('w3-disabled')
      this.status.classList.remove('w3-text-red')
      this.status.classList.add('w3-text-green')
      this.status.innerHTML = "All teams/mates have been scored. You can now submit the scores"
    }else{
      var sb = document.getElementById('submit_form')
      sb.setAttribute('disabled','disabled')
      sb.classList.add('w3-disabled')
      this.status.classList.remove('w3-text-green')
      this.status.classList.add('w3-text-red')
      this.status.innerHTML = `${unscored} out of ${players} players have not been scored`
    }
  }

}
