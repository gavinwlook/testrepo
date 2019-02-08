
  dimension: sku_num {
    type: number
    sql: case when '% liquid_variable %' = 'yes' then 'yes' end
    
    ;;
  }



dimension: age {
    type: number
    sql: case when ${TABLE}.AGE = "20" then ${TABLE}.AGE
      else "wrong age";;
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
