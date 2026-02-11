defmodule ApiWeb.ErrorView do
  use ApiWeb, :view

  def render("404.json", _assigns) do
    %{error: "Not found"}
  end

  def render("500.json", _assigns) do
    %{error: "Internal server error"}
  end

  def template_not_found(template, _assigns) do
    %{error: "Not found: #{template}"}
  end
end
