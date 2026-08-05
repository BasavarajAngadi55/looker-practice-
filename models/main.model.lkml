connection: "looker_partner_demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this


explore: order_items {
  label: "Order Items"

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }
}

explore: users {
  label: "Users"
}
