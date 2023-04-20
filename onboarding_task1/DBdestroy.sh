#!/bin/bash

set e

terraform destroy --target=module.database.google_sql_database.database  --auto-approve

terraform apply --target=module.database.google_sql_database.database --auto-approve
