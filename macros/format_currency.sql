{% macro format_currency(column_name) %}
    ROUND({{ column_name }} / 100, 2)
{% endmacro %}