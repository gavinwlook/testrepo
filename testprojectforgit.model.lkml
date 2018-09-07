connection: "postgres_local"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: testprojectforgit_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "36 hours"

}

persist_with: testprojectforgit_default_datagroup

explore: connection_reg_r3 {}

explore: ufo_data {}
