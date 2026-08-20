include: "/views/order_items.view.lkml"

view: +order_items {

  measure: total_sale_price {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: average_sale_price {
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: count_distinct_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: count_distinct_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: min_sale_price {
    type: min
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: max_sale_price {
    type: max
    value_format_name: usd
    sql: ${sale_price} ;;
  }

}
