output "cloud_instance_id" {
   value       = aws_instance.default.id
  }

output "availability_zone" {
  value =aws_instance.default.availability_zone
  }
  
output "cloud_private_dns_name" {
  value = aws_instance.default.private_dns
  }
  
output "public_ip_address" {
  value = aws_instance.default.public_ip
  }


output "power_state" {
  value =aws_instance.default.instance_state
  }

output "public_dns_name" {
  value = aws_instance.default.public_dns
  }

output "private_ip_address" {
  value =aws_instance.default.private_ip
  }
