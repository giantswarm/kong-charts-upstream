//go:build third_party
// +build third_party

package third_party

import (
	_ "github.com/dadav/helm-schema/cmd/helm-schema"
)

//go:generate go install -modfile go.mod github.com/dadav/helm-schema/cmd/helm-schema
