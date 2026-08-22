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

  join: ndt_top_ranking {
    view_label: "TOTT - Top N Ranking"
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.brand} = ${ndt_top_ranking.brand_name} ;;
  }
}
