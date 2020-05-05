defmodule MessageImplPredicateTestHelper do
  defmacro test_message_impl_predicates(message, defaults \\ []) do
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

      should_be_true = Keyword.get(defaults, predicate_name, false)

      if should_be_true do
        quote do
          try do
            describe "Message.#{unquote(function_name)}/1" do
              test "it is true" do
                assert apply(MidiProto.Message, unquote(function_name), [unquote(message)]),
                       "Expected `Message.#{unquote(function_name)}/1` to be true"
              end
            end
          rescue
            ExUnit.DuplicateDescribeError -> nil
          end
        end
      else
        quote do
          try do
            describe "Message.#{unquote(function_name)}/1" do
              test "it is false" do
                refute apply(MidiProto.Message, unquote(function_name), [unquote(message)]),
                       "Expected `Message.#{unquote(function_name)}/1` to be false"
              end
            end
          rescue
            ExUnit.DuplicateDescribeError -> nil
          end
        end
      end
    end)
  end
end
