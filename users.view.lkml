view: users {
  sql_table_name: demo_db.users ;;

  dimension: id {
    view_label: ""
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    view_label: ""
    type: number
    sql: ${TABLE}.age ;;
  }


  filter: city_filter {
    view_label: ""
    type: string
    suggest_dimension: city
  }

  dimension: city_satisfies_filter{
  type: yesno
  hidden: yes
  sql: {% condition city_filter %} ${city} {% endcondition %} ;;
  }

  measure: count_dynamic_city {
    type: count
    filters: {
      field: city_satisfies_filter
      value: "yes"
    }
  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
#     suggest_persist_for: "0 hours"
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    view_label: ""
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
