include: "/views/order_items.view.lkml"

view: +order_items {
  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    description: "Sum of total sales amount for order items"
  }

  measure: average_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    description: "Average sales amount per order item"
  }
}
