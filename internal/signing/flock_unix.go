//go:build !windows

package signing

import (
	"os"
	"syscall"
)

// Platform shims for file locking (added for the Windows port).
const (
	oNoFollow = syscall.O_NOFOLLOW
	lockSH    = syscall.LOCK_SH
	lockEX    = syscall.LOCK_EX
	lockNB    = syscall.LOCK_NB

	// closeLockBeforeRemove: POSIX allows removing a directory whose files
	// are still open, so the lock is kept until after removal.
	closeLockBeforeRemove = false
)

var errWouldBlock = syscall.EWOULDBLOCK

func flockFile(f *os.File, how int) error {
	return syscall.Flock(int(f.Fd()), how)
}
