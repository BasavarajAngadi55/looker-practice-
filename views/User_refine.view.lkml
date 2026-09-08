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
  }
