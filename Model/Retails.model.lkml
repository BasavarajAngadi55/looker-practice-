connection: "looker_partner_demo"

include: "/**/*.view.lkml"

explore: order_items {

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.product_id} = ${products.id} ;;
  }

  join: month_sales {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.created_month} = ${month_sales.created_month} ;;
  }


}
