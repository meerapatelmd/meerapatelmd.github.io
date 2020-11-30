library(tidyverse)
nm_map <-
tibble::tribble(
        ~machine_name, ~human_name,
   "CELLULAR_THERAPY", "Cellular Therapy",
   "CYTOTOXIC_CHEMOTHERAPY", "Cytotoxic Chemotherapy",
   "ENDOCRINE_THERAPY", "Endocrine Therapy",
   "IMMUNOTHERAPY_ANTIBODY_DRUG_CONJUGATE", "Antibody Drug Conjugates",
   "IMMUNOTHERAPY_CHECKPOINT_INHIBITOR", "Checkpoint Inhibitors",
   "IMMUNOTHERAPY_IMMUNOMODULATOR_AND_IMMUNOSTIMULANTS_EXCLUDING_IMMUNOSUPPRESSANTS", "Immunomodulators and Immunostimulants",
   "IMMUNOTHERAPY_MONOCLONAL_ANTIBODY_TARGETED_THERAPY", "Monoclonal Antibody Targeted Therapy",
   "IMMUNOTHERAPY_OTHER", "Other Immunotherapy",
   "INTRAVESICULAR_THERAPY", "Intravesicular Therapy")

# Replace "collapsibleTree" with human_name
files <- list.files(path = "Site", full.names = TRUE)
file_map <-
tibble(files = files) %>%
        mutate(machine_name = stringr::str_remove_all(basename(files), "_with.*$")) %>%
        left_join(nm_map) %>%
        mutate(plot_type = ifelse(grepl("without", files), "Without Siblings", "With Siblings")) %>%
        mutate(plot_type = factor(plot_type, levels = c("Without Siblings", "With Siblings"))) %>%
        arrange(machine_name, plot_type) %>%
        mutate(plot_type = as.character(plot_type)) %>%
        mutate(files2 = tolower(paste0(human_name, " ", plot_type, ".html"))) %>%
        mutate(files2 = stringr::str_replace_all(files2, pattern = " ", replacement = "_")) %>%
        mutate(title = human_name) %>%
        mutate(header = paste0("document.write('<left><h1>", human_name, ": ", plot_type, "</font></h1></left>')")) %>%
        mutate(header_file = stringr::str_replace_all(files2, pattern = "[.]{1}html$", replacement = "_header.txt")) %>%
        mutate(header_reference = paste0('<script language="javascript" type="text/javascript" src="', header_file,'"></script>')) %>%
        mutate(files3 = tolower(paste0(human_name,".html"))) %>%
        mutate(files3 = stringr::str_replace_all(files3, pattern = " ", replacement = "_"))

for (i in 1:nrow(file_map)) {

        file             <- file_map$files[i]
        op_file          <- file_map$files2[i]
        header           <- file_map$header[i]
        header_file      <- file_map$header_file[i]
        header_reference <- file_map$header_reference[i]

        # Write header file
        cat(header,
            file = header_file)

        # Add Header reference to html
        html <- read_lines(file = file)
        # Finding index to where the new line should be added after
        index <- grep(pattern = "<title>collapsibleTree", x = html)[1]

        new_html <-
                c(html[1:index],
                  header_reference,
                  html[(index+1):length(html)])


        cat(new_html,
            file = op_file,
            sep = "\n")


}


for (i in 1:nrow(file_map)) {

        file     <- file_map$files2[i]
        op_file  <- file_map$files2[i]
        title    <- file_map$title[i]


        # Add Header reference to html
        html <- read_lines(file = file)
        new_html <- html

        # Finding index to where the new line should be added after
        index <- grep(pattern = "<title>collapsibleTree", x = html)[1]
        new_html[index] <- stringr::str_replace(html[index], pattern = "collapsibleTree", replacement = title)

        cat(new_html,
            file = op_file,
            sep = "\n")

}

file_map <-
        file_map %>%
        rubix::split_deselect(col = files3)

for (i in seq_along(file_map)) {

        op_file <- names(file_map)[i]
        source_files <- file_map[[i]]$files2

        output <-
                source_files %>%
                purrr::map(readLines) %>%
                unlist() %>%
                paste(collapse = "\n")

        cat(output,
            file = op_file)

}


file_map <-
        tibble(files = files) %>%
        mutate(machine_name = stringr::str_remove_all(basename(files), "_with.*$")) %>%
        left_join(nm_map) %>%
        mutate(plot_type = ifelse(grepl("without", files), "Without Siblings", "With Siblings")) %>%
        mutate(plot_type = factor(plot_type, levels = c("Without Siblings", "With Siblings"))) %>%
        arrange(machine_name, plot_type) %>%
        mutate(plot_type = as.character(plot_type)) %>%
        mutate(files2 = tolower(paste0(human_name, " ", plot_type, ".html"))) %>%
        mutate(files2 = stringr::str_replace_all(files2, pattern = " ", replacement = "_")) %>%
        mutate(title = human_name) %>%
        mutate(header = paste0("document.write('<left><h1>", human_name, ": ", plot_type, "</font></h1></left>')")) %>%
        mutate(header_file = stringr::str_replace_all(files2, pattern = "[.]{1}html$", replacement = "_header.txt")) %>%
        mutate(header_reference = paste0('<script language="javascript" type="text/javascript" src="', header_file,'"></script>')) %>%
        mutate(files3 = tolower(paste0(human_name,".html"))) %>%
        mutate(files3 = stringr::str_replace_all(files3, pattern = " ", replacement = "_")) %>%
        select(files3) %>%
        distinct() %>%
        unlist() %>%
        purrr::map(~ paste0("_site/", .)) %>%
        unlist()


output_file <- "temp.Rmd"
for (i in seq_along(file_map)) {
        output <-
        sprintf("

                ```{r %s,echo=FALSE,eval=TRUE}
                htmltools::includeHTML(%s)
                ```
                ",
                        broca::strip_ext(basename(file_map[i])),
                        file_map[i])

        cat(output,
            file = output_file,
            append = TRUE)
}
