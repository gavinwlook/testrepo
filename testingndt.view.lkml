# If necessary, uncomment the line below to include explore_source.
# include: "gavlook.model.lkml"

view: testingndt {
# If necessary, uncomment the line below to include explore_source.
# include: "gavlook.model.lkml"

    derived_table: {
      explore_source: orders {
        column: count { field: users.count }
        column: count_male { field: users.count_male }
        column: gender { field: users.gender }
        column: city { field: users.city }
        column: country { field: users.country }
        column: test_count { field: users.test_count }
        column: user_id {}
      }
    }
    dimension: count {
      label: "Count"
      value_format: "#,##0.000"
      type: number
    }
    dimension: count_male {
      label: "Count Male"
      value_format: "#,##0.000"
      type: number
    }
    dimension: gender {}
    dimension: city {}
    dimension: country {}
    dimension: test_count {
      type: number
    }
    dimension: user_id {
      type: number
    }

    measure: number_type {
      type: number
      sql: ${count_male} + ${count} ;;
    }

    measure: another_number {
      type: number
      sql: ${user_id} * ${count} ;;
      }

  }
