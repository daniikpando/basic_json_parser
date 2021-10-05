defmodule HtmlListParser do
  @moduledoc """
  Documentation for `HtmlListParser`.
  """
  @types %{
    "ordered" => "ol",
    "bullet" => "ul"
  }

  defp dfs([], acc, visited), do: {acc, visited}

  defp dfs([{current_indent, elms} | tail] = graph, acc, visited) do
    if MapSet.member?(visited, current_indent) do
      {acc, visited}
    else
      [{_, first_elm} | _] = elms
      parent_html = Map.get(@types, first_elm["type"])

      {visited, html_code} =
        Enum.reduce(elms, {visited, []}, fn {_, current_elm}, {visited_acc, html_code_acc} ->
          {nested_nodes, new_visited} =
            case current_elm do
              %{"children" => nil} ->
                {"", MapSet.new()}

              %{"children" => val} when is_integer(val) ->
                nested_elms =
                  Enum.filter(graph, fn {indent_filtered, _} ->
                    indent_filtered >= val
                  end)

                dfs(nested_elms, "", visited_acc)
            end

          html_node = "<li>#{current_elm["text"]} #{nested_nodes} </li>"
          {MapSet.union(visited_acc, new_visited), html_code_acc ++ [html_node]}
        end)

      acc = "#{acc} <#{parent_html}> #{Enum.join(html_code)} </#{parent_html}>"

      dfs(tail, acc, MapSet.put(visited, current_indent))
    end
  end

  def convert_json_to_html(json_list) do
    json_with_order =
      json_list
      |> Enum.with_index()
      |> Map.new(fn {elm, index} -> {index, elm} end)

    {html_code, _} =
      for {%{"indent" => current_indent} = node, index} <- json_list |> Enum.with_index() do
        next_indent = current_indent + 1
        new_node = Map.put(node, "children", nil)

        # know the next node
        Map.get(json_with_order, index + 1, nil)
        |> case do
          nil ->
            {index, new_node}

          %{"indent" => ^next_indent} ->
            {index, Map.put(new_node, "children", next_indent)}

          _ ->
            {index, new_node}
        end
      end
      |> Enum.group_by(fn {_, %{"indent" => indent}} -> indent end)
      |> Enum.to_list()
      |> dfs("", MapSet.new())

    html_code
  end

  def test_function() do
    json_list = [
      %{"text" => "One", "indent" => 0, "type" => "ordered"},
      %{"text" => "Two", "indent" => 0, "type" => "ordered"},
      %{"text" => "Alpha", "indent" => 1, "type" => "bullet"},
      %{"text" => "Beta", "indent" => 1, "type" => "bullet"},
      %{"text" => "I", "indent" => 2, "type" => "ordered"},
      %{"text" => "II", "indent" => 2, "type" => "ordered"},
      %{"text" => "Three", "indent" => 0, "type" => "ordered"}
    ]

    convert_json_to_html(json_list)
  end
end
