# as_fs_perms (POSIX): coerces doubles to integers

    Code
      as_fs_perms(420.5)
    Condition
      Error:
      ! 'x' cannot be coerced to class "fs_perms"

# as_fs_perms (POSIX): coerces characters in octal notation

    Code
      as_fs_perms("777777")
    Condition
      Error:
      ! Invalid mode '777777'

