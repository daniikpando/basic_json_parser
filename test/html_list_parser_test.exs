defmodule HtmlListParserTest do
  use ExUnit.Case
  doctest HtmlListParser

  test "Basic test" do
    assert HtmlListParser.test_function() == " <ol> <li>One  </li><li>Two  <ul> <li>Alpha  </li><li>Beta  <ol> <li>I  </li><li>II  </li> </ol> </li> </ul> </li><li>Three  </li> </ol>"
  end
end
