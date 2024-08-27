; TreeSitter query for tailwind classes in tsx
(jsx_attribute
  (property_identifier) @_attribute_name
  (#any-of? @_attribute_name "class" "className" "style" "css" "tw")
  [
    (string
      (string_fragment) @tailwind)
    (jsx_expression
      (call_expression
        (identifier) @_function_name
        (#eq? @_function_name "cn")
        [
          (arguments
            (string) @tailwind.inner)
        ]
      )
    )
  ]
)
