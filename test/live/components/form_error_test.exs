defmodule TalismanWeb.Components.FormErrorTest do
  use TalismanWeb.ConnCase
  use Phoenix.Component
  import Phoenix.LiveViewTest

  alias TalismanWeb.Components.FormError

  test "renders an error" do
    error_content = Faker.StarWars.planet()
    errors = %{star_wars: error_content}

    assert render_component(
             fn assigns ->
               ~H"""
               <FormError.form_error errors={@errors} key={:star_wars} />
               """
             end,
             %{errors: errors}
           ) ==
             "<p class=\"text-red-500 text-sm\">\n  #{error_content}\n</p>"
  end

  test "doesn't render anything with an empty map" do
    assert render_component(
             fn assigns ->
               ~H"""
               <FormError.form_error errors={@errors} key={:star_wars} />
               """
             end,
             %{errors: %{}}
           ) ==
             ""
  end

  test "doesn't render anything with a map not having the error key" do
    errors = %{star_wars: Faker.StarWars.planet()}

    assert render_component(
             fn assigns ->
               ~H"""
               <FormError.form_error errors={@errors} key={:alessio} />
               """
             end,
             %{errors: errors}
           ) ==
             ""
  end
end
