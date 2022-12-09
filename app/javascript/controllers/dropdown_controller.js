import Dropdown from 'stimulus-dropdown'

export default class extends Dropdown {
  connect() {
    super.connect()
    console.log('Do what you want here.')
  }

  toggle(event) {
    super.toggle()
    console.log('Toggle Show.')
  }

  hide(event) {
    super.hide(event)
    console.log('Toggle Hide.')
  }
}
