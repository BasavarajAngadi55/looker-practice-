include: "/views/order_items.view.lkml"

view: +order_items {

  # 1. User Filter Picker
  filter: selected_date {
    type: date
    description: "Select a date to calculate YTD sales up to that date"
  }

  # 2. Extract Month Name/Number (Jan–Dec)
  dimension: month_name {
    type: string
    sql: FORMAT_DATE('%b', ${created_raw}) ;;
    order_by_field: month_num
  }

  dimension: month_num {
    type: number
    sql: EXTRACT(MONTH FROM ${created_raw}) ;;
    hidden: yes
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  # 3. YTD Sales (Returns NULL instead of $0.00 for excluded dates)
  measure: dynamic_ytd_sales {
    type: number
    sql: SUM(
      CASE
        WHEN ${created_raw} >= TIMESTAMP(DATE_TRUNC(DATE({% date_start selected_date %}), YEAR))
         AND ${created_raw} <= TIMESTAMP({% date_end selected_date %})
        THEN ${sale_price}
        ELSE NULL
      END
    ) ;;
    value_format_name: usd
  }

}
