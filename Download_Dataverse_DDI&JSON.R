# Library ####

library(dataverse)
library(xml2)

# Dirs ####

setwd("C:/Users/vaida/OneDrive - Kaunas University of Technology/DAtA centras/Dataverse/R_scripts/Save_DDI&JSON_files/")
dir()

# Set general info ----

ddi.api.link <- "https://lida.dataverse.lt/api/datasets/export?exporter=ddi"
json.api.link <- "https://lida.dataverse.lt/api/datasets/export?exporter=dataverse_json"
dataset.handle <- "hdl:21.12137/5SAURM"
dataverse.server <- "https://lida.dataverse.lt"
saving.dir <- "files/"

# Get LiDA ID & version ----

dataset.info <- 
  get_dataset(dataset=dataset.handle,
              version=":latest-published", # ":draft" (the current draft), ":latest" (the latest draft, if it exists, or the latest published version), ":latest-published" (the latest published version, ignoring any draft), or "x.y" (where x is a major version and y is a minor version; the .y can be omitted to obtain a major version).
              server=dataverse.server)

dataset.lida.id <- 
  t(dataset.info$metadataBlocks$citation$fields$value[
    grep("otherIdAgency",x=dataset.info$metadataBlocks$citation$fields$value)
  ][[1]])["otherIdValue.value",]

dataset.lida.version <- paste0(dataset.info$versionNumber,
                               ".",
                               dataset.info$versionMinorNumber)

# Download ----

# Download: DDI ----

dataset.ddi <- 
  read_xml(paste0(ddi.api.link,"&persistentId=",dataset.handle))

# Download: JSON ----

dataset.json <- 
  readLines(paste0(json.api.link,"&persistentId=",dataset.handle))

# Save ----

# Save: DDI ----

write_xml(dataset.ddi,
          paste0(saving.dir,
                 dataset.lida.id,
                 "_Metadata_DDI_Codebook_2.5_v",
                 dataset.lida.version,
                 ".xml"))

# Save: JSON ----

writeLines(dataset.json,
           paste0(saving.dir,
                  dataset.lida.id,
                  "_Metadata_DVN_JSON_v",
                  dataset.lida.version,
                  ".json"))

# End ####
