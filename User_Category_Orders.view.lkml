 view: user_category_orders {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    persist_for: "24 hours"
    sql: SELECT
  users.id  AS `user_id`,
  products.category  AS `category`
FROM demo_db.order_items  AS order_items
LEFT JOIN demo_db.inventory_items  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
LEFT JOIN demo_db.products  AS products ON inventory_items.product_id = products.id
LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id

WHERE
  (((users.created_at ) >= ((CONVERT_TZ(TIMESTAMP(DATE_FORMAT(DATE(CONVERT_TZ(NOW(),'UTC','America/New_York')),'%Y-01-01')),'America/New_York','UTC'))) AND (users.created_at ) < ((CONVERT_TZ(DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(CONVERT_TZ(NOW(),'UTC','America/New_York')),'%Y-01-01')),INTERVAL 1 year),'America/New_York','UTC')))))
GROUP BY 1,2
ORDER BY users.id
      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    description: "Unique ID for each user that has ordered"
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: purchase_category {
    type: string
    sql: ${TABLE}.category ;;
  }

# dimension: string_list {
#   type: string
#   sql:  GROUP_CONCAT(DISTINCT ${purchase_category} ORDER BY user_category_orders.category   SEPARATOR '|RECORD|' ) ;;
# }

  measure: purchased_category_list {
    type: list
    list_field: purchase_category
  }


}
