include: "/views/users.view.lkml"

view: +users {
# Custom Demographics: Age Tiers
  dimension: age_tier {
    type: tier
    tiers: [15, 26, 36, 51, 66]
    style: integer
    label: "Age Group"
    description: "Categorizes users into target age brackets: 15-25, 26-35, 36-50, 51-65, 66+"
    sql: ${age} ;;
  }

# New Customer Behavior Tier
  dimension: user_recency_cohort {
    type: string
    label: "User Cohort (New vs Repeat)"
    description: "Identifies whether a customer signed up within the last 90 days or prior"
    sql: CASE
          WHEN ${created_raw} >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY) THEN 'New Customer (<= 90 Days)'
          ELSE 'Existing Customer (> 90 Days)'
         END ;;
  }

# --------------------------------------------------------------------
  # MEASURES
  # --------------------------------------------------------------------



  measure: number_of_customers_returning_items {
    type: count_distinct
    label: "Number of Customers Returning Items"
    description: "Number of unique users who have returned an item"
    sql: ${TABLE}.id ;;
    filters: [order_items.is_returned: "yes"]
  }

  measure: pct_of_users_with_returns {
    type: number
    value_format_name: percent_2
    label: "% of Users with Returns"
    description: "Number of Customers Returning Items / Total number of customers"
    sql: 1.0 * ${number_of_customers_returning_items} / NULLIF(${count}, 0) ;;
  }

  measure: average_spend_per_customer {
    type: number
    value_format_name: usd
    label: "Average Spend per Customer"
    description: "Total Sale Price / Total number of customers"
    sql: ${order_items.total_sale_price} / NULLIF(${count}, 0) ;;
    drill_fields: [age_tier, gender, count, order_items.total_sale_price]
  }




    # --------------------------------------------------------------------
    # COHORT DIMENSIONS & CALCULATED FIELDS
    # --------------------------------------------------------------------

    # Days Since Signup
    dimension: days_since_signup {
      type: number
      label: "Days Since Signup"
      description: "Number of days since a customer signed up on the website"
      sql: DATE_DIFF(CURRENT_DATE(), DATE(${created_raw}), DAY) ;;
    }

    # Months Since Signup
    dimension: months_since_signup {
      type: number
      label: "Months Since Signup"
      description: "Number of months since a customer signed up on the website"
      sql: DATE_DIFF(CURRENT_DATE(), DATE(${created_raw}), MONTH) ;;
    }

    # Months Between Signup & Order (For Retention / Drop-off Tracking)
    dimension: months_since_signup_at_order {
      type: number
      label: "Months Between Signup & Order"
      description: "Number of months between user signup date and order created date"
      sql: DATE_DIFF(DATE(${order_items.created_date}), DATE(${created_raw}), MONTH) ;;
    }

    # --------------------------------------------------------------------
    # COHORT MEASURES
    # --------------------------------------------------------------------

    # Average Number of Days Since Signup
    measure: average_days_since_signup {
      type: average
      value_format_name: decimal_1
      label: "Average Days Since Signup"
      description: "Average number of days between customer registration and today"
      sql: ${days_since_signup} ;;
    }

    # Average Number of Months Since Signup
    measure: average_months_since_signup {
      type: average
      value_format_name: decimal_1
      label: "Average Months Since Signup"
      description: "Average number of months between customer registration and today"
      sql: ${months_since_signup} ;;
    }

    # Active Purchasing Users Count (Helper for Retention Rate)
    measure: active_purchasing_users {
      type: count_distinct
      label: "Active Purchasing Users"
      description: "Distinct count of users who placed an order"
      sql: ${id} ;;
      filters: [order_items.id: "NOT NULL"]
    }

    # Cohort Retention Rate %
    measure: cohort_retention_rate {
      type: number
      value_format_name: percent_2
      label: "Cohort Retention Rate %"
      description: "Proportion of initial cohort users still purchasing"
      sql: 1.0 * ${active_purchasing_users} / NULLIF(${count}, 0) ;;
    }
  }
