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
             "<button class=\"inline-block w-full rounded-lg bg-orange-400 px-5 py-3 font-medium text-white sm:w-auto\">\n  #{content}\n</button>"
  end
end
