include: "/views/order_items.view.lkml"

view: +order_items {

# --------------------------------------------------------------------
  # BUSINESS LOGIC & HELPER DIMENSIONS
  # --------------------------------------------------------------------
  dimension: is_completed {
    type: yesno
    description: "Completed sales excluding returns and cancellations"
    sql: ${status} NOT IN ('Cancelled', 'Returned') ;;
  }

  dimension: is_returned {
    type: yesno
    sql: ${status} = 'Returned' ;;
  }


# --------------------------------------------------------------------
# REFINED & CUSTOM MEASURES
# --------------------------------------------------------------------
measure: total_sale_price {
  type: sum
  value_format_name: usd
  label: "Total Sale Price"
  description: "Total sales from items sold"
  sql: ${sale_price} ;;
}


  measure: total_gross_revenue {
    type: sum
    value_format_name: usd
    label: "Total Gross Revenue"
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    sql: ${sale_price} ;;
    filters: [is_completed: "yes"]
  }

  measure: total_cost {
    type: sum
    sql: ${inventory_items.cost} ;;
    description: "Calculates the total cost of inventory items."
  }

  measure: total_gross_margin_amount {
    type: number
    value_format_name: usd
    label: "Total Gross Margin Amount"
    description: "Total difference between completed revenue and cost of goods sold"
    sql: ${total_gross_revenue} - ${total_cost} ;;
    drill_fields: [inventory_items.category, inventory_items.brand, total_gross_margin_amount]
  }

  measure: gross_margin_pct {
    type: number
    value_format_name: percent_2
    label: "Gross Margin %"
    description: "Total Gross Margin Amount / Total Gross Revenue"
    sql: 1.0 * ${total_gross_margin_amount} / NULLIF(${total_gross_revenue}, 0) ;;
  }

# Average Sale Price
  measure: average_sale_price {
    type: average
    value_format_name: usd
    label: "Average Sale Price"
    description: "Average sale price of items sold"
    sql: ${sale_price} ;;
  }

# Average Gross Margin
  measure: average_gross_margin {
    type: number
    value_format_name: usd
    label: "Average Gross Margin"
    description: "Average difference between total revenue from completed sales and cost of goods sold"
    sql: ${total_gross_margin_amount} / NULLIF(${total_gross_revenue}, 0) ;;
  }

# Cumulative Total Sales
  measure: cumulative_total_sales {
    type: running_total
    value_format_name: usd
    label: "Cumulative Total Sales"
    description: "Cumulative total sales from items sold"
    sql: ${total_sale_price} ;;
  }


# Total Cost
  measure: total_cost {
    type: sum
    value_format_name: usd
    label: "Total Cost"
    description: "Total cost of items sold from inventory"
    sql: ${inventory_items.cost} ;;
  }

# Average Cost
  measure: average_cost {
    type: average
    value_format_name: usd
    label: "Average Cost"
    description: "Average cost of items sold from inventory"
    sql: ${inventory_items.cost} ;;
  }

# Gross Margin %
  measure: gross_margin_pct {
    type: number
    value_format_name: percent_2
    label: "Gross Margin %"
    description: "Total Gross Margin Amount / Total Gross Revenue"
    sql: 1.0 * ${total_gross_margin_amount} / NULLIF(${total_gross_revenue}, 0) ;;
  }

# Number of Items Returned
  measure: number_of_items_returned {
    type: count
    label: "Number of Items Returned"
    description: "Number of items that were returned by dissatisfied customers"
    filters: [is_returned: "yes"]
  }
# Item Return Rate
  measure: item_return_rate {
    type: number
    value_format_name: percent_2
    label: "Item Return Rate"
    description: "Number of Items Returned / Total number of items sold"
    sql: 1.0 * ${number_of_items_returned} / NULLIF(${count}, 0) ;;
  }

}
