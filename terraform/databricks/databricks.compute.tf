data "databricks_node_type" "small" {
  local_disk  = false
  min_cores   = 4
  gb_per_core = 4

  depends_on = [
    azurerm_databricks_workspace.main
  ]
}

data "databricks_node_type" "large" {
  local_disk  = false
  min_cores   = 16
  gb_per_core = 4

  depends_on = [
    azurerm_databricks_workspace.main
  ]
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true

  depends_on = [
    azurerm_databricks_workspace.main
  ]
}

data "databricks_current_user" "me" {
  depends_on = [
    azurerm_databricks_workspace.main
  ]
}

resource "databricks_cluster" "single" {
  cluster_name            = "SingleNodeCluster"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.small.id
  autotermination_minutes = 15
  data_security_mode      = "SINGLE_USER"
  single_user_name        = data.databricks_current_user.me.user_name
  runtime_engine          = "PHOTON"

  spark_conf = {
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.master" : "local[*]"
    "spark.databricks.io.cache.enabled" : "true"
  }

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }

  depends_on = [
    azurerm_databricks_workspace.main
  ]
}

resource "databricks_cluster" "single_large" {
  cluster_name            = "SingleLargeNodeCluster"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.large.id
  autotermination_minutes = 15
  data_security_mode      = "SINGLE_USER"
  single_user_name        = data.databricks_current_user.me.user_name
  runtime_engine          = "PHOTON"

  spark_conf = {
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.master" : "local[*]"
    "spark.databricks.io.cache.enabled" : "true"
  }

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }

  depends_on = [
    azurerm_databricks_workspace.main
  ]
}

resource "databricks_cluster" "multi3" {
  cluster_name            = "MultiNodeCluster3"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.small.id
  autotermination_minutes = 15
  data_security_mode      = "USER_ISOLATION"
  num_workers             = 3
  runtime_engine          = "PHOTON"

  spark_conf = {
    "spark.databricks.io.cache.enabled" : "true"
  }

  depends_on = [
    azurerm_databricks_workspace.main
  ]
}

resource "databricks_cluster" "multi4" {
  cluster_name            = "MultiNodeCluster4"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.small.id
  autotermination_minutes = 15
  data_security_mode      = "USER_ISOLATION"
  num_workers             = 4
  runtime_engine          = "PHOTON"

  spark_conf = {
    "spark.databricks.io.cache.enabled" : "true"
  }

  depends_on = [
    azurerm_databricks_workspace.main
  ]
}

resource "databricks_cluster" "multi8" {
  cluster_name            = "MultiNodeCluster8"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.small.id
  autotermination_minutes = 15
  data_security_mode      = "USER_ISOLATION"
  num_workers             = 8
  runtime_engine          = "PHOTON"

  spark_conf = {
    "spark.databricks.io.cache.enabled" : "true"
  }

  depends_on = [
    azurerm_databricks_workspace.main
  ]
}



