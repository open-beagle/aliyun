//go:build unit

package repository

import (
	"encoding/base64"
	"fmt"
	"testing"

	"github.com/Wei-Shaw/sub2api/internal/service"
)

func TestGrokSchedulerTierProjection(t *testing.T) {
	jwt := func(tier int) string {
		return "e30." + base64.RawURLEncoding.EncodeToString([]byte(fmt.Sprintf(`{"tier":%d}`, tier))) + ".signature"
	}
	cases := []struct {
		name, platform, token, saved, wantTier string
		wantEligible                           bool
	}{
		{"paid_live_jwt", "grok", jwt(7), "free", "supergrok_plus", true},
		{"paid_saved_tier", "grok", "", "supergrok_plus", "supergrok_plus", true},
		{"live_free_downgrade", "grok", jwt(0), "supergrok_plus", "free", false},
		{"live_basic_downgrade", "grok", jwt(2), "supergrok_plus", "x_basic", false},
		{"unclassified_billing", "grok", "", "", "", false},
		{"malformed_token_fallback", "grok", "invalid", "supergrok_plus", "supergrok_plus", true},
		{"other_platform_unchanged", "openai", jwt(7), "supergrok_plus", "", false},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			a := service.Account{Platform: tc.platform, Type: "oauth",
				Credentials: map[string]any{"access_token": tc.token, "refresh_token": "never-copy", "subscription_tier": tc.saved},
				Extra:       map[string]any{"grok_billing_snapshot": map[string]any{"status_code": 200, "monthly_limit_cents": 0}},
			}
			meta := buildSchedulerMetadataAccount(a)
			if got := meta.GetCredential("subscription_tier"); got != tc.wantTier {
				t.Fatalf("tier = %q; want %q", got, tc.wantTier)
			}
			for _, key := range []string{"access_token", "refresh_token"} {
				if _, exists := meta.Credentials[key]; exists {
					t.Fatalf("metadata leaked %s", key)
				}
			}
			if got, reason := meta.GrokMediaGenerationEligibility(); got != tc.wantEligible {
				t.Fatalf("eligibility = %v (%s); want %v", got, reason, tc.wantEligible)
			}
			if a.GetCredential("subscription_tier") != tc.saved {
				t.Fatal("projection mutated original credentials")
			}
		})
	}
}
