output "spacelift_space_ids" {
  description = "List of Spacelift space ids by path"
  value       = module.ntc_spacelift_administration.space_ids_by_space_path
}