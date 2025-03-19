view: vendor {
  sql_table_name: dbo.nyc_vendor ;;

  dimension: id {
    primary_key: yes
    type: number
    description: "Unique identifier for each vendor"
    sql: ${TABLE}.ID ;;
  }

  dimension: name {
    type: string
    description: "Vendor name"
    sql: ${TABLE}.Name ;;
    tags: ["stackable"]
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }

  measure: topn_join_trigger {
    hidden: yes
    description: "Referenced when Top-N needs to join this view"
    type: number
    sql: 1 ;;
  }
}
