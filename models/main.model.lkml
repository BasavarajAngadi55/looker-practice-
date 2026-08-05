connection: "looker_partner_demo"

include: "/views/*.view.lkml"

# ------------------------------------------------------------------
# 1. CACHING POLICY (DATAGROUP)
# ------------------------------------------------------------------
datagroup: looker_partner_demo_default_datagroup {
  # Refreshes cache daily at midnight
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "24 hours"
}

# Apply default caching to all explores in this model
persist_with: looker_partner_demo_default_datagroup

# ------------------------------------------------------------------
# 2. EXPLORES
# ------------------------------------------------------------------
explore: order_items {
  label: "Order Items"
  description: "Primary explore for order line items, sales performance, and customer analytics."
  group_label: "E-Commerce"

  # Prevents runaway queries by defaulting to a 30-day window if no date filter is applied
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

explore: users {
  label: "Users"
  description: "Customer demographic profiles and user-level analysis."
  group_label: "E-Commerce"
}
