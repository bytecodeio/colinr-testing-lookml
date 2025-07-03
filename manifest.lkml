project_name: "colin_viz_testing"


application: extension-viz-conditional-table {
  label: "test-conditional-table-extension"
  # url: "https://localhost:8080/bundle.js"
  file: "table-conditional.js"
  mount_points: {
    dashboard_vis: yes

  }
  entitlements: {

    core_api_methods: ["me"] #Add more entitlements here as you develop new functionality
  }
}
