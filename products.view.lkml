view: products {
  sql_table_name: demo_db.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  parameter: geo_polygon {
    default_value: ""
    description: "Use this for filtering users based on filtering dimensions, requires this format: [[0.0], [0.0]], use geojson.io to generate a valid polygon"
    type: string
  }

  dimension: is_last_location_in_polygon {
    type: yesno
    sql:  {% parameter geo_polygon %} ;;
  }


  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

measure: count_jeans {
  type: sum
  sql:  case when ${category} = "Jeans" then 1
        else 0
        end;;
}

  dimension: sub_true_false {
    type: yesno
    sql: ${category} in ( select ${category} from ${TABLE} where ${category} = 'Jeans') ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: average_price {
    type:  average
    value_format: "##0.00"
    sql: ${retail_price} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }
}
