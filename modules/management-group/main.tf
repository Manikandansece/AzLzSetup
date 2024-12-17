data "azurerm_subscription" "current" {
}

resource "azurerm_management_group" "Parent01" {
  display_name = "CiabParentCo"
  subscription_ids = [
    data.azurerm_subscription.current.subscription_id,
  ]
}