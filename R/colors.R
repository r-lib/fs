# from defaults of dircolors version 8.28
gnu_ls_defaults <- "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*.R=32:*.r=32:*.Rmd=32"

# LS mappings are at https://github.com/wertarbyte/coreutils/blob/f70c7b785b93dd436788d34827b209453157a6f2/src/dircolors.c#L60-L75

#' @importFrom stats setNames
colourise_fs_filename <- function(x, ..., colors = Sys.getenv("LS_COLORS", gnu_ls_defaults)) {
  if (length(x) == 0 || !has_color()) {
    return(x)
  }

  perms <- file_info(x)$permissions

  vals <- strsplit(colors, ":")[[1]]
  nms <- strsplit(vals, "=")
  map <- setNames(
    vapply(nms, `[[`, character(1), 2),
    vapply(nms, `[[`, character(1), 1))
  file_types <- map[grepl("^[*][.]", names(map))]
  names(file_types) <- sub("^[*][.]", "", names(file_types))
  res <- character(length(x))

  for (i in seq_along(x)) {
    code <- map[file_code_(x[[i]], perms[[i]])]
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

new_fs_filename <- function(x) {
  structure(enc2utf8(x), class = c("fs_filename", "character"))
}

#' @export
print.fs_filename <- function(x, ..., max = getOption("max.print")) {
  x <- x[seq_len(min(length(x), max))]
  cat(multicol(colourise_fs_filename(x, ...)), sep = "")

  invisible(x)
}

#' @export
`[.fs_filename` <- function(x, i) {
  new_fs_filename(NextMethod("["))
}

pillar_shaft.fs_filename <- function(x, ...) {
  pillar::new_pillar_shaft_simple(colourise_fs_filename(x), ...)
}

type_sum.fs_filename <- function(x) {
  "fs::filename"
}

has_color <- function() {
  requireNamespace("crayon") && crayon::has_color()
}

# From gaborcsardi/crayon/R/utils.r
multicol <- function(x) {
  xs <- if (has_color()) crayon::strip_style(x) else x
  max_len <- max(nchar(xs, keepNA = FALSE)) + 1
  to_add <- max_len - nchar(xs, keepNA = FALSE)
  x <- paste0(x, substring(paste0(collapse = "", rep(" ", max_len)), 1, to_add))
  screen_width <- getOption("width")
  num_cols <- max(trunc(screen_width / max_len), 1)
  num_rows <- ceiling(length(x) / num_cols)
  x <- c(x, rep("", num_cols * num_rows - length(x)))
  xm <- matrix(x, ncol = num_cols, byrow = TRUE)
  paste0(apply(xm, 1, paste0, collapse = ""), "\n")
}
