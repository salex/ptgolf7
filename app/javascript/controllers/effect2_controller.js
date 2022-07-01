import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link", 'element']

  connect(){
    console.log('connected')
  }

  highlight(){
    var lnk = event.target.dataset.effect2Target
    var idx = eval(`this.${lnk}Targets`).indexOf(event.target)
    // var idx = trgts.indexOf(event.target)
    this.elementTargets[idx].classList.toggle('text-blue-700')
    this.elementTargets[idx].classList.toggle('font-bold')
  }

}
