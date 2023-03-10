variable "region" {
	default = ""
}

variable "account_id" {
	default = ""
}

variable "source_dir" {
	default = ""
}

variable "output_dir" {
	default = ""
}

variable "add_policy" {
  type = string
  default = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          }
        }
      ]
    }
  EOF
}