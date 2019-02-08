    # hidden: yes
    sql: ${TABLE}.ORDER_ID ;;
  }
  dimension: sku_num { type: number sql: case when '% liquid_variable %' = 'yes' then 'yes' end

    ;;

  }
