connection: "looker_partner_demo"

# Include base views and refinement view
include: "/views/*.view.lkml"

# Define Datagroup
datagroup: order_items_default_datagroup {
  max_cache_age: "1 hour"
}

persist_with: order_items_default_datagroup

# Explore Definition
explore: order_items {
  label: "Order Items"
}
