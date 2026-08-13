connection: "looker_partner_demo"

# Include base views and refinement view
include: "/views/*.view.lkml"
include: "/**/*.dashboard.lookml"

# Define Datagroup
datagroup: order_items_default_datagroup {
  max_cache_age: "1 hour"
}

persist_with: order_items_default_datagroup

# Explore Definition
explore: order_items {
  label: "Order Items"

  access_filter: {
    field: order_items.created_year  # <-- Replace 'created_year' with your actual year dimension name
    user_attribute: test67
  }
}
