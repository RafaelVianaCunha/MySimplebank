package util

import (
	"testing"

	"github.com/stretchr/testify/require"
	"golang.org/x/crypto/bcrypt"
)

func TestPassword(t *testing.T) {
	password := "secret"
	hash, err := HashedPassword(password)
	require.NoError(t, err)
	require.NotEmpty(t, hash)
	require.NoError(t, CheckPassword(password, hash))

	wrongPassword := RandomString(6)
	err = CheckPassword(wrongPassword, hash)
	require.EqualError(t, err, bcrypt.ErrMismatchedHashAndPassword.Error())
}
