# If necessary, uncomment the line below to include explore_source.
# include: "Retails.model.lkml"

view: month_sales {
  derived_table: {
    explore_source: order_items {
      column: created_month {}
      column: total_sales {}
    }
  }

  dimension: created_month {
    description: ""
    type: date_month
  }

  dimension: total_sales {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }

  measure: average_monthly_sales {
    type: average
    hidden: no
    sql: ${total_sales} ;;
    value_format: "$#,##0.00"
  }
}
