include: "/views/order_items.view.lkml"

view: +order_items {

  # 1. GLOBAL DATE FILTER
  filter: selected_date {
    type: date
    description: "Global Date Filter for Dashboard Tiles & Top N Ranking"
  }

  dimension: month_name {
    type: string
    sql: FORMAT_DATE('%b', ${created_raw}) ;;
    order_by_field: month_num
  }

  dimension: month_num {
    type: number
    sql: EXTRACT(MONTH FROM ${created_raw}) ;;
    hidden: yes
  }

  # 2. FAILSAFE BASE MEASURES (Direct BigQuery Coalesce Logic)
  measure: dynamic_ytd_sales {
    hidden: yes
    type: number
    sql: SUM(
      CASE
        WHEN ${created_raw} >= TIMESTAMP(DATE_TRUNC(DATE(COALESCE({% date_start selected_date %}, '1970-01-01')), YEAR))
         AND ${created_raw} <= COALESCE({% date_end selected_date %}, TIMESTAMP('2099-12-31'))
        THEN ${sale_price}
        ELSE NULL
      END
    ) ;;
    value_format_name: usd
  }

  measure: dynamic_ytd_count {
    hidden: yes
    type: number
    sql: COUNT(
      CASE
        WHEN ${created_raw} >= TIMESTAMP(DATE_TRUNC(DATE(COALESCE({% date_start selected_date %}, '1970-01-01')), YEAR))
         AND ${created_raw} <= COALESCE({% date_end selected_date %}, TIMESTAMP('2099-12-31'))
        THEN ${id}
        ELSE NULL
      END
    ) ;;
    value_format_name: decimal_0
  }

  # 3. METRIC SELECTOR PARAMETER
  parameter: brand_rank_measure_selection {
    view_label: "TOTT - Top N Ranking"
    description: "Global Metric Switcher for Dashboard Tiles & NDT Ranking"
    type: unquoted
    default_value: "order_items_sales_price"

    allowed_value: {
      label: "Order Items Total Sales"
      value: "order_items_sales_price"
    }
    allowed_value: {
      label: "Order Items Count"
      value: "order_items_count"
    }
  }

  # 4. SINGLE DYNAMIC MEASURE (Robust Liquid Matching for Unquoted Parameters)
  measure: dynamic_measure {
    view_label: "TOTT - Top N Ranking"
    label_from_parameter: brand_rank_measure_selection
    type: number
    sql:
      {% assign selected_metric = brand_rank_measure_selection._parameter_value | string %}
      {% if selected_metric contains 'order_items_count' %}
        ${dynamic_ytd_count}
      {% else %}
        ${dynamic_ytd_sales}
      {% endif %} ;;

    html:
      {% assign selected_metric = brand_rank_measure_selection._parameter_value | string %}
      {% if selected_metric contains 'order_items_count' %}
        {{ dynamic_ytd_count._rendered_value }}
      {% else %}
        {{ dynamic_ytd_sales._rendered_value }}
      {% endif %} ;;
  }
}
