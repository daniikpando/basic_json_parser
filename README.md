# JSON to HTML'S LIST

## Use 

Use the main function something like that

```elixir
alias HtmlListParser

json_list = [
      %{"text" => "One", "indent" => 0, "type" => "ordered"},
      %{"text" => "Two", "indent" => 0, "type" => "ordered"},
      %{"text" => "Alpha", "indent" => 1, "type" => "bullet"},
      %{"text" => "Beta", "indent" => 1, "type" => "bullet"},
      %{"text" => "I", "indent" => 2, "type" => "ordered"},
      %{"text" => "II", "indent" => 2, "type" => "ordered"},
      %{"text" => "Three", "indent" => 0, "type" => "ordered"}
    ]

HtmlListParser.convert_json_to_html(json_list)
>> "
<ol> 
  <li>One  </li>
  <li>Two  
    <ul> 
      <li>Alpha  </li>
      <li>Beta  
        <ol>
          <li>I  </li>
          <li>II  </li> 
        </ol> 
      </li> 
    </ul>
  </li>
  <li>Three  </li> 
</ol>"
```
