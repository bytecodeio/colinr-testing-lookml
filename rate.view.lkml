view: rate {
  sql_table_name: looker_scratch.rate ;;

  dimension: id {
    primary_key: yes
    type: number
    description: "Unique identifier for each rate"
    sql: ${TABLE}.ID ;;
  }

  dimension: description {
    type: string
    description: "Rate Description"
    sql: ${TABLE}.Description ;;
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
