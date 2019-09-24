
view: orders_cost {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    persist_for: "30000000 hours"
    sql: SELECT
  inventory_items.cost  AS `cost`,
  DATE(orders.created_at ) AS `created_date`,
  case when orders.status is not null
      then orders.status
      else "No status"
      end AS `status2`,
  users.age  AS `age`,
  users.country  AS `country`
FROM demo_db.orders  AS orders
LEFT JOIN demo_db.users  AS users ON users.id = (orders.user_id)
LEFT JOIN demo_db.inventory_items  AS inventory_items ON inventory_items.id = orders.id
WHERE {% condition order_date %} orders.created_at {% endcondition %}
GROUP BY 1,2,3,4,5
ORDER BY DATE(orders.created_at ) DESC
      ;;
  }

  filter: order_date {
    type: date
    default_value: "this quarter"
  }



  parameter: date_format {
    type: unquoted
    allowed_value: {value: "usa"
        label:"USA"}
    allowed_value: {value: "eu"
      label: "EU"
    }
  }

  dimension: status {
    description: "The total number of orders for each user"
    type: string

    sql: ${TABLE}.status2 ;;
    suggestions: ["Pending", "Complete", "Cancelled"]
  }

  dimension_group: order_created {
    description: "The date when each user last ordered"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.created_date ;;
    html: {% if date_format._parameter_value == 'usa' %} {{ rendered_value | date: "%m/%d/%Y" }} {% else %} {{ rendered_value | date: "%d/%m/%Y" }} {% endif %} ;;
  }

#   dimension: date_formatted {
#     sql: ${created_date} ;;
#     html: {{ rendered_value | date: "%b %d, %y" }} ;;
#   }


dimension: country {
  type: string
  sql: ${TABLE}.country ;;
}

dimension: cost {
  type: number
  sql: ${TABLE}.cost ;;
}

  measure: total_cost {
    description: "Use this for counting lifetime orders across many users"
    type: sum
    sql: ${cost} ;;
  }
}
