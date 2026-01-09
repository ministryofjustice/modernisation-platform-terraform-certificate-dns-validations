package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModule(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./unit-test",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Assert outputs
	certificateValidationID := terraform.Output(t, terraformOptions, "certificate_validation_id")
	assert.NotEmpty(t, certificateValidationID, "certificate_validation_id should not be empty")

	validationRecordFQDNs := terraform.OutputList(t, terraformOptions, "validation_record_fqdns")
	assert.NotEmpty(t, validationRecordFQDNs, "validation_record_fqdns should not be empty")
	assert.Greater(t, len(validationRecordFQDNs), 0, "Should have at least one validation record FQDN")

	// Verify validation records contain expected domain
	for _, fqdn := range validationRecordFQDNs {
		assert.Contains(t, fqdn, "modernisation-platform.service.justice.gov.uk", "FQDN should contain expected domain")
	}
}
