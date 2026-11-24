# ---------------------------------------------------------------------------------------------------------------------
# ¦ NTC GITHUB ADMINISTRATION
# ---------------------------------------------------------------------------------------------------------------------
module "ntc_github_administration" {
  source = "github.com/nuvibit-terraform-collection/terraform-github-ntc-administration?ref=1.4.3"

  organization_settings = {
    # set 'update_settings' to false to omit this block
    update_settings                                              = true
    display_name                                                 = "My Company"
    description                                                  = "Github Organization of My Company"
    company                                                      = "My Company"
    location                                                     = "Switzerland"
    blog                                                         = "https://mycompany.com"
    email                                                        = "info@mycompany.com"
    billing_email                                                = "billing@mycompany.com"
    has_organization_projects                                    = false
    has_repository_projects                                      = false
    default_repository_permission                                = "write"
    web_commit_signoff_required                                  = false
    advanced_security_enabled_for_new_repositories               = false
    dependabot_alerts_enabled_for_new_repositories               = false
    dependabot_security_updates_enabled_for_new_repositories     = false
    dependency_graph_enabled_for_new_repositories                = false
    secret_scanning_enabled_for_new_repositories                 = false
    secret_scanning_push_protection_enabled_for_new_repositories = false
    members_can_create_pages                                     = false
    members_can_create_public_pages                              = false
    members_can_create_private_pages                             = false
    members_can_fork_private_repositories                        = false
    members_can_create_public_repositories                       = true
    members_can_create_private_repositories                      = true
    members_can_create_internal_repositories                     = true
    members_can_create_repositories                              = true
  }

  # organization ruleset for branch protection (requires a GitHub Team or GitHub Enterprise plan)
  organization_rulesets = [
    {
      name          = "branch-protection"
      target        = "branch"
      enforcement   = "active"
      include_refs  = ["~DEFAULT_BRANCH"]
      exclude_refs  = []
      include_repos = ["~ALL"]
      exclude_repos = ["legacy-repo"]
      bypass_actors = [
        {
          # NOTE: 'actor_name' must match an existing actor in the current organization or an actor created in the same module
          actor_name  = "admins"
          actor_type  = "Team"
          bypass_mode = "always"
        },
        {
          actor_name  = "my-app"
          actor_type  = "Integration"
          bypass_mode = "always"
        },
        {
          actor_name  = "OrganizationAdmin"
          actor_type  = "OrganizationAdmin"
          bypass_mode = "always"
        },
        {
          actor_name  = "admin"
          actor_type  = "RepositoryRole"
          bypass_mode = "always"
        }
      ]
      required_checks         = ["ci", "security-scan"]
      required_workflows      = []
      required_code_scanning  = []
      restrict_creations      = true
      restrict_updates        = true
      restrict_deletions      = true
      restrict_force_pushes   = true
      required_linear_history = true
      required_signatures     = true
      pull_request = {
        required                          = true
        dismiss_stale_reviews_on_push     = true
        require_code_owner_review         = true
        require_last_push_approval        = true
        required_approving_review_count   = 1
        required_review_thread_resolution = true
      }
    }
  ]

  # organization secrets for github actions
  organization_secrets = [
    {
      name = "MY_SECRET"
      # WARNING: do not add secrets in clear text
      # secrets should be referenced as sensitive values (e.g. referenced from secrets vault or sensitive input via environment variable)
      value      = "supersecretvalue"
      visibility = "all"
      type       = "github_actions"
    }
  ]

  # organization variables for github actions
  organization_variables = [
    {
      name       = "MY_VARIABLE"
      value      = "variablevalue"
      visibility = "all"
      type       = "github_actions"
    }
  ]

  # add members to current organization
  organization_members = [
    {
      username = "hans-muster"
      role     = "admin"
    }
  ]

  # create teams in current organization
  organization_teams = [
    {
      name        = "admins"
      description = "Organization administrators"
      privacy     = "closed"
      members = [
        {
          username = "hans-muster"
          role     = "maintainer"
        }
      ]
    }
  ]

  # list of repositories created in the current organization (based on github provider)
  organization_repositories = [
    {
      name        = "test-repo"
      description = "this repo was created during automated testing"
      visibility  = "private"
      topics      = ["test"]
      # NOTE: use an existing template repository or create new template repository in separate module call
      template = {
        template_repository  = module.ntc_github_template_repos.organization_repositories["test-template"].name
        repository_owner     = module.ntc_github_template_repos.organization_repositories["test-template"].owner
        include_all_branches = true
      }
      settings = {
        create_readme                           = false
        has_issues                              = false
        has_discussions                         = false
        has_projects                            = false
        has_wiki                                = false
        allow_merge_commit                      = false
        allow_squash_merge                      = true
        allow_rebase_merge                      = false
        allow_auto_merge                        = false
        delete_branch_on_merge                  = true
        web_commit_signoff_required             = false
        allow_update_branch                     = false
        archive_on_destroy                      = false
        vulnerability_alerts                    = true
        ignore_vulnerability_alerts_during_read = false
        # (optional) chose gitignore file from available templates
        # https://github.com/github/gitignore
        gitignore_template = null
        # (optional) chose license file from available templates
        # https://github.com/github/choosealicense.com/tree/gh-pages/_licenses
        license_template = null
      }
      # (optional) create or overwrite files in github repository - most use cases can be solved with 'template_repository' instead
      # WARNING: bypass permission required when branch protection is enabled
      managed_files = [
        {
          file                = "main.tf"
          content             = file("${path.module}/files/main.tf")
          overwrite_on_create = true
          # enabling this will only create the file initially and it will not be updated
          # this can be usefull to avoid bypassing branch protection (file will be initially created before branch protection rule)
          # WARNING: updating 'ignore_lifecycle' after initial deployment will cause the file to be recreated
          ignore_lifecycle = true
        }
      ]
      # (optional) invite collaborators to github repository
      collaborators = [
        {
          username   = "builder-bob"
          permission = "pull"
        }
      ]
      # (optional) assign teams directly to github repository
      teams = [
        {
          # NOTE: 'team_name' must match an existing team in the current organization or a team in 'organization_teams'
          team_name  = "admins"
          permission = "push"
        }
      ]
    }
  ]
}

# create template repositories separately to avoid a circular dependency
module "ntc_github_template_repos" {
  source = "github.com/nuvibit-terraform-collection/terraform-github-ntc-administration?ref=1.4.3"

  organization_repositories = [
    {
      name        = "test-template"
      description = "this repo was created during automated testing"
      visibility  = "private"
      topics      = ["test"]
      settings = {
        # NOTE: set 'is_template' to true to create a template repository which can be used as a base for new repositories
        is_template                             = true
        create_readme                           = false
        has_issues                              = false
        has_discussions                         = false
        has_projects                            = false
        has_wiki                                = false
        allow_merge_commit                      = false
        allow_squash_merge                      = true
        allow_rebase_merge                      = false
        allow_auto_merge                        = false
        delete_branch_on_merge                  = true
        web_commit_signoff_required             = false
        allow_update_branch                     = false
        archive_on_destroy                      = false
        vulnerability_alerts                    = true
        ignore_vulnerability_alerts_during_read = false
      }
      managed_files = [
        {
          file                = ".gitignore"
          content             = file("${path.module}/files/.gitignore")
          overwrite_on_create = true
          ignore_lifecycle    = false
        }
      ]
    },
  ]
}