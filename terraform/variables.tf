# variable "ecr_image_identifier" {
#   description = "The full URI of the Docker image in ECR."
#   type        = string
# }

variable "image_tag" {
  description = "The dynamic Git commit SHA tag for the Docker image"
  type        = string
}