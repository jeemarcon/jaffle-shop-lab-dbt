{% test not_below(model, column_name, min_value=0) %}

select *
from {{ model }}
where {{ column_name }} < {{ min_value }}

{% endtest %}