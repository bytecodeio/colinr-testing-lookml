view: vendor {
  sql_table_name: looker_scratch.vendor ;;

  dimension: id {
    primary_key: yes
    type: number
    description: "Unique identifier for each vendor"
    sql: ${TABLE}.`Vendor ID` ;;
  }

  dimension: name {
    type: string
    description: "Vendor name"
    sql: ${TABLE}.`Vendor Name` ;;
    tags: ["stackable"]
  }


  measure: topn_join_trigger {
    hidden: yes
    description: "Referenced when Top-N needs to join this view"
    type: number
    sql: 1 ;;
  }
}
