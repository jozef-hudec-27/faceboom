// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "./custom/users_search"
import "./custom/anchor_scroll"
import "channels"

let csrfToken = document.querySelector('meta[name="csrf-token"]').content
document.querySelectorAll('a.contact').forEach(el => {
  el.addEventListener('click', async () => {
    let requestOptions = {
      method: 'PUT',
      headers: { 'X-CSRF-Token': csrfToken, 'Cookie': `_faceboom_session=${el.dataset.sessionCookie}` }
    }

    let responseA = await fetch(el.dataset.readMessagesLink, requestOptions)
    let responseB = await fetch(el.dataset.seeNotificationLink, requestOptions)
    let readMessagesData = await responseA.json()
    let seeNotificationData = await responseB.json()

    if (readMessagesData.last_noti_id) { // if we actually read any previously unread messages
      document.getElementById(`msg-noti-${readMessagesData.last_noti_id}-sender`).classList.remove('bold')
      document.getElementById(`msg-noti-${readMessagesData.last_noti_id}-body`).style = 'line-height: 1em;'
      document.getElementById(`msg-noti-${readMessagesData.last_noti_id}-dot`).remove()
    }

    if (seeNotificationData.update) {
      document.getElementById('message-notifications-btn').classList.remove('has-text-danger')
    }
  })
})
