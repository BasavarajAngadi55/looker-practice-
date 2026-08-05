connection: "looker_partner_demo"

include: "/views/*.view.lkml"

# ------------------------------------------------------------------
# 1. CACHING POLICY
# ------------------------------------------------------------------
datagroup: looker_partner_demo_default_datagroup {
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "24 hours"
}

persist_with: looker_partner_demo_default_datagroup

# ------------------------------------------------------------------
# 2. VIEW REFINEMENTS (NEW MEASURES & DIMENSIONS)
# ------------------------------------------------------------------
view: +order_items {
  measure: average_sale_price {
    label: "Average Order Value (AOV)"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }


  dimension: days_since_created {
    label: "Days Since Order"
    type: number
    sql: DATE_DIFF(CURRENT_DATE(), DATE(${created_date}), DAY) ;;
  }
}

view: +users {
  measure: total_users {
    label: "Total Users"
    type: count_distinct
    sql: ${id} ;;
  }
}

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

explore: users {
  label: "Users"
  description: "Customer demographic profiles and user-level analysis."
  group_label: "E-Commerce"
}
