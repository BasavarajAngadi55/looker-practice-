include: "/views/order_items.view.lkml"

view: +order_items {

  # Date parameter for user selection (e.g., June 4)
  parameter: select_target_date {
    type: date
    label: "Select Target Date for MTD"
    description: "Filters days 1 through N for all months up to target date."
  }

  # Dynamic MTD boolean filter across YTD months
  dimension: is_mtd_day_range {
    type: yesno
    label: "Is Within MTD Day Range"
    sql:
      EXTRACT(DAY FROM ${created_raw}) <= EXTRACT(DAY FROM CAST({% parameter select_target_date %} AS DATE))
      AND ${created_raw} <= CAST({% parameter select_target_date %} AS DATE)
      AND EXTRACT(YEAR FROM ${created_raw}) = EXTRACT(YEAR FROM CAST({% parameter select_target_date %} AS DATE)) ;;
  }

  # Sales measure for visualization
  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

}
