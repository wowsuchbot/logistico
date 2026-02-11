defmodule ApiWeb.FallbackController do
  use ApiWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "Not found"})
  end

  def call(conn, {:error, reason}) when is_binary(reason) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: reason})
  end

  def call(conn, {:error, _}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "Unprocessable entity"})
  end
end
