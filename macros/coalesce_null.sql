{% macro coalesce_null(column_name, default_value) %}
    COALESCE({{ column_name }}, {{ default_value }})
{% endmacro %}
