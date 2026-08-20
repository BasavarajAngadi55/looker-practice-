connection: "looker_partner_demo"

# Include view files
include: "/views/*.view.lkml"

# 1-Hour Refresh Trigger
datagroup: hourly_pdt_datagroup {
  max_cache_age: "1 hour"
  sql_trigger: SELECT TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), HOUR) ;;
}

explore: order_items {
  label: "Order Items"

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

  # Dual-condition join on User ID AND Month
  join: user_monthly_stats {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${user_monthly_stats.user_id}
      AND ${order_items.created_month} = ${user_monthly_stats.created_month} ;;
  }
}

# Refine the existing order_items explore
explore: +order_items {
  aggregate_table: monthly_product_sales_agg {
    query: {
      dimensions: [
        products.category,            # or products.name
        order_items.created_month
      ]
      measures: [
        order_items.total_sale_price
      ]

    }

    materialization: {
      datagroup_trigger: hourly_pdt_datagroup
    }
  }
}
