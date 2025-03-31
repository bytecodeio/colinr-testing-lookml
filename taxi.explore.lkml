include: "*.view.lkml"                       # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# Can we include relative paths....?
include: "*.view.lkml"

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.

# Below is the basic structure of a Looker explore: start with a base table and define joins.
explore: yellow_tripdata {
  hidden: yes
  join: drop_off {
    from: taxi_zone_lookup
    relationship: many_to_one
    sql_on: ${yellow_tripdata.dolocation_id} = ${drop_off.location_id} ;;
  }
  join: pick_up {
    from: taxi_zone_lookup
    relationship: many_to_one
    sql_on: ${yellow_tripdata.dolocation_id} = ${pick_up.location_id} ;;
  }
  join: payment {
    relationship: many_to_one
    sql_on: ${payment.id} = ${yellow_tripdata.payment_type} ;;
  }
  join: rate {
    relationship: many_to_one
    sql_on: ${rate.id} = ${yellow_tripdata.ratecode_id} ;;
  }
  join: vendor {
    relationship: many_to_one
    sql_on: ${vendor.id} = ${yellow_tripdata.vendor_id} ;;
  }
}

explore: yellow_tripdata_topn {
  label: "Yellow Tripdata"
  description: "Tripdata for NYC Yellow Cabs"
  hidden: no
  from: yellow_tripdata_topn
  view_name: yellow_tripdata
  extends: [yellow_tripdata]
  always_filter: {
    filters: {
      field: pickup_time
    }
    filters: {
      field: time_grain
      value: "Day"
    }
    filters: {
      field: stack_by
    }

    filters: {
      field: stack_limit
      value: "<=10"
    }
  }
  join: yellow_tripdata_rank {
    type: left_outer
    relationship: one_to_one
    sql_on: coalesce(${yellow_tripdata.stacked_dimension}, 'no_match') = yellow_tripdata_rank.stacked_dimension ;;
  }
  # always_join: [extra_join]
  # join: extra_join {
  #   view_label: " "
  #   relationship: many_to_one
  #   type: left_outer
  #   sql:    {% if    yellow_tripdata.stack_by._parameter_value == "'Borough'" and pick_up._in_query != true %} left join looker_scratch.pickup   as pick_up on yellow_tripdata.dolocation_id = pick_up.location_id
  #         {% elsif yellow_tripdata.stack_by._parameter_value == "'Service Zone'"  and pick_up._in_query != true%} left join looker_scratch.pickup  as pick_up on yellow_tripdata.dolocation_id = pick_up.location_id
  #         {% elsif yellow_tripdata.stack_by._parameter_value == "'Zone'" and pick_up._in_query != true %} left join looker_scratch.pickup  as pick_up on yellow_tripdata.dolocation_id = pick_up.location_id
  #         {% elsif yellow_tripdata.stack_by._parameter_value == "'Type'" and payment._in_query != true %} left join looker_scratch.payment as payment on payment.id = yellow_tripdata.payment_type
  #         {% elsif yellow_tripdata.stack_by._parameter_value == "'Description'" and rate._in_query != true %} left join looker_scratch.rate as rate onrate.id = yellow_tripdata.ratecode_id
  #         {% elsif yellow_tripdata.stack_by._parameter_value == "'Name'" and vendor._in_query != true %} left join looker_scratch.vendor as vendor on CAST(vendor.`Vendor ID` as STRING) = yellow_tripdata.vendor_id

  #         {% endif %}
  #         ;;
  # }
}

# Automated tests below

# Check each of the PDTs and source table to ensure that primary key is unique
test: yellow_tripdata_id_is_unique {
  explore_source: yellow_tripdata {
    column: id {}
    column: count {}
    sort: {
      field: count
      desc: yes
    }
    limit: 1
  }
  assert: yellow_tripdata_id_is_unique {
    expression: ${yellow_tripdata.count} = 1 ;;
  }
}

test: yellow_tripdata_month_id_is_unique {
  explore_source: yellow_tripdata {
    column: id {}
    column: count {}
    filters: {
      field: yellow_tripdata.time_grain
      value: "Month"
    }
    sort: {
      field: count
      desc: yes
    }
    limit: 1
  }
  assert: yellow_tripdata_id_is_unique {
    expression: ${yellow_tripdata.count} = 1 ;;
  }
}

test: yellow_tripdata_week_id_is_unique {
  explore_source: yellow_tripdata {
    column: id {}
    column: count {}
    filters: {
      field: yellow_tripdata.time_grain
      value: "Week"
    }
    sort: {
      field: count
      desc: yes
    }
    limit: 1
  }
  assert: yellow_tripdata_id_is_unique {
    expression: ${yellow_tripdata.count} = 1 ;;
  }
}

test: yellow_tripdata_day_id_is_unique {
  explore_source: yellow_tripdata {
    column: id {}
    column: count {}
    filters: {
      field: yellow_tripdata.time_grain
      value: "Day"
    }
    sort: {
      field: count
      desc: yes
    }
    limit: 1
  }
  assert: yellow_tripdata_id_is_unique {
    expression: ${yellow_tripdata.count} = 1 ;;
  }
}
