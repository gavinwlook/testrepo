connection: "thelook"

datagroup: mysqltest_default_datagroup {
  max_cache_age: "12 hour"
}
persist_with: mysqltest_default_datagroup

# include all the views
 include: "*.view"

datagroup: gavlook_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

# persist_with: gavlook_default_datagroup

explore: events {
#   conditionally_filter: {
#     filters: {
#       field: created_date
#       value: "this month"
#     }
#     unless: [created_date]
#   }
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

 explore: order_items {
  sql_always_where: {% parameter order_items.returned_status %} ;;

#   sql_always_where: {% assign other_date = order_items.date_filter date_start | date: '%s' %}
#   {% assign pre_date = '2017-07-23' | date: '%s' %}
#   TIMESTAMP_TRUNC({{ pre_date }}, MONTH)
#   ;;

# # explore: order_items {
#   sql_always_where: ${orders.created_date} >
#   {% date_start order_items.date_filter %}
#
#    ;;
# #
# #   sql_always_where: {% assign other_date = '2018-10-25' | date: '%s' %}
#   {% assign pre_date = {{order_items.date_filter date_start}} | date: '%s' %}
#   {% if other_date > pre_date %}
#   ${orders.created_date} > '2018-10-25'
#   {% else %}
#   1 = 1
#   {% endif %} ;;

  join: inventory_items {
    type: left_outer
    sql_on:
    ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${users.id} = (${orders.user_id})   ;;
    relationship: many_to_one
  }
}

explore: products {
    conditionally_filter: {
    filters: {
      field: category
      value: "jeans"
    }
    unless: [brand]
  }
}

explore: schema_migrations {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  sql_always_where: ${created_year} > "1990"  ;;
  always_filter: {
    filters: {
      field: state
      value: "New York"}
    }
  view_label: ""
}

explore: users_nn {}
