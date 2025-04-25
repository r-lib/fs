# file_chmod: errors if given an invalid mode

    Code
      file_chmod("foo", "g+S")
    Condition
      Error:
      ! Invalid mode 'g+S'

