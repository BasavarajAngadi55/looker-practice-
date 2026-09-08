connection: "looker_partner_demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
include: "/**/*.view.lkml"                 # include all views in this project



# --------------------------------------------------------------------
# EXPLORE: ORDER ITEMS (Primary transactional explore)
# --------------------------------------------------------------------
explore: order_items {
  label: "Order Items"
  description: "Detailed transactional Explore for analyzing orders, sales, revenue, margins, and brand/product metrics."
join: inventory_items {
  type: left_outer
  sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  relationship: many_to_one
}
join: users {
  type: left_outer
  sql_on: ${order_items.user_id}=${users.id} ;;
 relationship: many_to_one
}
}

# --------------------------------------------------------------------
# EXPLORE: CUSTOMERS (User behavior explore)
# --------------------------------------------------------------------
  explore: customers {
    from: users
    label: "Customers"
    description: "Customer-centric Explore focused on demographics, acquisition, retention, and lifetime spend."

    join: order_items {
      type: left_outer
      relationship: one_to_many
      sql_on: ${customers.id} = ${order_items.user_id} ;;
    }

    join: inventory_items {
      type: left_outer
      relationship: many_to_one
      sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    }
}
