view: explore_source {
    derived_table: {
      explore_source: orders {
        column: age { field: users.age }
        column: id {}
        column: user_id {}
        column: first_name { field: users.first_name }
        column: gender { field: users.gender }
      }
    }
    dimension: age {
      label: "Age"
      type: number
    }
    dimension: id {}
    dimension: user_id {
      type: number
    }
    dimension: first_name {}
    dimension: gender {}
  }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
