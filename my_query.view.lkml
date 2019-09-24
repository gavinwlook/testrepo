view: my_query {
  derived_table: {
    sql: select count(*), city, users.id, orders.status
      from users, orders
      where users.id = orders.user_id
      group by city, users.id, orders.status
      having count(*) > 10
       ;;
  }

  measure: count {
    sql: ${TABLE}.`count(*)` ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  set: detail {
    fields: [count, city, id, status]
  }
}
