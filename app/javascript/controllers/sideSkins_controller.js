
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "in","good", "hole","par","parString","skinsin",'skinsHide','skinsPlayer']
  static values = {defaultin: String}

  connect() {
    let blank =parseInt(this.inTarget.innerHTML)

    if (this.defaultinValue == 'true' && blank == 0) {
      this.toggleSkins()
    }

    // if (this.defaultinValue == 'true') {
    //   this.toggleSkins()
    // }
  }

  toggleSkins(){
    var hides = this.skinsHideTargets
    for (var i = 0; i < hides.length; i++) {
      if (hides[i].classList.contains('w3-hide')) {
        hides[i].classList.remove('w3-hide')
        hides[i].classList.add('w3-show')
        this.skinsinTargets[i].value = 'true'
        this.skinsPlayerTargets[i].checked = true
      }else{
        hides[i].classList.add('w3-hide')
        hides[i].classList.remove('w3-show')
        this.skinsinTargets[i].value = 'false'
        this.skinsPlayerTargets[i].checked = false
      }
    }
    this.update()    
  }

  toggleSkinsPlayer(){
    const player = event.target
    var idx = Number(player.dataset.idx)
    var hideDiv = this.skinsHideTargets[idx]

    if (hideDiv.classList.contains('w3-hide')) {
      hideDiv.classList.remove('w3-hide')
      hideDiv.classList.add('w3-show')
      this.skinsinTargets[idx].value = 'true'
    }else{
      hideDiv.classList.add('w3-hide')
      hideDiv.classList.remove('w3-show')
      this.skinsinTargets[idx].value = 'false'
    }
    this.update()
  }

  update(){
    const par = this.parTargets
    var goodString = this.goodTarget
    var holes = this.holeTargets
    var skinsin = this.skinsinTargets
    var parArray = []
    var cutArray = []
    var goodArray = new Array(18).fill('.')
    var inCount = 0
    for (var i =  skinsin.length - 1; i >= 0; i--) {
      if (skinsin[i].value == 'true' ) {
        parArray.push( par[i].value)
        inCount += 1
      }
    }
    this.inTarget.innerHTML = inCount

    for (var i = parArray.length - 1; i >= 0; i--) {
      var ca
      ca = parArray[i]
      ca = ca.replace(/B/g,'1')
      ca = ca.replace(/E/g,'2')
      ca = ca.replace(/A/g,'3')
      cutArray.push(ca)
    }

    for (var i = 0 ; i < cutArray.length; i++) {
      var cut = cutArray[i]
      var c
      for (var j = 0 ; j < cut.length; j++) {
        c = cut.charAt(j)
        if( c == '.') {
          continue
        }
        if (c > goodArray[j]) {
          goodArray[j] = c
          continue
        }
        if (c == goodArray[j]) {
          goodArray[j] = '9'
          continue
        }
      }
    }

    goodString.value = goodArray.toString().replace(/,/g,'')
    for (var i = 0 ; i < goodString.value.length; i++) {
      holes[i].classList.remove('birdie','eagle','albatros','cut','card-B','card-E','card-A','err')
      // console.log(`da value [${i}] ${goodString.value[i]}`)
      var val = goodString.value[i]
      if (val === '.') {holes[i].classList.add('skin-hole')}
      if (val === '1') {holes[i].classList.add('birdie')}
      if (val === '2') {holes[i].classList.add('eagle')}
      if (val === '3') {holes[i].classList.add('albatros')}
      if (val === '0') {holes[i].classList.add('cut')}
      if (val === '9') {holes[i].classList.add('cut')}
    }
  }

  holeClicked(){
    var hole = event.target
    var holeNum = Number(hole.dataset.hole)
    var idx = Number(hole.dataset.idx)
    this.idx = idx
    let score = hole.innerHTML
    var parString = this.parStringTargets[idx]
    var par = this.parTargets[idx]
    let holeScore = this.get_new_val_up(score)
    if (score != '.') {
      hole.classList.remove(`card-${score}`)
    }
    if (holeScore != '.') {
      hole.classList.add(`card-${holeScore}`)
    }
    hole.innerHTML = holeScore
    let newParString = this.replaceAt(parString.innerHTML,holeNum,holeScore)
    parString.innerHTML = newParString
    par.value = newParString
    const e = new Event("change");
    par.dispatchEvent(e);
  }

  get_new_val_up(curr_val) {
    let new_val;
    switch (curr_val) {
      case '.': return new_val = 'B'
      case 'B': return new_val = 'E'
      case 'E': return new_val = 'A'
      case 'A': return new_val = '.'
      default: return new_val = "?"
    }
  }

  replaceAt(str,at,char){
   let rs =  str.slice(0,(at-1))+char+str.slice(at)
   // console.log(rs)
   return(rs)
  }

}
