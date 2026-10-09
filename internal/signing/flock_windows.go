//go:build windows

package signing

import (
	"os"

	"golang.org/x/sys/windows"
)

// Windows emulation of flock(2) using LockFileEx. Windows has no O_NOFOLLOW;
// symlink checks elsewhere (Lstat) still apply.
const (
	oNoFollow = 0
	lockSH    = 1
	lockEX    = 2
	lockNB    = 4

	// Windows cannot delete a file that is still open, so the workspace lock
	// must be released before the directory is removed.
	closeLockBeforeRemove = true
)

var errWouldBlock error = windows.ERROR_LOCK_VIOLATION

func flockFile(f *os.File, how int) error {
	var flags uint32
	if how&lockEX != 0 {
		flags |= windows.LOCKFILE_EXCLUSIVE_LOCK
	}
	if how&lockNB != 0 {
		flags |= windows.LOCKFILE_FAIL_IMMEDIATELY
	}
	ol := new(windows.Overlapped)
	return windows.LockFileEx(windows.Handle(f.Fd()), flags, 0, 1, 0, ol)
}
