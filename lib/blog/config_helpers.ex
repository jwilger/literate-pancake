defmodule Blog.ConfigHelpers do
  @moduledoc """
  Helper functions used in config/runtime.exs
  """

  @type config_type :: :str | :int | :bool | :json | :atom

  @doc """
  Get value from environment variable, converting it to the given type if needed.

  If no default value is given, or `:no_default` is given as the default, an error is raised if the variable is not
  set.
  """
  @spec get_env(String.t(), :no_default | any(), config_type()) :: any()
  def get_env(var, default \\ :no_default, type \\ :str)

  def get_env(var, :no_default, type) do
    var
    |> System.fetch_env!()
    |> get_with_type(type)
  end

  def get_env(var, default, type) do
    case System.fetch_env(var) do
      {:ok, val} -> get_with_type(val, type)
      :error -> default
    end
  end

  @spec get_with_type(String.t(), config_type()) :: any()
  defp get_with_type(val, type)

  defp get_with_type(val, :str), do: val
  defp get_with_type(val, :int), do: String.to_integer(val)
  defp get_with_type("true", :bool), do: true
  defp get_with_type("false", :bool), do: false
  defp get_with_type(val, :json), do: Jason.decode!(val)
  defp get_with_type(val, :atom), do: String.to_existing_atom(val)

  # Takes a string in the form `"one, two, three"` and turns it into a list,
  # `["one", "two", "three"]`
  defp get_with_type(val, :str_list) do
    val
    |> String.split(",")
    |> Enum.map(fn topic -> String.trim(topic) end)
  end

  defp get_with_type(val, type), do: raise("Cannot convert to #{inspect(type)}: #{inspect(val)}")
end
