defmodule MidiProto.MessagePredicateGenerator do
  @moduledoc false

  defmacro generate_predicates(values \\ []) do
    :functions
    |> MidiProto.Message.__protocol__()
    |> Enum.filter(fn
      {name, 1} ->
        name
        |> Atom.to_string()
        |> String.ends_with?("?")

      _ ->
        false
    end)
    |> Enum.map(fn {function_name, _} ->
      predicate_name =
        function_name
        |> Atom.to_string()
        |> String.trim_trailing("?")
        |> String.to_atom()

      should_be_true = Keyword.get(values, predicate_name, false)

      quote do
        @spec unquote(function_name)(any) :: unquote(should_be_true)
        def unquote(function_name)(_), do: unquote(should_be_true)
        defoverridable [{unquote(function_name), 1}]
      end
    end)
  end
end
