{% macro extract_json_value(json_column, key) %}
    {{ json_column }}->>{{ key }}
{% endmacro %}