view: user_monthly_stats {
  derived_table: {
    explore_source: order_items {
      column: created_month {}
      column: user_id { field: users.id }
      column: count_distinct_orders {}
      column: total_sale_price {}
    }
    datagroup_trigger: hourly_pdt_datagroup
  }

  # Composite primary key (User ID + Month)
  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(CAST(${TABLE}.user_id AS STRING), '-', CAST(${TABLE}.created_month AS STRING)) ;;
  }

  dimension: created_month {
    type: date_month
    sql: ${TABLE}.created_month ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: count_distinct_orders {
    type: number
    sql: ${TABLE}.count_distinct_orders ;;
  }

}
