resource "azurerm_servicebus_namespace" "main" {
  name                = "sbns-${local.base_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
}

resource "azurerm_servicebus_topic" "main" {
  name                 = "todo-created"
  namespace_id         = azurerm_servicebus_namespace.main.id
  partitioning_enabled = true
}

resource "azurerm_servicebus_subscription" "consumer" {
  name                                 = "sbt-${local.base_name}-consumer"
  topic_id                             = azurerm_servicebus_topic.main.id
  max_delivery_count                   = 2
  dead_lettering_on_message_expiration = true
}

resource "azurerm_servicebus_topic_authorization_rule" "producer" {
  name     = "producer-${local.base_name}"
  topic_id = azurerm_servicebus_topic.main.id
  listen   = false
  send     = true
}

resource "azurerm_servicebus_topic_authorization_rule" "consumer" {
  name     = "consumer-${local.base_name}"
  topic_id = azurerm_servicebus_topic.main.id
  listen   = true
  send     = false
}
