resource "azurerm_servicebus_namespace" "main" {
  name                = "sbns-${local.base_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
}

resource "azurerm_servicebus_topic" "main" {
  name                      = "orders"
  namespace_id              = azurerm_servicebus_namespace.main.id
  enable_partitioning       = false
  enable_batched_operations = true
}

resource "azurerm_servicebus_subscription" "consumer1" {
  name                                 = "sbt-${local.base_name}-consumer1"
  topic_id                             = azurerm_servicebus_topic.main.id
  max_delivery_count                   = 2
  dead_lettering_on_message_expiration = true
}

resource "azurerm_servicebus_subscription" "consumer2" {
  name                                 = "sbt-${local.base_name}-consumer2"
  topic_id                             = azurerm_servicebus_topic.main.id
  max_delivery_count                   = 2
  dead_lettering_on_message_expiration = true
}
