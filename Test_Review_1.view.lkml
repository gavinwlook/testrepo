# Warning! This is auto-generated SQL & LookML, generated by csv-sql.web.app.
# Doublecheck the dimensions and their datatypes and adjust where necessary.

# explore: csv_to_sql_query {}

view: Test_Review_1 {
  derived_table: {
    sql:
      SELECT
        '25-05-2019' AS date, 'AAA' AS _location, 15 AS _beds
      UNION ALL
      SELECT
        '25-05-2019' AS date, 'BBB' AS _location, 25 AS _beds
      UNION ALL
      SELECT
        '25-05-2019' AS date, 'CCC' AS _location, 35 AS _beds

      ;;
  }

dimension: case_when_Location {
  type: string
  case: {
    when: {
    sql: ${_location} = 'AAA' ;;
    label: "AAA"}
    when: {
      sql: ${_location} = 'BBB' ;;
      label: "BBB"}
    when: {
      sql: ${_location} = 'CCC' ;;
      label: "CCC"}

  }


  # sql: case when ${_location} = 'AAA' then 'AAA'
  #         when ${_location} = 'BBB' then 'BBB'
  #         when ${_location} = 'CCC' then 'CCC'
  #         end;;
}

  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }

  measure: date_measure {
    type: min
    sql: STR_TO_DATE(${TABLE}.date,'%d - %m - %Y') ;;
  }


  dimension: _location {
    type: string
    sql: ${TABLE}._location ;;
  }

  dimension: _beds {
    type: number
    sql: ${TABLE}._beds ;;
  }

  measure: total_beds {
    type: sum
    sql: ${_beds} ;;
  }

  measure: count {
    type: count
  }
}
