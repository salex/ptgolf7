
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["idx", "team","teamQuota","teamFront","teamBack","teamTotal","teamPM",
    "mateQuota","mateFront","mateBack","mateTotal","matePM","unscored" ]

  connect() {
    console.log("score game")
    this.teams
    this.idx
    this.tidx
    this.makeTeams()
  }

  makeTeams(){
    this.teams = []
    for (var i = 0; i < this.teamTargets.length; i++) {
      var t = Number(this.teamTargets[i].value)
      if (this.teams[t] == undefined) {
        this.teams[t] = [i]
      } else {
        this.teams[t].push(i)
      }
    }
    // console.log(this.teams)
  }

  front(){
    const mfront = this.mateFrontTargets
    const t = event.target
    // console.log(t)
    this.idx = mfront.indexOf(t)
    this.tidx = Number(this.teamTargets[this.idx].value)
    const f = this.frontVal
    const b = this.backVal
    if (b != '' && f != '') {
      const t =f + b
      this.mateTotalTargets[this.idx].value = t
      this.matePMTargets[this.idx].innerHTML =  t - this.quotaVal
      this.fireCompute()
    }else{
      this.mateTotalTargets[this.idx].value='Unscored'
      this.matePMTargets[this.idx].innerHTML = ''
      this.fireCompute()
    }

  }

  back(){
    const mback = this.mateBackTargets
    const t = event.target
    // console.log(t)
    this.idx = mback.indexOf(t)
    this.tidx = Number(this.teamTargets[this.idx].value)
    const f = this.frontVal
    const b = this.backVal
    if (b != '' && f != '') {
      const t =f + b
      this.mateTotalTargets[this.idx].value = t
      this.matePMTargets[this.idx].innerHTML =  t - this.quotaVal
      this.fireCompute()
    }else{
      this.mateTotalTargets[this.idx].value='Unscored'
      this.matePMTargets[this.idx].innerHTML = ''
      this.fireCompute()
    }
  }

  fireCompute(){
    // console.log("something fired and I have to go to work")
    // console.log(`this.team ${this.tidx}`)
    var tback = this.teamBackTargets[this.tidx]
    var tfront = this.teamFrontTargets[this.tidx]
    var ttotal = this.teamTotalTargets[this.tidx]
    var tPM = this.teamPMTargets[this.tidx]
    const quota = Number(this.teamQuotaTargets[this.tidx].value)
    const side = quota/2.0

    const mfront = this.teamFront
    const mback = this.teamBack
    const mtotal = mfront + mback

    tfront.innerHTML = `${mfront}/${mfront - side}`
    tback.innerHTML = `${mback}/${mback - side}`
    ttotal.innerHTML = `${mtotal}/${mtotal - quota}`
    tPM.innerHTML = mtotal - quota
    // // var spans = document.getElementById('error_box').childNodes
    // spans[1].innerHTML = this.totalUnscored
    this.unscoredTarget.innerHTML = this.totalUnscored
  }

  get totalUnscored(){
    const mates = this.matePMTargets
    const players = mates.length

    var unscored = 0
    for (var i = 0;  i < mates.length; i++) {
      // const toNum =  Number(mates[i].value)
      if (mates[i].innerHTML === '') {
        unscored += 1
      }
    }
    if (unscored === 0){
      // var sb = document.getElementById('submit_form')
      // sb.removeAttribute('disabled')
      // sb.classList.remove('w3-disabled')
      return("All teams/mates have been scored. You can now submit the scores")
    }else{
      // var sb = document.getElementById('submit_form')
      // sb.setAttribute('disabled','disabled')
      // sb.classList.add('w3-disabled')

      return(`${unscored} out of ${players} players have not been scored`)
    }
  }

  get frontVal(){
    const toNum =  Number(this.mateFrontTargets[this.idx].value)
    if (isNaN(toNum) || toNum == 0 ) {
      if (this.mateFrontTargets[this.idx].nodeName == 'INPUT'){
        this.mateFrontTargets[this.idx].value = ''
      }
      return('')
    }else{
      return(toNum)
    }
  }

  get backVal(){
    // console.log(this.mateBackTarget.nodeName)
    const toNum =  Number(this.mateBackTargets[this.idx].value)
    if (isNaN(toNum) || toNum == 0 ) {
      if (this.mateBackTargets[this.idx].nodeName == 'INPUT'){
        this.mateBackTargets[this.idx].value = ''
      }
      return('')
    }else{
      return(toNum)
    }
  }

  get quotaVal(){
    const toNum =  Number(this.mateQuotaTargets[this.idx].value)
    if (isNaN(toNum)) {
      return(0)
    }else{
      return(toNum)
    }
  }

  get teamFront(){
    const mates = this.mateFrontTargets
    var total = 0
    for (var i = 0;  i < this.teams[this.tidx].length; i++) {
      const mate = this.teams[this.tidx][i]
      const toNum =  Number(mates[mate].value)
      if (!isNaN(toNum)) {
        total += toNum
      }
    }
    return total
  }

  get teamBack(){
    const mates = this.mateBackTargets
    var total = 0
    for (var i = 0;  i < this.teams[this.tidx].length; i++) {
      const mate = this.teams[this.tidx][i]
      const toNum =  Number(mates[mate].value)
      if (!isNaN(toNum)) {
        total += toNum
      }
    }
    return total
  }

}

/*
Patricia J Davie  |  San Antonio, Texas
Age: 74
Phone Number:
210-496-9660, 210-491-0231
Addresses:
12039 Stoney Smt, San Antonio, TX ; 16406 Ledge Park St, San Antonio, TX ; 16406 Ledge Park St, Boca Raton, FL
Relatives:
Donald Davie, Craig D Davie, Ashley Davie
Email:
pda***@attbi.com, pda***@hotmail.com, pda***@lycos.com
*/
