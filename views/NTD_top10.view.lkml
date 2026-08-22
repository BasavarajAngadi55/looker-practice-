view: ndt_top_ranking {
  derived_table: {
    explore_source: order_items {
      bind_all_filters: yes
      column: brand_name { field: products.brand }
      column: order_items_count { field: order_items.count }
      # Update field name to match your actual measure in order_items.view
      column: order_items_sales_price { field: order_items.total_sales }

      derived_column: ranking {
        # Reference the alias 'order_items_sales_price', NOT 'order_items.total_sales'
        sql: RANK() OVER (ORDER BY order_items_sales_price DESC) ;;
      }
    }
  }

  dimension: brand_name {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.brand_name ;;
  }

  dimension: brand_rank {
    hidden: yes
    type: number # Changed from string to number for arithmetic comparisons
    sql: ${TABLE}.ranking ;;
  }

  parameter: top_n_limit {
    type: unquoted
    label: "Top N Selection"
    description: "Select how many top brands to show individually"
    default_value: "10"

    allowed_value: { label: "Top 5"   value: "5" }
    allowed_value: { label: "Top 10"  value: "10" }
    allowed_value: { label: "Top 20"  value: "20" }
    allowed_value: { label: "Top 50"  value: "50" }
  }

  dimension: brand_rank_top_brands {
    hidden: no # Unhidden so users can select it in Explore
    type: string
    label_from_parameter: top_n_limit # Fixed parameter name
    sql:
      CASE
        WHEN ${brand_rank} <= CAST({% parameter top_n_limit %} AS INT64)
        THEN ${brand_name}
        ELSE 'Other'
      END ;;
    order_by_field: dynamic_user_rank_sort
  }

  dimension: dynamic_user_rank_sort {
    type: string
    hidden: yes
    sql:
      CASE
        WHEN ${brand_rank} <= CAST({% parameter top_n_limit %} AS INT64)
        THEN LPAD(CAST(${brand_rank} AS STRING), 5, '0')
        ELSE '99999'
      END ;;
  }

  parameter: brand_rank_measure_selection {
    view_label: "TOTT | Top N Ranking"
    description: "Specify which metric to rank Brands by"
    type: unquoted
    default_value: "order_items_count"

    allowed_value: {
      label: "Order Items Count"
      value: "order_items_count"
    }
    allowed_value: {
      label: "Order Items Total Sales"
      value: "order_items_sales_price"
    }
  }

  measure: dynamic_measure {
    view_label: "TOTT | Top N Ranking"
    label_from_parameter: brand_rank_measure_selection
    type: number
    sql:
      {% if brand_rank_measure_selection._parameter_value == 'order_items_sales_price' %}
        ${order_items.total_sales}
      {% else %}
        ${order_items.count}
      {% endif %} ;;

    html:
      {% if brand_rank_measure_selection._parameter_value == 'order_items_sales_price' %}
        {{ order_items.total_sales._rendered_value }}
      {% else %}
        {{ order_items.count._rendered_value }}
      {% endif %} ;;
  }


}
