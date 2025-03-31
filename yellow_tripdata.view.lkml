view: yellow_tripdata_base {
  derived_table: {
    sql: SELECT
    CONCAT(
        FORMAT_TIMESTAMP('%Y%m%d%H%M%S', pickup_datetime), '_',
        FORMAT_TIMESTAMP('%Y%m%d%H%M%S', dropoff_datetime)
    ) AS ID,
    *
FROM
    `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2018` ;;
  }

  # sql_table_name: bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2018 ;;

  dimension: id {
    type: string
    description: "Unique identifier for each trip"
    sql: ${TABLE}.id ;;
    primary_key: yes
  }

  dimension: dolocation_id {
    type: number
    description: "TLC Taxi Zone in which the taximeter was disengaged."
    sql: cast(${TABLE}.dropoff_location_id as integer) ;;
  }

  dimension: dropoff_location_id {
    type: number
    sql: ${TABLE}.dropoff_location_id ;;
  }

  dimension: extra {
    type: number
    description: "Miscellaneous extras and surcharges. Currently, this only includes the $0.50 and $1 rush hour and overnight charges."
    sql: cast(${TABLE}.extra as decimal) ;;
  }

  dimension: fare_amount {
    type: number
    description: "The time-and-distance fare calculated by the meter."
    sql: cast(${TABLE}.fare_amount as decimal) ;;
  }

  dimension: improvement_surcharge {
    type: number
    description: "$0.30 improvement surcharge assessed trips at the flag drop. The improvement surcharge began being levied in 2015."
    sql: cast(${TABLE}.improvement_surcharge as decimal) ;;
  }

  dimension: mta_tax {
    type: number
    description: "$0.50 Metropolitan Transportation Authority (MTA) tax that is automatically triggered based on the metered rate in use."
    sql: cast(${TABLE}.mta_tax as decimal) ;;
  }

  dimension: passenger_count {
    type: number
    description: "The number of passengers in the vehicle. This is a driver-entered value."
    sql: cast(${TABLE}.passenger_count as integer) ;;
  }

  dimension: payment_type {
    type: string
    description: "A numeric code signifying how the passenger paid for the trip. 1= Credit card; 2= Cash; 3= No charge; 4= Dispute; 5= Unknown; 6= Voided trip."
    sql: ${TABLE}.payment_type ;;
  }

  dimension: pulocation_id {
    type: number
    description: "TLC Taxi Zone in which the taximeter was engaged."
    sql: cast(${TABLE}.pickup_location_id as integer) ;;
  }

  dimension: ratecode_id {
    type: number
    description: "The final rate code in effect at the end of the trip. 1= Standard rate; 2= JFK; 3= Newark; 4= Nassau or Westchester; 5= Negotiated fare; 6= Group ride."
    sql: cast(${TABLE}.rate_code as integer) ;;
  }

  dimension: store_and_fwd_flag {
    type: string
    description: "This flag indicates whether the trip record was held in vehicle memory before sending to the vendor, also known as “store and forward,”
                  because the vehicle did not have a connection to the server. Y= store and forward trip; N= not a store and forward trip."
    sql: ${TABLE}.store_and_fwd_flag ;;
    tags: ["stackable"]
  }

  dimension: tip_amount {
    type: number
    description: "This field is automatically populated for credit card tips. Cash tips are not included."
    sql: cast(${TABLE}.tip_amount as decimal) ;;
  }

  dimension: tolls_amount {
    type: number
    description: "Total amount of all tolls paid in trip."
    sql: cast(${TABLE}.tolls_amount as decimal) ;;
  }

  dimension: total_amount {
    type: number
    description: "The total amount charged to passengers. Does not include cash tips."
    sql: cast(${TABLE}.total_amount as decimal) ;;
  }

  dimension: pickup_datetime {
    type: date_time
    datatype: datetime
    sql: ${TABLE}.pickup_datetime  ;;
  }
  dimension: dropoff_datetime {
    type: date_time
    datatype: datetime
    sql: ${TABLE}.dropoff_datetime  ;;
  }

  dimension_group: dropoff {
    type: time
    datatype: datetime
    timeframes: [year, quarter, month, week, date, day_of_week, hour, hour_of_day, time]
    description: "The date and time when the meter was disengaged."
    sql: cast(${TABLE}.dropoff_datetime as datetime) ;;
  }

  dimension_group: pickup {
    type: time
    datatype: datetime
    timeframes: [year, quarter, month, week, date, day_of_week, hour, hour_of_day, time]
    description: "The date and time when the meter was engaged."
    sql: cast(${TABLE}.pickup_datetime as datetime) ;;
  }

  dimension: trip_duration {
    type: number
    description: "Difference between pickup and dropoff times"
    sql: {% if time_grain._parameter_value == "Time" or time_grain._parameter_value == "Hour"  or  time_grain._parameter_value == "HourOfDay" %} date_diff(${dropoff_time}, ${pickup_time}, MINUTE)
          {% else %}  ${TABLE}.trip_duration
          {% endif %}
                ;;
  }

  dimension: trip_count {
    type: number
    description: "number of trips"
    sql: {% if time_grain._parameter_value == "Time" or time_grain._parameter_value == "Hour" or  time_grain._parameter_value == "HourOfDay" %} 1
          {% else %} ${TABLE}.trip_count
          {% endif %}
                ;;
  }

  dimension: trip_distance {
    type: number
    description: "The elapsed trip distance in miles reported by the taximeter."
    sql: cast(${TABLE}.trip_distance as decimal) ;;
  }

  dimension: vendor_id {
    type: number
    description: "A code indicating the TPEP provider that provided the record. 1= Creative Mobile Technologies, LLC; 2= VeriFone Inc."
    sql: cast(${TABLE}.vendor_id as integer) ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_trip_distance {
    type: sum
    sql: ${trip_distance} ;;
  }

  measure: sum_trip_duration {
    type: sum
    sql: ${trip_duration} ;;
  }

  measure: sum_total_amount {
    type: sum
    sql: ${total_amount} ;;
  }

  measure: sum_fare_amount {
    type: sum
    sql:  ${fare_amount} ;;
  }

  measure: sum_tip_amount {
    type: sum
    sql:  ${tip_amount} ;;
  }

  measure: sum_passenger_count {
    type: sum
    sql:  ${tip_amount} ;;
  }

  measure: sum_tolls_amount {
    type: sum
    sql:  ${tolls_amount} ;;
  }

  measure: sum_mta_tax {
    type: sum
    sql:  ${mta_tax} ;;
  }

  measure: sum_extra {
    type: sum
    sql:  ${extra} ;;
  }

  measure: sum_trip_count {
    type: sum
    sql: ${trip_count} ;;
  }

  parameter: time_grain {
    description: "Time granularity on the X axis"
    type: unquoted
    suggestions: ["Year", "Quarter", "Month", "Week", "Day", "DayOfWeek", "Hour", "HourOfDay", "Time"]
  }

  measure: topn_join_trigger {
    hidden: yes
    description: "Referenced when Top-N needs to join this view"
    type: number
    sql: 1 ;;
  }

  measure: rank_measure {
    hidden: yes
    description: "Needed for rank view"
    type: number
    sql: ${sum_trip_duration} ;;
  }

}

view: yellow_tripdata {
  extends: [yellow_tripdata_base]
  derived_table: {
    sql: select * from
          {% if yellow_tripdata.time_grain._parameter_value == "Month" %} ${yellow_tripdata_month.SQL_TABLE_NAME}
          {% elsif yellow_tripdata.time_grain._parameter_value == "Week" %} ${yellow_tripdata_week.SQL_TABLE_NAME}
          {% elsif yellow_tripdata.time_grain._parameter_value == "Day" or  yellow_tripdata.time_grain._parameter_value == "DayOfWeek" %} ${yellow_tripdata_day.SQL_TABLE_NAME}
          {% else %} ${yellow_tripdata_base.SQL_TABLE_NAME}
          {% endif %}
          ;;
  }

  dimension_group: pickup {
    type: time
    timeframes: [year, quarter, quarter_of_year, month, week, date, day_of_week, hour, hour_of_day, time]
  }

}

# If necessary, uncomment the line below to include explore_source.

# include: "NYC_taxi.model.lkml"
explore: yellow_tripdata_base {}
#explore: yellow_tripdata_week {}
view: yellow_tripdata_day {
  extends: [yellow_tripdata_base]
  derived_table: {
    sql: select  count(*) as trip_count, min(t.id) as id, sum(cast(t.total_amount as decimal)) as total_amount, t.dropoff_location_id, t.payment_type, min(t.pickup_datetime) as pickup, min(t.pickup_datetime) as pickup_datetime, t.pickup_location_id, t.rate_code,
      t.store_and_fwd_flag, t.vendor_id, sum(d.trip_duration) as trip_duration, sum(cast(t.trip_distance as decimal)) as trip_distance, sum(cast(t.tolls_amount as decimal)) as tolls_amount,
      sum(cast(t.tip_amount as decimal)) as tip_amount, sum(cast(t.passenger_count as int)) as passenger_count, sum(cast(t.mta_tax as decimal)) as mta_tax, sum(cast(t.fare_amount as decimal)) as fare_amount, sum(cast(t.extra as decimal)) as extra
    from ${yellow_tripdata_base.SQL_TABLE_NAME} t
    JOIN
      (select id, date_diff(pickup_datetime, dropoff_datetime, MINUTE ) as trip_duration from ${yellow_tripdata_base.SQL_TABLE_NAME}) d ON d.id = t.id
    GROUP BY dropoff_location_id, payment_type, pickup_location_id, rate_code, store_and_fwd_flag, vendor_id, t.pickup_datetime
      ;;
    sql_trigger_value: select datepart(day, getdate()) ;;

  }
}
view: yellow_tripdata_week {
  extends: [yellow_tripdata_base]
  derived_table: {
    sql: select  sum(t.trip_count) as trip_count, min(t.id) as id, sum(cast(t.total_amount as decimal)) as total_amount, t.dropoff_location_id, t.payment_type, min(t.pickup) as pickup, t.pickup_location_id, t.rate_code,
      t.store_and_fwd_flag, t.vendor_id, sum(t.trip_duration) as trip_duration, sum(cast(t.trip_distance as decimal)) as trip_distance, sum(cast(t.tolls_amount as decimal)) as tolls_amount,
      sum(cast(t.tip_amount as decimal)) as tip_amount, sum(cast(t.passenger_count as int)) as passenger_count, sum(cast(t.mta_tax as decimal)) as mta_tax, sum(cast(t.fare_amount as decimal)) as fare_amount, sum(cast(t.extra as decimal)) as extra
    from ${yellow_tripdata_day.SQL_TABLE_NAME} t
    GROUP BY dropoff_location_id, payment_type, pickup_location_id, rate_code, store_and_fwd_flag, vendor_id, t.pickup
      ;;
    sql_trigger_value: select datepart(day, getdate()) ;;

  }
}

view: yellow_tripdata_month {
  extends: [yellow_tripdata_base]
  derived_table: {
    sql: select  sum(t.trip_count) as trip_count, min(t.id) as id, sum(cast(t.total_amount as decimal)) as total_amount, t.dropoff_location_id, t.payment_type, min(t.pickup) as pickup, t.pickup_location_id, t.rate_code,
      t.store_and_fwd_flag, t.vendor_id, sum(t.trip_duration) as trip_duration, sum(cast(t.trip_distance as decimal)) as trip_distance, sum(cast(t.tolls_amount as decimal)) as tolls_amount,
      sum(cast(t.tip_amount as decimal)) as tip_amount, sum(cast(t.passenger_count as int)) as passenger_count, sum(cast(t.mta_tax as decimal)) as mta_tax, sum(cast(t.fare_amount as decimal)) as fare_amount, sum(cast(t.extra as decimal)) as extra
    from ${yellow_tripdata_week.SQL_TABLE_NAME} t
    GROUP BY dropoff_location_id, payment_type, pickup_location_id, rate_code, store_and_fwd_flag, vendor_id, t.pickup
      ;;
    sql_trigger_value: select datepart(day, getdate()) ;;

  }
}
