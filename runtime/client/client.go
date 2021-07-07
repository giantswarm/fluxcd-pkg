/*
Copyright 2021 The Flux authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package client

import (
	"github.com/spf13/pflag"
	"k8s.io/client-go/rest"
	ctrl "sigs.k8s.io/controller-runtime"
)

const (
	flagQPS   = "kube-api-qps"
	flagBurst = "kube-api-burst"
)

// Options contains the runtime configuration for a Kubernetes client.
//
// The struct can be used in the main.go file of your controller by binding it to the main flag set, and then utilizing
// the configured options later:
//
//	func main() {
//		var (
//			// other controller specific configuration variables
//			clientOptions client.Options
//		)
//
//		// Bind the options to the main flag set, and parse it
//		clientOptions.BindFlags(flag.CommandLine)
//		flag.Parse()
//
//		// Get a runtime Kubernetes client configuration with the options set
//		restConfig := client.GetConfigOrDie(clientOptions)
//	}
type Options struct {
	// QPS indicates the maximum queries-per-second of requests sent to to the Kubernetes API, defaults to 20.
	QPS float32

	// Burst indicates the maximum burst queries-per-second of requests sent to the Kubernetes API, defaults to 50.
	Burst int
}

// BindFlags will parse the given pflag.FlagSet for Kubernetes client option flags and set the Options accordingly.
func (o *Options) BindFlags(fs *pflag.FlagSet) {
	fs.Float32Var(&o.QPS, flagQPS, 20.0,
		"The maximum queries-per-second of requests sent to the Kubernetes API.")
	fs.IntVar(&o.Burst, flagBurst, 50,
		"The maximum burst queries-per-second of requests sent to the Kubernetes API.")
}

// GetConfigOrDie wraps ctrl.GetConfigOrDie and sets the configured Options, returning the modified rest.Config.
func GetConfigOrDie(opts Options) *rest.Config {
	config := ctrl.GetConfigOrDie()
	config.QPS = opts.QPS
	config.Burst = opts.Burst
	return config
}
