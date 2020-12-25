
file_map <-
tibble::tribble(
                ~files,~machine_name,~human_name,~plot_type,
                "widgets/CELLULAR_THERAPY_without_siblings_2_to_2.html", "CELLULAR_THERAPY", "Cellular Therapy", "Without Siblings",
                "widgets/CELLULAR_THERAPY_with_siblings.html", "CELLULAR_THERAPY", "Cellular Therapy", "With Siblings",
                "widgets/CYTOTOXIC_CHEMOTHERAPY_without_siblings_2_to_2.html", "CYTOTOXIC_CHEMOTHERAPY", "Cytotoxic Chemotherapy", "Without Siblings",
                "widgets/CYTOTOXIC_CHEMOTHERAPY_with_siblings.html", "CYTOTOXIC_CHEMOTHERAPY", "Cytotoxic Chemotherapy", "With Siblings",
                "widgets/ENDOCRINE_THERAPY_without_siblings_2_to_2.html", "ENDOCRINE_THERAPY", "Endocrine Therapy", "Without Siblings",
                "widgets/ENDOCRINE_THERAPY_with_siblings.html", "ENDOCRINE_THERAPY", "Endocrine Therapy", "With Siblings",
                "widgets/IMMUNOTHERAPY_ANTIBODY_DRUG_CONJUGATE_without_siblings_2_to_2.html", "IMMUNOTHERAPY_ANTIBODY_DRUG_CONJUGATE", "Antibody Drug Conjugates", "Without Siblings",
                "widgets/IMMUNOTHERAPY_ANTIBODY_DRUG_CONJUGATE_with_siblings.html", "IMMUNOTHERAPY_ANTIBODY_DRUG_CONJUGATE", "Antibody Drug Conjugates", "With Siblings",
                "widgets/IMMUNOTHERAPY_CHECKPOINT_INHIBITOR_without_siblings_2_to_2.html", "IMMUNOTHERAPY_CHECKPOINT_INHIBITOR", "Checkpoint Inhibitors", "Without Siblings",
                "widgets/IMMUNOTHERAPY_CHECKPOINT_INHIBITOR_with_siblings.html", "IMMUNOTHERAPY_CHECKPOINT_INHIBITOR", "Checkpoint Inhibitors", "With Siblings",
                "widgets/IMMUNOTHERAPY_IMMUNOMODULATOR_AND_IMMUNOSTIMULANTS_EXCLUDING_IMMUNOSUPPRESSANTS_without_siblings_2_to_2.html", "IMMUNOTHERAPY_IMMUNOMODULATOR_AND_IMMUNOSTIMULANTS_EXCLUDING_IMMUNOSUPPRESSANTS", "Immunomodulators and Immunostimulants", "Without Siblings",
                "widgets/IMMUNOTHERAPY_IMMUNOMODULATOR_AND_IMMUNOSTIMULANTS_EXCLUDING_IMMUNOSUPPRESSANTS_with_siblings.html", "IMMUNOTHERAPY_IMMUNOMODULATOR_AND_IMMUNOSTIMULANTS_EXCLUDING_IMMUNOSUPPRESSANTS", "Immunomodulators and Immunostimulants", "With Siblings",
                "widgets/IMMUNOTHERAPY_MONOCLONAL_ANTIBODY_TARGETED_THERAPY_without_siblings_2_to_2.html", "IMMUNOTHERAPY_MONOCLONAL_ANTIBODY_TARGETED_THERAPY", "Monoclonal Antibody Targeted Therapy", "Without Siblings",
                "widgets/IMMUNOTHERAPY_MONOCLONAL_ANTIBODY_TARGETED_THERAPY_with_siblings.html", "IMMUNOTHERAPY_MONOCLONAL_ANTIBODY_TARGETED_THERAPY", "Monoclonal Antibody Targeted Therapy", "With Siblings",
                "widgets/IMMUNOTHERAPY_OTHER_without_siblings_2_to_2.html", "IMMUNOTHERAPY_OTHER", "Other Immunotherapy", "Without Siblings",
                "widgets/IMMUNOTHERAPY_OTHER_with_siblings.html", "IMMUNOTHERAPY_OTHER", "Other Immunotherapy", "With Siblings",
                "widgets/INTRAVESICULAR_THERAPY_without_siblings_2_to_2.html", "INTRAVESICULAR_THERAPY", "Intravesicular Therapy", "Without Siblings",
                "widgets/INTRAVESICULAR_THERAPY_with_siblings.html", "INTRAVESICULAR_THERAPY", "Intravesicular Therapy", "With Siblings"
)

file_map2 <-
        file_map %>%
        rubix::split_deselect(col = human_name)


for (i in seq_along(file_map2)) {

        nm <- names(file_map2)[i]

        cat(sprintf("\n\n### %s  \n", nm),
            file = "projects/Cancer Drug Classifications/index.Rmd",
            append = TRUE)

        for (j in seq_along(file_map2[[i]]$plot_type)) {

                sub_nm <- file_map2[[i]]$plot_type[j]

                cat(sprintf("\n\n#### %s  \n\n", sub_nm),
                    file = "projects/Cancer Drug Classifications/index.Rmd",
                    append = TRUE)

                path   <- file_map2[[i]]$files[j]

                cat(sprintf("```{r,echo=FALSE}\nhtmltools::includeHTML('%s')\n```\n\n", path),
                    file = "projects/Cancer Drug Classifications/index.Rmd",
                    append = TRUE)

        }
}
