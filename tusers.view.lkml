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

parameter: date_parameter {
  type: date
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

dimension: is_new {
  type: yesno
  sql:  LOWER(SUBSTR(${state}, 1, 3) = 'new');;
}


  dimension: gender_full {
     type: string
    case: {
      when: {
          label: "female"
      }
      when: {
        sql: ${TABLE}.gender = "m" ;;
         label: "male"
      }
    }
    alpha_sort: yes
  }

  parameter: Checking_something{
    type: unquoted
    allowed_value: {
      label: "Includes everything"
      value: "1 = 1"
    }
    allowed_value: {
      label: "Excludes something"
      value: "users.id < 1000"
    }
  }

  dimension: id {
    primary_key: yes
    type: number
    # sql: ${TABLE}.id ;;
  }

  dimension: age {
    view_label: ""
    type: string
    sql: ${TABLE}.age ;;
  }


  filter: city_filter {
    view_label: ""
    type: string
    suggest_dimension: city
  }

#   dimension: city_satisfies_filter{
#   type: yesno
#   hidden: yes
#   sql: {% condition city_filter %} ${city} {% endcondition %} ;;
#   }

#   measure: count_dynamic_city {
#     type: count
#     filters: {
#       field: city_satisfies_filter
#       value: "yes"
#     }
#   }


  dimension: age_tier {
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80]
    style: classic # the default value, could be excluded
    sql: ${age} ;;
}


  measure: city {
    type: string
    sql: ${TABLE}.city ;;
#      suggest_persist_for: "0 hours"
  }

  measure: country {
    type: string
#     map_layer_name: countries
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
      month_name,
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

  measure: first_name1 {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  measure: last_name2 {
    type: string
    sql: ${TABLE}.last_name ;;
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
#     suggest_dimension: new_state
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: new_state {
    type: string
    sql: case when LOWER(SUBSTR(${state}, 1, 3) = 'new') THEN ${state}
    ELSE Null
    END
    ;;
  }

  dimension: new_country {
    type: string
    map_layer_name: countries
    sql:  case when ${state} = 'California' then 'Germany'
              when ${state} = 'Texas' then 'France'
              else 'Belgium' end;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    value_format: "#.##0.##"
  }

#   measure: test_count {
#     type: count_distinct
#     sql:  (select ${city} where ${state} = "New York") ;;
#   }

#   measure: test_count2 {
#     type: count_distinct
#     sql:  ${city} ;;
#   }


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
