variable "env" {
    type = string
    description = "This is a variable for Environment"
    default = "dev"
}

variable "instance_type" {
    type = string
    description = "This is a variable for instance type"
    default = "t2.micro"
}