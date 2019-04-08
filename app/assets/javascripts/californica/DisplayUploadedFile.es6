export default class DisplayUploadedFile {
  constructor() {
    this.regexp = /[^a-zA-Z0-9\.\-\+_]/g
  }
  replaceWhitespace(input) {
    return input.replace(this.regexp, '_')
  }

  requiresEscape(input) {
    return this.regexp.test(input)
  }

  displayReplaceMessage(input) {
      if (this.requiresEscape(input)) {
        return `<b> Note: </b> Your file name contained spaces, which have been replaced by underscores.
This will have no effect on your import.`
      } else {
        return ''
      }
  }

      display() {
        var fileInput = document.querySelector('#file-upload')
        var files = fileInput.files
        for (var i = 0; i < files.length; i++) {
          var file = files[i]
          document.querySelector('#file-upload-display').innerHTML = `
            <div class="row">
            <div class="col-md-12">
            <div class="well style="
    background-color: #dff0d8;
    border-color: #d6e9c6;
    color: #3c763d;">
<p>You sucessfully uploaded this CSV: <b> ${this.replaceWhitespace(file.name)} </b>
</p>
              ${this.displayReplaceMessage(file.name)}
<p>
            </div>
            </div>
            </div>`

        }
      }
}
