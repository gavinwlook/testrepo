view: orders {
  sql_table_name: demo_db.orders ;;



parameter: date_parameteeer {
  default_value: "15-jan-2018"
  type: date
}

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week,
      hour_of_day,
      week_of_year,
      month,
      month_name,
      quarter_of_year,
      quarter,
      fiscal_quarter,
      fiscal_quarter_of_year,
      fiscal_year,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

dimension: another_date {
  type: date_day_of_month
  sql: ${TABLE}.created_at ;;
}

dimension: another_date2 {
    type: date_month
    sql: ${TABLE}.created_at ;;
  }

  dimension: combo_date {
    type: string
    sql: cast(${another_date} as char)  + '-' + cast(${another_date2} as char) ;;
  }

  measure: subquery {
    type: number
    sql: (SELECT count(${user_id}, ${user_id} )
          FROM   ${TABLE}
         WHERE  users.gender = 'f'
        group by ${user_id});;
  }

  dimension: newdate {
    type: date
    sql: ${TABLE}.created_at ;;
    html: {{ rendered_value | date: "%e %b %Y" }} ;;
  }



  dimension: new_lines {
    type: string
    sql:  "placeholder";;
    html:
    <summary style="outline:none"> User ID: {{ user_id._rendered_value }}
    </summary>Total: {{ count._rendered_value }}
    <summary style="outline:none"> Filtered Total: {{ filtered_count._rendered_value }}
    </summary> <br/>;;
  }

  measure: status {
    type: number

    sql: {% if users.gender._in_query %} ${users.count}{% else %} ${count}{% endif %} ;;
  }

#   measure: status {
#     type: string
#
#     sql: {% if ${id}._in_query %} ${count} {% else %} ${users.gender} {% endif %} ;;
#   }

  dimension: status2 {
    type: string
    sql: case when ${TABLE}.status is not null
      then ${TABLE}.status
      else "No status"
      end;;
    html:
    <a href="/dashboards/2360?Status={{ value }}&Age={{ users.age._value }}&date={{ orders.created_date._filterable_value }}">{{ value }}</a> ;;

  }

  dimension: status3 {
    type: string
    sql: case when ${TABLE}.status is not null
      then ${TABLE}.status
      else "No status"
      end;;
    link: {
      label: "Drill to Explore"
      url:"https://master.dev.looker.com/explore/gavlook/orders?fields=inventory_items.cost,orders.created_date,orders.status2,orders.count,users.age,explore_source.gender,users.country&f[orders.created_date]={{ _filters['orders.created_date'] }}&f[users.age]={{ _filters['users.age'] }}&f[orders.status2]={{ value }}&vis=%7B%22type%22%3A%22table"
    }
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

  measure: before_today {
    type: count
    filters: {
      field: created_month
      value: "this month"
    }
    filters: {
      field: created_date
      value: "before today"
    }
  }

  filter: for_dimension {
    type: number
  }

dimension: from_filter {
  type: number
  sql: { % condition for_dimension % } 1
{ % endcondition % } ;;
}

  # EXTERNAL DEPENDENCY EXAMPLE

measure: ctr {
type: number
sql: ((sum(${user_id}) / ${inventory_items.id}*100);;
value_format: "0.00%"
}

  measure: filtered_count {
    type: sum
    sql_distinct_key: ${id} ;;
    sql: CASE WHEN {% condition users.city_filter %} demo_db.users.city {% endcondition %} THEN 1 ELSE NULL END ;;
    drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
  }


}
