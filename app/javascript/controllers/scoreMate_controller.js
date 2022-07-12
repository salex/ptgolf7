
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mateFront","mateBack","mateTotal","mateQuota","matePM"]

  connect() {
  }

  front(){
    // called if front value is changed
    this.setTotal()
  }

  back(){
    // called if back value is changed
    this.setTotal()
  }

  setTotal(){
    // if front or back changed, the total is set and scoreTeam controller is triggered by change
    const frontScore = this.frontVal
    const backScore = this.backVal
    if (frontScore != '' && backScore != '') {
      const total = frontScore + backScore
      this.mateTotalTarget.value = total
      this.matePMTarget.innerHTML =  total - this.quotaVal
    }else{
      this.mateTotalTarget.value = 'Unscored'
      this.matePMTarget.innerHTML = ''
    }
  }
  // Val getters return either a valid numb or a blank '' (or zero if no quota which should not happen)
  get frontVal(){
    const toNum =  Number(this.mateFrontTarget.value)
    if (isNaN(toNum) || toNum == 0 || toNum < 0) {
      if (this.mateFrontTarget.nodeName == 'INPUT'){
        this.mateFrontTarget.value = ''
        this.mateFrontTarget.classList.add('bg-red-100')
        this.mateFrontTarget.classList.remove('bg-green-100')
        this.mateBackTarget.select()
      }
      return('')
    }else{
      this.mateFrontTarget.classList.remove('bg-red-100')
      this.mateFrontTarget.classList.add('bg-green-100')
      return(toNum)
    }
  }

  get backVal(){
    const toNum =  Number(this.mateBackTarget.value)
    if (isNaN(toNum) || toNum == 0 || toNum < 0) {
      if (this.mateBackTarget.nodeName == 'INPUT'){
        this.mateBackTarget.value = ''
        this.mateBackTarget.classList.add('bg-red-100')
        this.mateBackTarget.classList.remove('bg-green-100')
        this.mateBackTarget.select()
      }
      return('')
    }else{
      this.mateBackTarget.classList.remove('bg-red-100')
      this.mateBackTarget.classList.add('bg-green-100')
      return(toNum)
    }
  }

  get quotaVal(){
    const toNum =  Number(this.mateQuotaTarget.value)
    if (isNaN(toNum)) {
      return(0)
    }else{
      return(toNum)
    }
  }

}

