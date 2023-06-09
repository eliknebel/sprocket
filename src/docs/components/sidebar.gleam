import gleam/int
import gleam/list
import gleam/option.{None, Option, Some}
import sprocket/socket.{Socket}
import sprocket/component.{component, render}
import sprocket/hooks/reducer.{State, reducer}
import sprocket/html.{a, div, keyed, span, text}
import sprocket/html/attribute.{class, classes}
import docs/components/search_bar.{SearchBarProps, search_bar}

pub type Page {
  Page(title: String, href: String)
}

type Model {
  Model(show: Bool, search_filter: Option(String))
}

type Msg {
  NoOp
  SetSearchFilter(Option(String))
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    NoOp -> model
    SetSearchFilter(search_filter) ->
      Model(..model, search_filter: search_filter)
  }
}

fn initial() -> Model {
  Model(show: True, search_filter: None)
}

pub type SidebarProps {
  SidebarProps(pages: List(Page), active: String)
}

pub fn sidebar(socket: Socket, props) {
  let SidebarProps(pages: pages, active: active) = props

  use socket, State(Model(show: show, search_filter: search_filter), dispatch) <- reducer(
    socket,
    initial(),
    update,
  )

  render(
    socket,
    case show {
      True -> [
        div(
          [class("border-r border-gray-200 p-2 w-[20rem]")],
          [
            component(
              search_bar,
              SearchBarProps(on_search: fn(query) {
                case query {
                  "" -> dispatch(SetSearchFilter(None))
                  _ -> dispatch(SetSearchFilter(Some(query)))
                }
              }),
            ),
            ..case search_filter {
              Some(query) -> [
                div(
                  [],
                  [
                    span([class("bold italic")], [text("No results for: ")]),
                    span([], [text(query)]),
                  ],
                ),
              ]
              None ->
                list.index_map(
                  pages,
                  fn(i, page) {
                    keyed(
                      page.title,
                      component(
                        link,
                        LinkProps(
                          int.to_string(i + 1) <> ". " <> page.title,
                          page.href,
                          page.href == active,
                        ),
                      ),
                    )
                  },
                )
            }
          ],
        ),
      ]
      False -> []
    },
  )
}

type LinkProps {
  LinkProps(title: String, href: String, is_active: Bool)
}

fn link(socket: Socket, props: LinkProps) {
  let LinkProps(title: title, href: href, is_active: is_active) = props

  render(
    socket,
    [
      a(
        [
          classes([
            "block p-2 text-blue-500 hover:text-blue-700",
            case is_active {
              True -> "font-bold"
              False -> ""
            },
          ]),
          attribute.href(href),
        ],
        [text(title)],
      ),
    ],
  )
}
