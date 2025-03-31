view: taxi_zone_lookup {
  sql_table_name: looker_scratch.pickup ;;

  dimension: borough {
    type: string
    description: "Corresponding Borough"
    sql: `${TABLE}.Pick Up Borough` ;;
    tags: ["stackable"]
  }

  dimension: location_id {
    type: number
    description: "TLC Zone ID"
    sql: cast(`${TABLE}.Pick Up Location ID` as integer) ;;
  }

  dimension: service_zone {
    type: string
    description: "Service Zone"
    sql: `${TABLE}.Pick Up Service Zone` ;;
    tags: ["stackable"]
  }

  dimension: zone {
    type: string
    description: "Zone name"
    sql: `${TABLE}.Pick Up Zone` ;;
    tags: ["stackable"]
  }

  measure: topn_join_trigger {
    hidden: yes
    description: "Referenced when Top-N needs to join this view"
    type: number
    sql: 1 ;;
  }
}
