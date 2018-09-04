package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// A simple integration test
func TestSimpleIntegration(t *testing.T) {
	// Signal that this test can run in parallel with other tests
	t.Parallel()

	/* =============================================
	 * VPC
	 * ============================================= */

	terraformVPCOptions := &terraform.Options{
		// The path to where our Terraform VPC code is located
		TerraformDir: "../../terraform/modules/network/vpc",
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformVPCOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformVPCOptions)

	// Run `terraform output` to get the value of an output variable
	vpcID := terraform.Output(t, terraformVPCOptions, "vpc_id")
	vpcCIDRPrefix := terraform.Output(t, terraformVPCOptions, "vpc_cidr_prefix")

	// Verify we're getting back the variable we expect
	assert.Regexp(t, "^vpc-.*", vpcID)

	/* =============================================
	 * Internet gateway
	 * ============================================= */

	terraformIGWOptions := &terraform.Options{
		TerraformDir: "../../terraform/modules/network/igw",
		Vars: map[string]interface{}{
			"vpc_id":	vpcID,
		},
	}

	defer terraform.Destroy(t, terraformIGWOptions)
	terraform.InitAndApply(t, terraformIGWOptions)
	igwID := terraform.Output(t, terraformIGWOptions, "igw_id")

	/* =============================================
	 * Route table
	 * ============================================= */

	terraformRouteTableOptions := &terraform.Options{
 		TerraformDir: "../../terraform/modules/network/route_table",
 		Vars: map[string]interface{}{
 			"vpc_id":	vpcID,
			"igw_id": igwID,
 		},
 	}

 	defer terraform.Destroy(t, terraformRouteTableOptions)
 	terraform.InitAndApply(t, terraformRouteTableOptions)

 	publicRouteTableID := terraform.Output(t, terraformRouteTableOptions, "public_rt_id")
	privateRouteTableID := terraform.Output(t, terraformRouteTableOptions, "private_rt_id")

	/* =============================================
	 * Subnet
	 * ============================================= */

	terraformSubnetOptions := &terraform.Options{
 		TerraformDir: "../../terraform/modules/network/subnet",
 		Vars: map[string]interface{}{
 			"vpc_id":	vpcID,
			"vpc_cidr_prefix": vpcCIDRPrefix,
			"aws_region": "us-west-2",
			"public_rt_id": publicRouteTableID,
			"private_rt_id": privateRouteTableID,
 		},
 	}

 	defer terraform.Destroy(t, terraformSubnetOptions)
 	terraform.InitAndApply(t, terraformSubnetOptions)

	publicSubnetID := terraform.Output(t, terraformSubnetOptions, "public_subnet_id")
	privateSubnetID := terraform.Output(t, terraformSubnetOptions, "private_subnet_id")

	/* =============================================
	 * Security group
	 * ============================================= */

	terraformSecurityGroupOptions := &terraform.Options{
		TerraformDir: "../../terraform/modules/network/security_group",
		Vars: map[string]interface{}{
		 "vpc_id":	vpcID,
	 	},
	}

	defer terraform.Destroy(t, terraformSecurityGroupOptions)
	terraform.InitAndApply(t, terraformSecurityGroupOptions)

	openSecurityGroupID := terraform.Output(t, terraformSecurityGroupOptions, "open_security_group_id")

	/* =============================================
	 * Instances
	 * ============================================= */

	terraformInstancesOptions := &terraform.Options{
		TerraformDir: "../../terraform/modules/instances",
		Vars: map[string]interface{}{
		 	"vpc_id":	vpcID,
			"open_security_group": openSecurityGroupID,
			"remote_download_path":	"/home/ubuntu/downloads",
			"pem_file_path": 				"~/.ssh/john-oneill-IAM-keypair.pem",
			"public_key_path": 			"~/.ssh/id_rsa.pub",
		  "public_subnet_id":			privateSubnetID,
			"sangrenel_flag_auto_launch_test": "on",
		},
	}

	defer terraform.Destroy(t, terraformInstancesOptions)
	terraform.InitAndApply(t, terraformInstancesOptions)

	// We've been able to create everything — now let's do a small check
	// to see that we're getting a valid VPC ID back.
	assert.Regexp(t, "^vpc-.*", vpcID)
}
