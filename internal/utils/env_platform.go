package utils

import (
	"path/filepath"
	"runtime"
)

// TempDirEnvs returns the environment overrides that point a child process's
// temporary directory at dir. Unix programs read TMPDIR; Windows programs
// (Rust's std::env::temp_dir) read TMP/TEMP instead. Added for the Windows port.
func TempDirEnvs(dir string) []string {
	envs := []string{"TMPDIR=" + dir}
	if runtime.GOOS == "windows" {
		envs = append(envs, "TMP="+dir, "TEMP="+dir)
	}
	return envs
}

// HomeDirEnvs returns the environment overrides that point a child process's
// home/config directory at home. plumesign stores its data under
// $HOME/.config/PlumeImpactor on Unix and %APPDATA%\PlumeImpactor on Windows.
func HomeDirEnvs(home string) []string {
	envs := []string{"HOME=" + home}
	if runtime.GOOS == "windows" {
		envs = append(envs, "USERPROFILE="+home, "APPDATA="+filepath.Join(home, ".config"))
	}
	return envs
}
