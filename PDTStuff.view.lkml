
view: pdtstuff {
   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql: SELECT
        state as state
        , avg(sale_price) as average_cost
       FROM demo_db.users u, demo_db.order_items oi, demo_db.orders o
      WHERE u.id = o.user_id and oi.order_id = o.id
       GROUP BY state       ;;
   }

#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
   dimension: customer_state {
    primary_key: yes
     description: "The state"
     type: string
     sql: ${TABLE}.state ;;
   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#

   measure: average_cost {
     description: "Use this for counting lifetime orders across many users"
     type: average
     sql: ${TABLE}.average_cost
    ;;
  }
 }
