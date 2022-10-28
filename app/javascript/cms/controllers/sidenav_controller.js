import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="sidenav"
export default class extends Controller {
  initialize () {
    $('#ai-menu-list-btn').click(e => {
      e.preventDefault();
      slideMenuTextShowHide();
    })
  }
}

function slideMenuTextShowHide () {
  const ai_menu_list = $('#ai-menu-list')
  const ai_body = $('#ai-body')
  if (ai_menu_list.width() == 200) {
    ai_menu_list.width($('.ac-menu-list-item span').width())
    $('.ac-menu-list-item p').css('display', 'none')
    ai_body.css({ 'left': 50, 'width': 'calc(100% - 50px)' })
  } else {
    ai_menu_list.width(200)
    $('.ac-menu-list-item p').css('display', 'block')
    ai_body.css({ 'left': 200, 'width': 'calc(100% - 200px)' })
  }
}
