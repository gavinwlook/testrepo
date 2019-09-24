- dashboard: date_parameter
  title: Date Parameter
  layout: newspaper
  elements:
  - title: New Tile
    name: New Tile
    model: gavlook
    explore: orders
    type: table
    fields: [orders.count, custom_field_age]
    filters:
      orders.date_parameteeer: 2019/08/16
    limit: 500
    dynamic_fields: [{dimension: custom_field_age, label: Custom Field AGE, expression: "${users.age}\
          \ * 2.0", value_format: !!null '', value_format_name: !!null '', _kind_hint: dimension,
        _type_hint: number}]
    query_timezone: UTC
    series_types: {}
    row: 0
    col: 0
    width: 8
    height: 6
# ${users.age}
