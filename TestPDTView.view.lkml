view: TestPDTView {
  derived_table: {
    sql:
      SELECT
      1997 AS year, NULL AS make, 'THIS HAS' AS model_name
      UNION ALL
      SELECT
      2000 AS year, 'Mercury' AS make, 'THIS jtjetjetet' AS model_name

      ;;
#       persist_for: "1 minutes"
      sql_trigger_value: SELECT MINUTE(CURTIME()) ;;

  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  dimension: make {
    type: string
    sql: ${TABLE}.make ;;
  }

  dimension: model_name {
    type: string
    sql: ${TABLE}.model_name ;;
  }

  measure: count {
    type: count
  }
}
