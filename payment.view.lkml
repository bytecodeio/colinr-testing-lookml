view: payment {
  sql_table_name: dbo.nyc_payment ;;

  dimension: id {
    primary_key: yes
    type: number
    description: "Unique identifier for each payment"
    sql: ${TABLE}.ID ;;
  }

  dimension: type {
    type: string
    description: "Payment type"
    sql: ${TABLE}.Type ;;
    tags: ["stackable"]
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  measure: topn_join_trigger {
    hidden: yes
    description: "Referenced when Top-N needs to join this view"
    type: number
    sql: 1 ;;
  }
}
