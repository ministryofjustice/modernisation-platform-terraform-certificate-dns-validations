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
	validationRecordFQDNs := terraform.OutputList(t, terraformOptions, "validation_record_fqdns")
	assert.NotEmpty(t, validationRecordFQDNs, "validation_record_fqdns should not be empty")
	assert.Equal(t, 2, len(validationRecordFQDNs), "Should have exactly 2 validation record FQDNs")

	// Verify validation records contain expected domain
	for _, fqdn := range validationRecordFQDNs {
		assert.Contains(t, fqdn, "platforms-test.modernisation-platform.service.justice.gov.uk", "FQDN should contain expected domain")
	}
}
