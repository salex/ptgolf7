
### A rudimentary Stimulus WYSIWYG markdown editor

After about a month of refactoring one of my Rails applications, I though I should document what all I did. I first started to write in a .md document using Sublime Text. After few paragraphs I previewed what little I wrote. This back and forth was going to be a pain and I though, maybe I should add a javascript markdown editor.

I did a quick search and found a few from the `10 best.. or 7 best` posts. Half of them had not been changed in years. I've been using Stimulus for about a year after about a four month effort of de-jQuering three applications. That included getting away from CSS frameworks that relied on jQuery (Zurb Foundation in my case) and just using the simplistic but effective [W3.CSS](https://www.w3schools.com/w3css/). I did another quick search for `stimulus javascript editor` and up popped a link [Build a Markdown Editor in Stimulus.js like in Vue.js](https://onrails.blog/2018/11/09/build-a-markdown-editor-in-stimulus-js-like-in-vue-js/).

I thought this was amazing - a WYSIWYG editor with a 4 line HTML template and an 8 line Stimulus controller! Of course it used a javascript package [marked](https://marked.js.org/) to do the heavy lifting.

I threw the 12 lines in a demo page, after changing to slim, and it worked. Wow I said, but it does not have any of the little buttons for Bold, List, etc. Well I didn't have anything else to do yesterday (or wanted to do!), so I started tinkering.

The HTML grew to about 24 lines, most of it for the added buttons (just abbreviated text buttons - missing a few).

```ruby
.w3-container[data-controller="marked" style="max-height: 90vh;"]
  h3 Marked Demo
  .w3-row-padding
    .w3-half
      = tag.button('B', data:{action:"click->marked#bold"})
      = tag.button('I', data:{action:"click->marked#italic"})
      = tag.button('BI', data:{action:"click->marked#italicBold"})
      = tag.button('H1', data:{action:"click->marked#h1"})
      = tag.button('H2', data:{action:"click->marked#h2"})
      = tag.button('H3', data:{action:"click->marked#h3"})
      = tag.button('H4', data:{action:"click->marked#h4"})
      = tag.button('H5', data:{action:"click->marked#h5"})
      = tag.button('H6', data:{action:"click->marked#h6"})
      = tag.button('BQ>', data:{action:"click->marked#backQuote"})
      = tag.button('BT`', data:{action:"click->marked#backTick"})
      = tag.button('UL', data:{action:"click->marked#ul"})
      = tag.button('OL', data:{action:"click->marked#ol"})
      = tag.button('FC', data:{action:"click->marked#fencedCode"})
      = tag.button('LK', data:{action:"click->marked#anchor"})
      = tag.button('IM', data:{action:"click->marked#image"})
      = tag.textarea('', data:{action:"input->marked#convertToMarkdown change->marked#convertToMarkdown",marked_target:"markup"},style:'width:100%;height:75vh;')
    .w3-half
      = tag.button('Rendered Markdown')
      = tag.div('',data:{marked_target:'viewer'},style:"border:solid black 1px;height:75vh;overflow:scroll;")
```

The controller grew to about 160 lines, most of it in a [getInputSelection function](https://jsfiddle.net/ourcodeworld/o4k7rfu0/1/) that I found. I can't find the link in my history, but did find the jsfiddle page.


```javascript
import { Controller } from "stimulus"
import marked from 'marked/lib/marked.js'

export default class extends Controller {

  static targets = ["viewer","markup"]

  connect() {
  }

  convertToMarkdown(event) {
    this.viewerTarget.innerHTML = marked(event.target.value, {sanitized: true})
  }

  trigger(){
    var chg = new Event('change',{ bubbles: true })
    this.markup.dispatchEvent(chg)
    // marked does not pick up js insertions, trigger a change
  }


  h1() {
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    this.insert('\n# '+selected)
  }

  h2() {
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    this.insert('\n## '+selected + ' ')
  }

  h3() {
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    this.insert('\n### '+selected)
  }

  h4() {
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    this.insert('\n#### '+selected)
  }

  h5() {
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    this.insert('\n##### '+selected)
  } 

  h6() {
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    this.insert('\n###### '+selected)
  } 

  bold() {
    this.wrap('**')
  }

  italic() {
    this.wrap('*')
  }

  italicBold() {
    this.wrap('***')
  }

  backTick(){
    this.wrap('`')
  }

  ul() {
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    selected = "\n* " + selected.replace(/\n/g,"\n* ")
    this.insert(selected)
  }

  ol() {
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    selected = "\n1. " + selected.replace(/\n/g,"\n1. ")
    this.insert(selected)
  }

  fencedCode(){
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    selected = "```lang\n " + selected + "\n```"
    this.insert(selected)
  }

  anchor(){
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    selected = "[" + selected + "]" + '(http://...)'
    this.insert(selected)
  }

  image(){
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    selected = "![" + selected + "]" + '(path/to/img.jpg)'
    this.insert(selected)
  }

  backQuote(){
    var selected = this.markup.value.substring(this.range.start,this.range.end)
    selected = ">" + selected
    this.insert(selected)
  }

  get markup() {
    return this.markupTarget
  }

  get range(){
    return this.getInputSelection(this.markup)
  }

  insert(selected){
    const len = this.markup.value.length
    this.markup.value = this.markup.value.substring(0,this.range.start) + selected + this.markup.value.substring(this.range.end,len)
    this.trigger()
  }

  wrap(wrapper){
    const len = this.markup.value.length
    const wrapie = wrapper + this.markup.value.substring(this.range.start,this.range.end) + wrapper
    this.markup.value = this.markup.value.substring(0,this.range.start) + wrapie + this.markup.value.substring(this.range.end,len)
    this.trigger()
  }

  getInputSelection(el) {
    var start = 0, end = 0, normalizedValue, range, textInputRange, len, endRange;

    if (typeof el.selectionStart == "number" && typeof el.selectionEnd == "number") {
        start = el.selectionStart;
        end = el.selectionEnd;
    } else {
        range = document.selection.createRange();

        if (range && range.parentElement() == el) {
            len = el.value.length;
            normalizedValue = el.value.replace(/\r\n/g, "\n");
            // Create a working TextRange that lives only in the input
            textInputRange = el.createTextRange();
            textInputRange.moveToBookmark(range.getBookmark());
            // Check if the start and end of the selection are at the very end
            // of the input, since moveStart/moveEnd doesn't return what we want
            // in those cases
            endRange = el.createTextRange();
            endRange.collapse(false);

            if (textInputRange.compareEndPoints("StartToEnd", endRange) > -1) {
                start = end = len;
            } else {
                start = -textInputRange.moveStart("character", -len);
                start += normalizedValue.slice(0, start).split("\n").length - 1;

                if (textInputRange.compareEndPoints("EndToEnd", endRange) > -1) {
                    end = len;
                } else {
                    end = -textInputRange.moveEnd("character", -len);
                    end += normalizedValue.slice(0, end).split("\n").length - 1;
                }
            }
        }
    }

    return {
        start: start,
        end: end
    };
  }

}  
```

Well I felt proud of myself - but I ended up using sublime text to write this!! I did use the editor to tweak and add some stuff.

Stimulus is really amazing for someone who had a lot of problems with early rails javascript - made it through coffeescript - and now feel comfortable with stimulus and the little es6 javascript sprinkles.

