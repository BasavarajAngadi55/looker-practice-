connection: "looker_partner_demo"

include: "/**/*.view.lkml" # include all views in this project

explore: order_items {

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.id} ;;
  }
}
