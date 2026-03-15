import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "submit"]

  connect() {
    this.scrollToBottom()
  }

  onKeydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      document.getElementById("message-form")?.querySelector("form")?.requestSubmit()
    }
  }

  onSubmit(event) {
    const form = event.target
    const input = form.querySelector("textarea")
    const submit = form.querySelector("button[type=submit]")
    const content = input?.value.trim()

    if (!content) {
      event.preventDefault()
      return
    }

    // Блокируем форму
    if (submit) submit.disabled = true
    if (input) {
      input.disabled = true
      input.value = ""
    }

    // Убираем empty state
    document.getElementById("empty-state")?.remove()

    // Optimistic UI — сразу добавляем сообщение пользователя
    this.appendToMessages(this.buildUserBubble(content))

    // Показываем индикатор "думает..."
    this.appendToMessages(this.buildThinkingIndicator())

    this.scrollToBottom()
  }

  appendToMessages(html) {
    const messages = document.getElementById("messages")
    if (messages) messages.insertAdjacentHTML("beforeend", html)
  }

  buildUserBubble(content) {
    const time = new Date().toLocaleTimeString("ru", { hour: "2-digit", minute: "2-digit" })
    return `
      <div class="flex justify-end mb-3 px-4">
        <div class="max-w-[80%]">
          <div class="rounded-2xl px-4 py-3 text-sm leading-relaxed break-words bg-indigo-600 text-white rounded-br-sm">
            ${this.escapeHtml(content)}
          </div>
          <div class="mt-1 text-xs text-gray-400 text-right">${time}</div>
        </div>
      </div>`
  }

  buildThinkingIndicator() {
    return `
      <div id="thinking-indicator" class="flex justify-start mb-3 px-4">
        <div class="max-w-[80%]">
          <div class="flex items-center gap-2 mb-1">
            <div class="w-6 h-6 rounded-full bg-indigo-600 flex items-center justify-center flex-shrink-0">
              <svg class="w-3 h-3 text-white" fill="currentColor" viewBox="0 0 20 20">
                <path d="M10 2a8 8 0 100 16A8 8 0 0010 2zm0 3a1 1 0 011 1v3.586l2.707 2.707a1 1 0 01-1.414 1.414l-3-3A1 1 0 019 10V6a1 1 0 011-1z"/>
              </svg>
            </div>
            <span class="text-xs text-gray-400 font-medium">AI</span>
          </div>
          <div class="bg-gray-100 rounded-2xl rounded-bl-sm px-4 py-3">
            <div class="flex items-center gap-1">
              <span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay:0ms"></span>
              <span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay:150ms"></span>
              <span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay:300ms"></span>
            </div>
          </div>
        </div>
      </div>`
  }

  scrollToBottom() {
    const el = document.getElementById("messages")
    if (el) requestAnimationFrame(() => { el.scrollTop = el.scrollHeight })
  }

  onInput(event) {
    if (this.isTurboNative) return
    const input = event.target
    input.style.height = "auto"
    input.style.height = Math.min(input.scrollHeight, 128) + "px"
  }

  get isTurboNative() {
    return /Turbo Native/i.test(navigator.userAgent)
  }

  escapeHtml(str) {
    return str
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
  }
}
