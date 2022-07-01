import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link", 'element']

  connect(){
    console.log('connected')
  }

  highlight() {
    // console.log(this.linkTargets)
    var lnk = event.target.dataset.linkId
    var elems = this.elementTargets
    // console.log(elems)
    for (var i = elems.length - 1; i >= 0; i--) {
      if (elems[i].dataset.elementId == lnk){
        elems[i].classList.toggle('text-red-700')
        elems[i].classList.toggle('font-bold')

        // console.log(elems[i])
        break
      }
    }
  }

  // highlight(){
  //   var lnk = event.target.dataset.effectTarget
  //   var trgts = eval(`this.${lnk}Targets`)
  //   var idx = trgts.indexOf(event.target)
  //   this.elementTargets[idx].classList.add('text-blue-700')
  // }
}