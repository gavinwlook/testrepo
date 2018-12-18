view: orders {
  sql_table_name: demo_db.orders ;;

parameter: date_parameter {
  type: date
}

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      week_of_year,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: new_lines {
    type: string
    sql:  ${user_id};;
    html:
    <summary style="outline:none"> User ID: {{ user_id._rendered_value }}
    </summary>Total: {{ count._rendered_value }}
    <summary style="outline:none"> Filtered Total: {{ filtered_count._rendered_value }}
    </summary> <br/>;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
#     html:  <p style="font-size:30px"> {{ value }} </p>;;
    drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
  }

#   dimension: name {
#     type: string
#     sql:  ${TABLE}.name ;;
#     html:   <font color="green">{{ value }}</font>;;
#   }



  measure: filtered_count {
    type: sum
    sql: CASE WHEN {% condition users.city_filter %} demo_db.users.city {% endcondition %} THEN 1 ELSE NULL END ;;
    drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
  }
}
