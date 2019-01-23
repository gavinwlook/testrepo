# If necessary, uncomment the line below to include explore_source.
# include: "gavlook.model.lkml"

view: ndt_view {
  derived_table: {
    explore_source: orders {
      column: id {}
      column: status {}
      column: created_date {}
      column: tablecalc { field: calculation_1 }
    }
  }
  dimension: id {
    type: number
  }
  dimension: status {}
  dimension: created_date {
    type: date
  }
  dimension: calculation_1 {
    label: ""
    type: date
  }
}
