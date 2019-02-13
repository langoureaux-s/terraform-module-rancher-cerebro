# terraform-module-rancher-cerebro

This module permit to deploy Cerebro stack on Rancher 1.6.x.

```
terragrunt = {
  terraform {
    source = "git::https://github.com/langoureaux-s/terraform-module-rancher-cerebro.git"
  }
  
  project_name            = "test"
  stack_name              = "cerebro"
  finish_upgrade          = "true"
  label_scheduling        = "cerebro=true"
  global_scheduling       = "false"
  scale                   = "2"
  client_stack            = "elasticsearch/elasticsearch"
  container_memory        = "1g"
}
```

> Don't forget to read the file `variables.tf` to get all informations about variables.