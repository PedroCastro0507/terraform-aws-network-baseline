# terraform-aws-network-baseline

A small, reusable Terraform module that creates an AWS network baseline: a VPC, public and private subnets across availability zones, internet routing and an optional NAT gateway.

![Terraform CI](https://github.com/PedroCastro0507/terraform-aws-network-baseline/actions/workflows/terraform-ci.yml/badge.svg)
![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-844FBA?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-provider%205.x-232F3E?logo=amazonwebservices&logoColor=white)

## What it creates

- One VPC with DNS support and DNS hostnames enabled.
- An internet gateway and a public route table.
- Public and private subnets, one per availability zone you pass in.
- An optional single NAT gateway (with its Elastic IP) and a private route table that uses it.
- Consistent tags on every resource.

## Usage

```hcl
module "network" {
  source = "github.com/PedroCastro0507/terraform-aws-network-baseline"

  name               = "demo"
  azs                = ["ap-southeast-2a", "ap-southeast-2b"]
  enable_nat_gateway = true

  tags = {
    Environment = "example"
  }
}
```

A complete example lives in [examples/basic](examples/basic).

## Inputs

| Name | Description | Default |
|---|---|---|
| name | Name prefix applied to every resource | required |
| azs | Availability zones, one per subnet | required |
| vpc_cidr | CIDR block of the VPC | 10.0.0.0/16 |
| public_subnet_cidrs | CIDR blocks of the public subnets | two /24 blocks |
| private_subnet_cidrs | CIDR blocks of the private subnets | two /24 blocks |
| enable_nat_gateway | Create a single NAT gateway | false |
| tags | Extra tags merged into every resource | {} |

## Outputs

| Name | Description |
|---|---|
| vpc_id | ID of the VPC |
| public_subnet_ids | IDs of the public subnets |
| private_subnet_ids | IDs of the private subnets |
| nat_gateway_id | ID of the NAT gateway, or null when disabled |

## Continuous integration

Every push and pull request runs [terraform-ci.yml](.github/workflows/terraform-ci.yml), which checks formatting with `terraform fmt` and runs `terraform init -backend=false` and `terraform validate` for the module and for the example. No cloud credentials are needed.

## Scope and limits

The pipeline validates the configuration but does not run `terraform apply`, so this repository has not been deployed to an AWS account by the CI. A single NAT gateway keeps cost low but is not highly available.

## Roadmap

- Add VPC flow logs.
- Add one NAT gateway per availability zone as an option.
- Add tflint and a security scan to the pipeline.
