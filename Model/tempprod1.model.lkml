connection: "looker_partner_demo"


# Include view files
include: "/views/*.view.lkml"

explore: order_items {
  label: "Order Items"

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.id} = ${users.id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.id} = ${products.id} ;;
  }
}
