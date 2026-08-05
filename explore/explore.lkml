include: "/views/*.view.lkml"
# ------------------------------------------------------------------
# 3. EXPLORES
# ------------------------------------------------------------------
explore: order_items {
  label: "Order Items"
  description: "Primary explore for order line items, sales performance, and customer analytics."
  group_label: "E-Commerce"

  conditionally_filter: {
    filters: [order_items.created_date: "30 days"]
    unless: [order_items.created_date, order_items.select_date]
  }

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
    view_label: "Customers"
  }
}
