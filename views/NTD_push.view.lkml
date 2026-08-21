view: department_sales_dt {
  derived_table: {
    explore_source: order_items {
      column: total_sales {}
      column: department { field: products.department }
    }
  }

  dimension: department {
    primary_key: yes
    hidden: no
    type: string
  }

  dimension: total_sales {
    type: number
    value_format_name: usd
  }

  measure: avg_total_sales {
    type: average
    sql: ${total_sales} ;;
    value_format_name: usd
    description: "Average of total sales across departments"
  }
}
