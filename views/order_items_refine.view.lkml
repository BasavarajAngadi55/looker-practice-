include: "/views/order_items.view.lkml"

view: +order_items {
# --------------------------------------------------------------------
# REFINED & CUSTOM MEASURES
# --------------------------------------------------------------------
measure: total_sale_price {
  type: sum
  value_format_name: usd
  label: "Total Sale Price"
  description: "Total sales from items sold"
  sql: ${sale_price} ;;
}

}
