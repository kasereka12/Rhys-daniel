var process = process || {env: {NODE_ENV: "development"}};
// Call the dataTables jQuery plugin
$(document).ready(function() {
  $('#dataTable').DataTable();
});

