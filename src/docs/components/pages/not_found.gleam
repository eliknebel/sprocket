import sprocket/socket.{Socket}
import sprocket/component.{render}
import sprocket/html.{div, h1, text}
import sprocket/html/attribute.{class}

pub type NotFoundPageProps {
  NotFoundPageProps
}

pub fn not_found_page(socket: Socket, _props: NotFoundPageProps) {
  render(
    socket,
    [
      div(
        [class("flex flex-col p-10")],
        [div([], [h1([class("text-xl mb-2")], [text("Page Not Found")])])],
      ),
    ],
  )
}
