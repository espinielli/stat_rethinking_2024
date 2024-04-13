# copy course material locally

# pak::pkg_install("alistaire47/read.so")
library(read.so)
library(tidyverse)
library(stringr)
library(here)
library(rvest)

# table from README.md
mat_tbl <- "
| Week ## | Meeting date | Reading | Lectures |
| ------- | -------------- | ------------- | ---------------------- |
| Week 01 | 05 January  | Chapters 1, 2 and 3 | [1] <[Science Before Statistics](https://www.youtube.com/watch?v=FdnMWdICdRs&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=1)> <[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-01)> <br> [2] <[Garden of Forking Data](https://www.youtube.com/watch?v=R1vcdhPBlXA&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=2)> <[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-02)>
| Week 02 | 12 January | Chapter 4 | [3] <[Geocentric Models](https://www.youtube.com/watch?v=tNOu-SEacNU&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=3)> <[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-03)> <br> [4] <[Categories and Curves](https://www.youtube.com/watch?v=F0N4b7K_iYQ&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=4)> <[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-04)>
| Week 03 | 19 January | Chapters 5 and 6 |  [5] <[Elemental Confounds](https://www.youtube.com/watch?v=mBEA7PKDmiY&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=5)> <[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-05)> <br> [6] <[Good and Bad Controls](https://www.youtube.com/watch?v=uanZZLlzKHw&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=6)> <[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-06)>
| Week 04 | 26 January | Chapters 7,8,9 | [7] <[Overfitting](https://www.youtube.com/watch?v=1VgYIsANQck&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=7)> <[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-07)> <br> [8] <[MCMC](https://www.youtube.com/watch?v=rZk2FqX2XnY&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=8)> <[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-08)>
| Week 05 | 02 February | Chapters 10 and 11 | [9] <[Modeling Events](https://www.youtube.com/watch?v=Zi6N3GLUJmw&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=9)> <[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-09)> <br> [10] <[Counts and Confounds](https://www.youtube.com/watch?v=jokxu18egu0&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=10)> <[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-10)>
| Week 06 | 09 February | Chapters 11 and 12 | [11] <[Ordered Categories](https://www.youtube.com/watch?v=VVQaIkom5D0&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=11)> <[Slides](https://github.com/rmcelreath/stat_rethinking_2023/raw/main/slides/Lecture_11-ord_logit.pdf)> <br> [12] <[Multilevel Models](https://www.youtube.com/watch?v=iwVqiiXYeC4&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=12)> <[Slides](https://raw.githubusercontent.com/rmcelreath/stat_rethinking_2023/main/slides/Lecture_12-GLMM1.pdf)>
| Week 07 | 16 February | Chapter 13 | [13] <[Multilevel Adventures](https://www.youtube.com/watch?v=sgqMkZeslxA&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=13)> <[Slides](https://raw.githubusercontent.com/rmcelreath/stat_rethinking_2023/main/slides/Lecture_13-GLMM2.pdf)> <br> [14] <[Correlated Features](https://www.youtube.com/watch?v=Es44-Bp1aKo&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=14)> <[Slides](https://github.com/rmcelreath/stat_rethinking_2023/raw/main/slides/Lecture_14-GLMM3.pdf)>
| Week 08 | 23 February | Chapter 14 | [15] <[Social Networks](https://www.youtube.com/watch?v=hnYhJzYAQ60&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=15)> <[Slides](https://github.com/rmcelreath/stat_rethinking_2023/raw/main/slides/Lecture_15-social_networks.pdf)> <br> [16] <[Gaussian Processes](https://www.youtube.com/watch?v=Y2ZLt4iOrXU&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=16)> <[Slides](https://github.com/rmcelreath/stat_rethinking_2023/raw/main/slides/Lecture_16-gaussian_processes.pdf)>
| Week 09 | 01 March | Chapter 15 | [17] <[Measurement](https://www.youtube.com/watch?v=mt9WKbQJrI4&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=17)> <[Slides](https://github.com/rmcelreath/stat_rethinking_2023/raw/main/slides/Lecture_17-measurement.pdf)> <br> [18] <[Missing Data](https://www.youtube.com/watch?v=Oeq6GChHOzc&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=18)> <[Slides](https://github.com/rmcelreath/stat_rethinking_2023/raw/main/slides/Lecture_18-missing_data.pdf)>
| Week 10 | 08 March | Chapters 16 and 17 | [19] <[Generalized Linear Madness](https://www.youtube.com/watch?v=zffwg0xDOgE&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=19)> <[Slides](https://github.com/rmcelreath/stat_rethinking_2023/raw/main/slides/Lecture_19-GenLinearMadness.pdf)> <br> [20] <[Horoscopes](https://www.youtube.com/watch?v=qwF-st2NGTU&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=20&pp=sAQB)> <[Slides](https://github.com/rmcelreath/stat_rethinking_2023/raw/main/slides/Lecture_20-horoscopes.pdf)>
"

mat <- read_md(mat_tbl) |>
  rename(week = 1, date = 2, chapters = 3) |>
  separate_wider_delim(Lectures, delim = "<br>", names = c("lesson_first", "lesson_second")) |>
  mutate(
    lesson_first = str_trim(lesson_first),
    lesson_second = str_trim(lesson_second)) |>
  pivot_longer(
    cols = !(1:3),
    names_to = "lesson_in_class",
    values_to = "url"
  ) |>
  select(-lesson_in_class) |>
  separate_wider_delim(url, delim = "] ", names = c("sequence", "links")) |>
  mutate(
    sequence = str_sub(sequence, 2, -1) |> str_trim() |> as.integer(),
    sequence = str_pad(sequence, width = 2, side = "left", pad = "0"),
    links = str_trim(links),
    date = paste0(date, " 2023")
  ) |>
  separate_wider_regex(links, c("^<", video = ".*", ">", " <", slides = ".*", ">$")) |>
  separate_wider_regex(video, c("^\\[", title = ".*", "\\]\\(", video_link = ".*", "\\)$")) |>
  separate_wider_regex(slides, c("^\\[", ".*", "\\]\\(", slides_link = ".*", "\\)$")) |>
  pivot_longer(
    c(video_link, slides_link),
    names_to = "type",
    values_to = "link",
    names_pattern = "(.*)_link") |>
  mutate(title = str_replace_all(title, " ", "-")) |>
  unite(col = title, c(sequence, title))



mat |>
  filter(type == "video") |>
  select(link) |>
  write_csv(here("video_urls.txt"), col_names = FALSE)

mat  |>
  filter(type == "slides") |>
  filter(str_detect(link, "speakerdeck") == TRUE) |>
  dplyr::select(title, link) -> df

purrr::pwalk(df, .f = function(title, link) {
  selector <- "a[title='Download PDF']"
  file <- link |>
    httr::parse_url() |>
    magrittr::use_series("path") |>
    stringr::str_split("/") |>
    magrittr::extract2(1) |>
    magrittr::extract(2) |>
    stringr::str_c(".pdf")
  link |>
    read_html() |>
    html_elements("a[title='Download PDF']") |>
    html_attr("href") |>
    download.file(here::here("slides", paste0("Lecture_", title, ".pdf")))
})




