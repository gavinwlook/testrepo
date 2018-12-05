view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  # {% assign today_date = 'now' | date: '%s' %}
# {% assign pre_date = product.metafields.Release-Date.preOrder | date: '%s' %}
# {% if today_date > pre_date %}

filter: date_filter {
  type: date
}


  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }
}
