view: ndt_top_ranking {

  derived_table: {
    explore_source: order_items {

      # Bind BOTH global dashboard controls into the NDT subquery
      bind_filters: {
        to_field: order_items.selected_date
        from_field: order_items.selected_date
      }
      bind_filters: {
        to_field: order_items.brand_rank_measure_selection
        from_field: order_items.brand_rank_measure_selection
      }

      column: brand_name { field: products.brand }
      column: dynamic_metric { field: order_items.dynamic_measure }

      derived_column: ranking {
        sql: RANK() OVER (ORDER BY dynamic_metric DESC) ;;
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
    type: number
    sql: ${TABLE}.ranking ;;
  }

  parameter: top_n_limit {
    type: unquoted
    description: "Select how many top brands to show individually"
    default_value: "10"

    allowed_value: { label: "Top 5"   value: "5" }
    allowed_value: { label: "Top 10"  value: "10" }
    allowed_value: { label: "Top 20"  value: "20" }
    allowed_value: { label: "Top 50"  value: "50" }
  }

  dimension: brand_rank_top_brands {
    hidden: no
    type: string
    label_from_parameter: top_n_limit
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
}
