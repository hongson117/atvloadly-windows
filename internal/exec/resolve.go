package exec

import (
	"os"
	"path/filepath"
	"runtime"
	"strings"
)

// resolveName returns the program to run for name. On Windows a bare program
// name (e.g. "plumesign") is first looked up next to the running executable,
// because Go's os/exec refuses to run binaries found in the current directory
// (exec.ErrDot) and a portable install keeps plumesign.exe beside
// atvloadly.exe. Other platforms keep the plain PATH lookup. Added for the
// Windows port.
func resolveName(name string) string {
	if runtime.GOOS != "windows" || strings.ContainsAny(name, `/\`) {
		return name
	}
	self, err := os.Executable()
	if err != nil {
		return name
	}
	candidate := filepath.Join(filepath.Dir(self), name)
	if !strings.HasSuffix(strings.ToLower(candidate), ".exe") {
		candidate += ".exe"
	}
	if info, err := os.Stat(candidate); err == nil && !info.IsDir() {
		return candidate
	}
	return name
}
