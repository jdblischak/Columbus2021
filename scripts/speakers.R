#!/usr/bin/env Rscript

# Convert Google spreadsheet into separate TOML files per speaker. These files
# go in data/schedule/

x <- read.csv("speakers.csv", stringsAsFactors = FALSE)
colnames(x) <- c("timestamp", "name", "email", "title", "description",
                 "presented", "experience", "ohio", "more", "github", "twitter",
                 "linkedin")
# Sort by alphabetical order
x <- x[order(x$name), ]
x$id <- gsub("[[:space:]]", "-", x$name)
x$id <- tolower(x$id)

x$description <- gsub("\\n", "", x$description)

# Create social links
x$twitter <- sub("^https://twitter.com/", "", x$twitter)
x$twitter <- sub("^@", "", x$twitter)
x$twitter <- ifelse(x$twitter == "", x$twitter,
                    sprintf("[\"fa-twitter\", \"https://twitter.com/%s\"],",
                            x$twitter))
x$github <- sub("^https://github.com/", "", x$github)
x$github <- ifelse(x$github == "", x$github,
                    sprintf("[\"fa-github\", \"https://github.com/%s\"],",
                            x$github))
x$linkedin <- sub("^https://www.linkedin.com/in/", "", x$linkedin)
x$linkedin <- ifelse(x$linkedin == "", x$linkedin,
                     sprintf("[\"fa-linkedin\", \"https://www.linkedin.com/in/%s\"],",
                             x$linkedin))

outdir <- "schedule"
dir.create(outdir, showWarnings = FALSE)
x$toml <- file.path(outdir, sprintf("Talk%02d.toml", seq_len(nrow(x))))

for (i in seq_len(nrow(x))) {
  print(x$name[i])
  writeLines(
    c(
      "[talk_details]",
      sprintf("modalID = %d", i),
      sprintf("title = \"%s\"", x$title[i]),
      sprintf("subtitle = \"%s\"", x$name[i]),
      "date = 2021-10-02",
      "startsAt = \"00:00:00\"",
      "endsAt = \"00:01:00\"",
      "img = \"\"",
      "preview = \"Rlogo.png\"",
      "category = \"Category 1\"",
      sprintf("description = \"%s\"", x$description[i]),
      "talk = true",
      "",
      "[speaker]",
      sprintf("name = \"%s\"", x$name[i]),
      "organisation = \"\"",
      "role = \"\"",
      "img = \"\"",
      "bio = \"\"",
      "social = [",
      sprintf("  %s", x$twitter[i]),
      sprintf("  %s", x$github[i]),
      sprintf("  %s", x$linkedin[i]),
      "]",
      "link = \"#\""
    ),
    con = x$toml[i]
  )
}
