
view: genius_view {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
  user_category_orders.user_id  AS `user_id`,
  GROUP_CONCAT(DISTINCT user_category_orders.category  ORDER BY user_category_orders.category   SEPARATOR '|RECORD|' ) AS `purchased_category_list`
FROM demo_db.order_items  AS order_items
LEFT JOIN ${orders.SQL_TABLE_NAME},  AS orders ON order_items.order_id = orders.id
LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id
LEFT JOIN ${user_category_orders.SQL_TABLE_NAME} AS user_category_orders ON user_category_orders.user_id = users.id

WHERE
  (((users.created_at ) >= ((CONVERT_TZ(TIMESTAMP(DATE_FORMAT(DATE(CONVERT_TZ(NOW(),'UTC','America/New_York')),'%Y-01-01')),'America/New_York','UTC'))) AND (users.created_at ) < ((CONVERT_TZ(DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(CONVERT_TZ(NOW(),'UTC','America/New_York')),'%Y-01-01')),INTERVAL 1 year),'America/New_York','UTC')))))
GROUP BY 1
ORDER BY user_category_orders.user_id
LIMIT 500
      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: filterable_list {
    type: string
    sql: ${TABLE}.purchased_category_list ;;
  }
}
