#!/usr/bin/env Rscript

# Reduce headshots to 200x200 pixels. I first manually cropped non-square
# headshots to be square using Paint 3D.

library("magick")

dirin <- "square"
dirout <- "200x200"
stopifnot(dir.exists(dirin))
dir.create(dirout, showWarnings = FALSE)

headshots <- dir(dirin)

for (headshot in headshots) {
  original <- image_read(file.path(dirin, headshot))
  reduced <- image_resize(original, "200x200")
  path_out <- headshot
  path_out <- gsub("_", "-", path_out)
  path_out <- gsub("jpeg$", "jpg", path_out)
  path_out <- file.path(dirout, path_out)
  image_write(reduced, path_out)
}
