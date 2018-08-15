
view: customerfacts {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    persist_for: "24 hours"
    indexes: ["user_id"]
    sql: SELECT
    first_name,
    last_name,
    user_id,
    count(o.id) as total_orders,
    state,
    count(distinct u.zip) as number_of_zips,
    status,
    sum(sale_price) as total_cost,
    (select sum(case when status = 'complete' then 1 else 0 end)) as complete_orders,
    (select sum(case when status <> 'complete' then 1 else 0 end)) as incomplete_orders,
    avg(sale_price) as average_cost,
    count(oi.id) as total_items,
    (select count(returned_at) where returned_at is not null) as number_returned
    FROM demo_db.users u, demo_db.order_items oi, demo_db.orders o
    WHERE u.id = o.user_id and oi.order_id = o.id
    GROUP BY user_id
      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    primary_key: yes
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: customer_name  {
    description: "Total orders for this customer"
    type: string
    sql:  CONCAT(${TABLE}.first_name, ' ', ${TABLE}.last_name) ;;
  }

   dimension: lifetime_orders {
     description: "The total number of orders for each user"
     type: number
     sql: ${TABLE}.total_orders ;;
    # c. The number of orders they’ve placed
   }

  dimension: customer_has_moved {
    description: "Has the customer had more than one address"
    type: yesno
    sql: ${TABLE}.number_of_zips > 1;;
    # a. A yesno reflecting if they’ve moved (have multiple addresses on file)

  }

    measure: total_cost {
    description: "Total cost of orders"
    type: sum
    sql: ${TABLE}.total_cost ;;
    # b. The total amount they’ve spent
  }

  dimension: average_cost {
    description: "Average cost of orders"
    type: number
    sql: ${TABLE}.average_cost ;;
    # e. The average Price of items ordered
  }

  dimension: completed_orders {
    description: "Amount of completed orders"
    type: number
    sql: ${TABLE}.complete_orders ;;
    # f.  Amount of completed orders
  }

  dimension: pending_orders {
    description: "Amount of pending orders"
    type: number
    sql: ${TABLE}.incomplete_orders ;;
    # g. Amount of pending orders
  }


  dimension: average_number_of_items {
    description: "The average number of items per order"
    type: number
    sql: ${TABLE}.total_items/total_orders ;;
    value_format_name: decimal_1
    # d. The average number of items per order
  }

  dimension: percentage_returned_orders{
    description: "Percentage of orders returned by customer"
    type: number
    value_format_name: percent_0
    sql: ${TABLE}.number_returned/${TABLE}.complete_orders ;;
    # g. Any other fun user facts you can think of!
  }

#   measure: completed_orders {
#     description: "Amount of completed orders"
#     type: sum
#     sql: ${TABLE}.status = 'complete' ;;
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
}

# a. A yesno reflecting if they’ve moved (have multiple addresses on file)
# b. The total amount they’ve spent
# c. The number of orders they’ve placed
# d. The average number of items per order
# e. The average Price of items ordered
# f.  Amount of completed orders
# g. Amount of pending orders
# g. Any other fun user facts you can think of!
#    count(case when status <> 'complete') as incomplete_orders,
#    count(case when status = 'complete') as complete_orders,
