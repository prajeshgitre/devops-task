output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "vpc_name" {
  description = "VPC Name"
  value       = module.vpc.name
}