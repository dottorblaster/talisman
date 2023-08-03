defmodule TalismanWeb.Components.ButtonTest do
  use TalismanWeb.ConnCase
  use Phoenix.Component
  import Phoenix.LiveViewTest

  alias TalismanWeb.Components.Button

  test "greets" do
    content = Faker.StarWars.character()

    assert render_component(
             fn assigns ->
               ~H"""
               <Button.button><%= @content %></Button.button>
               """
             end,
             %{content: content}
           ) ==
             "<button class=\"inline-block px-5 py-3 bg-orange-400 text-white font-medium rounded-lg w-full sm:w-auto\">\n  #{content}\n</button>"
  end
end
