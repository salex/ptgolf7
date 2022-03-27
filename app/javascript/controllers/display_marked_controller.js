import { Controller } from "@hotwired/stimulus"
import {marked} from 'marked'
import hljs from 'highlight.js'

export default class extends Controller {

  static targets = ["viewer","markup"]

  connect() {
    this.displayMarkdown()
  }

  displayMarkdown(){
    var html = marked(this.markupTarget.value, {sanitized: true, highlight: function(code, language) {
    const validLanguage = hljs.getLanguage(language) ? language : 'plaintext';
    return hljs.highlight(code, {language: validLanguage, ignoreIllegals: true }).value
    }})
    html = html.replace(/\<code class=\"/g,'<code class="hljs ')
    this.viewerTarget.innerHTML = html
  }

 
} 