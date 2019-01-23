view: users {
  sql_table_name: demo_db.users ;;

  parameter: granularity_selector {
    view_label: "Orders"
  allowed_value: {
    label: "Quarterly"
    value: "quarter"
  }
  allowed_value: {
    label: "Monthly"
    value: "monthly"
  }
  }

dimension: date_granularity {
     label_from_parameter: granularity_selector
     sql:
       CASE
         WHEN {% parameter granularity_selector %} = 'monthly' THEN
           ${created_month}
         WHEN {% parameter granularity_selector %} = 'quarter' THEN
           ${created_quarter}
         ELSE
           NULL
       END ;;
 }


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
     suggest_persist_for: "0 hours"
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
    value_format_name: decimal_3
  }

  measure: test_count {
    type: count_distinct
    sql:  (select ${city} where ${state} = "New York") ;;
  }

  measure: test_count2 {
    type: count_distinct
    sql:  ${city} ;;
  }


  measure: count_male {
    view_label: ""
    sql: (select count(distinct id) from demo_db.users where gender = 'm') ;;
    type: number
    drill_fields: [detail*]
    value_format_name: decimal_3
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
