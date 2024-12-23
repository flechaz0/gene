library(readr)

#只有以下3行要改
setwd("D:/Desktop/code/R working track/gene_annotation")# 工作路径
species <- "Cpu" # 输入要分析的物种缩写（如：rty）
data_type <- "gene" # 输入要分析的数据类型（对应文件名：gene 或 transcript）

spe_data <- paste(species, data_type, sep = ".")

annotation_file_name <- paste(species, "mixlength.fasta.emapper.annotations", sep = "_")

annotations <- read.table(annotation_file_name, header = FALSE, sep = "\t", stringsAsFactors = FALSE)

colnames(annotations)[1] <- "GeneID" # 第一列命名为GeneID
colnames(annotations)[9] <- "GeneName" # 第九列命名为GeneName

annotations$GeneID_Core <- sub(".*?_(.*)_.*", "\\1", annotations$GeneID)
# 读取csv文件
expression_data <- read.csv(paste(spe_data, "_count_matrix.csv", sep = ""), header = TRUE, stringsAsFactors = FALSE)


# 假设第一列是基因序号，第二列是基因表达量
colnames(expression_data)[1] <- "GeneID" # 第一列命名为GeneID
colnames(expression_data)[2] <- "Expression" # 第二列命名为Expression

# 合并两个数据框
merged_data <- merge(expression_data, annotations[, c("GeneID_Core", "GeneName")],
                     by.x = "GeneID", by.y = "GeneID_Core", all.x = TRUE)


final_data <- merged_data[, c("GeneName", "Expression")]

final_data <- final_data %>%
  filter(GeneName != "-" & !is.na(GeneName)) %>%
  group_by(GeneName) %>%
  slice_max(Expression, n = 1) %>%
  ungroup() %>%
  distinct(GeneName, .keep_all = TRUE)  

output_file_name <- paste(spe_data,"_Annotated.csv",sep = "")

save_to_csv <- function(data, file) {
  write_csv(data, file)
  print(paste("文件已保存到：", file))
}

save_to_csv(final_data, output_file_name)

