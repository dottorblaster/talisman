defmodule TalismanWeb.Components.ButtonTest do
  use TalismanWeb.ConnCase
  use Phoenix.Component
  import Phoenix.LiveViewTest

  alias TalismanWeb.Components.Button

  test "renders" do
    content = Faker.StarWars.character()

    assert render_component(
             fn assigns ->
               ~H"""
               <Button.button><%= @content %></Button.button>
               """
             end,
             %{content: content}
           ) ==
             "<button class=\"ease-in inline-block px-5 py-2 rounded-lg border-b-4 border-orange-500 bg-orange-400 text-white transition font-semibold shadow-md focus:ring-2 focus:ring-offset-2 hover:bg-orange-500\">\n  #{content}\n</button>"
  end

  test "merges classes" do
    content = Faker.StarWars.character()

    assert render_component(
             fn assigns ->
               ~H"""
               <Button.button class="sample-class"><%= @content %></Button.button>
               """
             end,
             %{content: content}
           ) ==
             "<button class=\"ease-in inline-block px-5 py-2 rounded-lg border-b-4 border-orange-500 bg-orange-400 text-white transition font-semibold shadow-md focus:ring-2 focus:ring-offset-2 hover:bg-orange-500 sample-class\">\n  #{content}\n</button>"
  end
end
