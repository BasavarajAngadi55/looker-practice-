connection: "looker_partner_demo"

# Include base views and refinement view
include: "/views/*.view.lkml"
include: "/**/*.dashboard.lookml"

# Define Datagroup
datagroup: order_items_default_datagroup {
  max_cache_age: "1 hour"
}

persist_with: order_items_default_datagroup

explore: order_items {
  label: "Order Items"

  access_filter: {
    field: order_items.created_year
    user_attribute: test67
  }

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }
}
