#' File paths
#'
#' @description
#' Tidy file paths, character vectors which are coloured by file type on
#' capable terminals.
#'
#' Colouring can be customized by setting the `LS_COLORS` environment variable,
#' the format is the same as that read by GNU ls / dircolors.
#'
#' Colouring of file paths can be disabled by setting `LS_COLORS` to an empty
#' string e.g. `Sys.setenv(LS_COLORS = "")`.
#' @param x vector to be coerced to a fs_path object.
#' @seealso
#' <https://geoff.greer.fm/lscolors>,
#' <https://github.com/trapd00r/LS_COLORS>,
#' <https://github.com/seebi/dircolors-solarized> for some example colour
#' settings.
#' @export
#' @name fs_path
as_fs_path <- function(x) {
  UseMethod("as_fs_path")
}

#' @export
as_fs_path.NULL <- function(x) {
  new_fs_path(character())
}

#' @export
as_fs_path.character <- function(x) {
  path_tidy(x)
}

#' @rdname fs_path
#' @export
fs_path <- as_fs_path

new_fs_path <- function(x) {
  x <- enc2utf8(x)
  class(x) <- c("fs_path", "character")
  x
}
setOldClass(c("fs_path", "character"), character())

#' @export
print.fs_path <- function(x, ..., max = getOption("max.print")) {
  x <- x[seq_len(min(length(x), max))]
  if (length(x) == 0) {
    print(character(0))
  } else {
    cat(multicol(colourise_fs_path(x, ...)), sep = "")
  }

  invisible(x)
}

#' @export
`[.fs_path` <- function(x, i, ...) {
  new_fs_path(NextMethod("["))
}

#' @export
`[[.fs_path` <- function(x, i, ...) {
  new_fs_path(NextMethod("["))
}

#' @export
`/.fs_path` <- function(e1, e2) {
  path(e1, e2)
}

#' @export
`+.fs_path` <- function(e1, e2) {
  new_fs_path(paste0(e1, e2))
}

pillar_shaft.fs_path <- function(
  x,
  ...,
  min_width = 10,
  shorten = getOption("fs.fs_path.shorten", "front")
) {
  pillar::new_pillar_shaft_simple(
    colourise_fs_path(x),
    ...,
    min_width = min_width,
    shorten = shorten
  )
}

type_sum.fs_path <- function(x) {
  "fs::path"
}

has_color <- function() {
  requireNamespace("crayon", quietly = TRUE) && crayon::has_color()
}

# From gaborcsardi/crayon/R/utils.r
multicol <- function(x) {
  if (length(x) == 0) {
    return(character())
  }
  xs <- if (has_color()) crayon::strip_style(x) else x
  max_len <- max(nchar(xs, keepNA = FALSE)) + 1
  screen_width <- getOption("width")
  num_cols <- min(length(x), max(trunc(screen_width / max_len), 1))
  if (num_cols > 1) {
    to_add <- max_len - nchar(xs, keepNA = FALSE)
    x <- paste0(
      x,
      substring(paste0(collapse = "", rep(" ", max_len)), 1, to_add)
    )
  }
  num_rows <- ceiling(length(x) / num_cols)
  x <- c(x, rep("", num_cols * num_rows - length(x)))
  xm <- matrix(x, ncol = num_cols, byrow = TRUE)
  paste0(apply(xm, 1, paste0, collapse = ""), "\n")
}

# from defaults of dircolors version 8.28
gnu_ls_defaults <- "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*.R=32:*.r=32:*.Rmd=32"

# LS mappings are at https://github.com/wertarbyte/coreutils/blob/f70c7b785b93dd436788d34827b209453157a6f2/src/dircolors.c#L60-L75

#' @importFrom stats setNames na.omit
colourise_fs_path <- function(
  x,
  ...,
  colors = Sys.getenv("LS_COLORS", gnu_ls_defaults)
) {
  if (length(x) == 0 || !has_color() || !nzchar(colors)) {
    return(x)
  }

  perms <- try(file_info(x)$permissions, silent = TRUE)

  if (inherits(perms, "try-error")) {
    return(x)
  }

  vals <- strsplit(colors, ":")[[1]]
  nms <- strsplit(vals, "=")

  if (
    !(length(vals) == length(nms) &&
      all(lengths(nms) == 2))
  ) {
    return(x)
  }

  map <- setNames(
    vapply(nms, `[[`, character(1), 2),
    vapply(nms, `[[`, character(1), 1)
  )
  file_types <- map[grepl("^[*][.]", names(map))]
  names(file_types) <- sub("^[*][.]", "", names(file_types))
  res <- character(length(x))

  for (i in seq_along(x)) {
    code <- map[.Call(fs_file_code_, x[[i]], as.integer(perms[[i]]))]
    if (is.na(code)) {
      code <- file_types[na.omit(tools::file_ext(x[[i]]))]
    }
    if (length(code) > 0 && !is.na(code)) {
      res[[i]] <- paste0("\033[", code, "m", x[[i]], "\033[0m")
    } else {
      res[[i]] <- x[[i]]
    }
  }
  res
}

#' @export
xtfrm.fs_path <- function(x, ...) {
  x <- unclass(x)
  NextMethod("xterm")
}

# All functions below registered in .onLoad

vec_ptype2.fs_path.fs_path <- function(x, y, ...) {
  x
}
vec_ptype2.fs_path.character <- function(x, y, ...) {
  x
}
vec_ptype2.character.fs_path <- function(x, y, ...) {
  y
}

# Note order of class is the opposite as for ptype2
vec_cast.fs_path.fs_path <- function(x, to, ...) {
  x
}
vec_cast.fs_path.character <- function(x, to, ...) {
  as_fs_path(x)
}
vec_cast.character.fs_path <- function(x, to, ...) {
  unclass(x)
}
