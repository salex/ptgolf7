
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'dues_select','dues','meth','perc' ]

  connect() {
    console.log("got payout page ")
  }

  dues_select(){
    console.log("dues seletcted ")
    this.duesTarget.value = event.target.value

  }

  refresh(){
    var dues = this.duesTarget.value
    var meth = this.methTarget.value
    var perc = this.percTarget.value
    console.log(`got refresh click ${dues}`)

    location.assign(`/payouts?dues=${dues}&meth=${meth}&perc=${perc}`)
  }

}
