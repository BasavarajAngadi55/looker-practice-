---
- dashboard: top_10_
  title: 'top 10 '
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: vy5E8iIxwuMnHpEN8JlVxT
  theme_name: ''
  layout_granularity: granular
  layout: newspaper
  tabs:
  - name: ''
    label: ''
  elements:
  - title: 'top 10 '
    name: 'top 10 '
    model: temp
    explore: order_items
    type: looker_line
    fields: [order_items.created_month, order_items.total_sales]
    fill_fields: [order_items.created_month]
    filters:
      order_items.select_target_date: 2026/08/04
      order_items.created_year: 11 months
    sorts: [order_items.created_month desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Select Target Date for MTD: order_items.select_target_date
      Created Year: order_items.created_year
    row: 0
    col: 0
    width: 72
    height: 24
    tab_name: ''
  filters:
  - name: Select Target Date for MTD
    title: Select Target Date for MTD
    type: field_filter
    default_value: 2026/08/04
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: temp
    explore: order_items
    listens_to_filters: []
    field: order_items.select_target_date
  - name: Created Year
    title: Created Year
    type: field_filter
    default_value: 11 months
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: temp
    explore: order_items
    listens_to_filters: []
    field: order_items.created_year
