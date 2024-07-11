terraform {
  backend "consul" {
    path    = "statefiles/k3s"
    scheme  = "http"
  }
}