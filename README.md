connection: "mssql_2008"

# include all the views
include: "*.view"

datagroup: thelook_felix_mssql_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: thelook_felix_mssql_default_datagroup

datagroup: the_look_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: the_look_default_datagroup

explore: order_items {

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}



explore: users {
  join: orders {
    type:  left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: one_to_many
  }

}

explore: pegdatetest {}
