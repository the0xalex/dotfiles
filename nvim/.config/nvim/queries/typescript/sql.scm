(call_expression
    function: (identifier) @id (#eq? @id "sql")
    arguments: (template_string) @sql
    (#set! injection.language "sql")
    (#offset! @sql 0 1 0 -1) ; exclude backticks
)
