# vectorized

    Code
      path_select_components(path, 1:3)
    Output
      some/simple/path another/path/to  
    Code
      path_select_components(path, 1:3, "end")
    Output
      to/a/file.txt     path/to/file2.txt 
    Code
      path_select_components(path, integer())
    Output
        
    Code
      unclass(path_select_components(path, integer()))
    Output
      [1] "" ""
    Code
      path_select_components(fs_path(character()), 1:3)
    Output
      character(0)
    Code
      path_select_components(fs_path(character()), 1:3, "end")
    Output
      character(0)
    Code
      class(path_select_components(fs_path(character()), 1:3))
    Output
      [1] "fs_path"   "character"
    Code
      class(path_select_components(fs_path(character()), 1:3, "end"))
    Output
      [1] "fs_path"   "character"

