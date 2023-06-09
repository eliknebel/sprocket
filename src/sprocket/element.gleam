import gleam/option.{Option}
import gleam/dynamic.{Dynamic}
import sprocket/html/attribute.{Attribute}
import sprocket/socket.{Socket}

pub type AbstractFunctionalComponent =
  fn(Socket, Dynamic) -> #(Socket, List(Element))

pub type FunctionalComponent(p) =
  fn(Socket, p) -> #(Socket, List(Element))

pub type Element {
  Element(tag: String, attrs: List(Attribute), children: List(Element))
  Component(component: FunctionalComponent(Dynamic), props: Dynamic)
  Debug(id: String, meta: Option(Dynamic), element: Element)
  Keyed(key: String, element: Element)
  SafeHtml(html: String)
  Raw(text: String)
}
