# dir_tree() works

    Code
      dir_tree("foo")
    Output
      foo
      \-- 1

---

    Code
      dir_tree("foo")
    Output
      foo
      +-- 1
      +-- 2
      +-- 3
      \-- 4

---

    Code
      dir_tree("foo")
    Output
      foo
      +-- 4
      +-- bar
      |   +-- 1
      |   \-- baz
      |       \-- 2
      \-- qux
          \-- 3

