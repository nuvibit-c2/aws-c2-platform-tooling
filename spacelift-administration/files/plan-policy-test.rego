package spacelift
import input.tfplan as tfplan

sample { true }

# Deny creating AWS IAM users
deny[sprintf("must not create AWS IAM users: %s", [resource.address])] {
  some resource
  created_resources[resource]
  resource.type == "aws_iam_user"
}

# warn if a resource will be deleted
warn[sprintf("Detected deleted resource: %s", [resource.address])] {
  some resource
  deleted_resources[resource]
  input.stack.autodeploy
}

# warn if a resource will be recreated
warn[sprintf("Detected recreated resource: %s", [resource.address])] {
  some resource
  recreated_resources[resource]
  input.stack.autodeploy
}