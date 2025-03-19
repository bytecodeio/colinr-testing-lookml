view: taxi_zone_lookup {
  sql_table_name: dbo.taxi_zone_lookup ;;

  dimension: borough {
    type: string
    description: "Corresponding Borough"
    sql: ${TABLE}.["Borough"] ;;
    tags: ["stackable"]
  }

  dimension: location_id {
    type: number
    description: "TLC Zone ID"
    sql: cast(${TABLE}.["LocationID"] as integer) ;;
  }

  dimension: service_zone {
    type: string
    description: "Service Zone"
    sql: ${TABLE}.["service_zone"] ;;
    tags: ["stackable"]
  }

  dimension: zone {
    type: string
    description: "Zone name"
    sql: ${TABLE}.["Zone"] ;;
    tags: ["stackable"]
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: topn_join_trigger {
    hidden: yes
    description: "Referenced when Top-N needs to join this view"
    type: number
    sql: 1 ;;
  }
}
