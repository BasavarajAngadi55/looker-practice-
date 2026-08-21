connection: "looker_partner_demo"

include: "/**/*.view.lkml" # include all views in this project

explore: order_items {

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.id} ;;
  }

  join: products {
  type: left_outer
  relationship: many_to_one
  sql_on: ${order_items.product_id}=${products.id} ;;

  }

  join: department_sales_dt {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.department} = ${department_sales_dt.department} ;;
  }
}
