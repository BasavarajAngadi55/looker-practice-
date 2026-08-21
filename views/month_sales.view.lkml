view: month_sales {
  derived_table: {
    explore_source: order_items {
      column: created_month { field: order_items.created_month }
      column: total_sales   { field: order_items.total_sales }
    }
  }

  dimension: created_month {
    type: date_month
    sql: ${TABLE}.created_month ;;
  }

  dimension: total_sales {
    type: number
    value_format: "$#,##0.00"
    sql: ${TABLE}.total_sales ;;
  }

  # Fixed measure definition
  measure: average_monthly_sales {
    type: average
    sql: ${TABLE}.total_sales ;;
    value_format: "$#,##0.00"
  }
}
