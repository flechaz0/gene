library(dplyr)

#以下4行需要修改
setwd("D:/Desktop/code/R working track/gene_annotation")# 工作路径
spe1 <- "Cid" # 物种1
spe2 <- "Cpu" # 物种2
data_type <-"transcript" # gene or transcript

# 读取两个物种的基因注释文件
species1 <- read.csv(paste(paste(spe1,data_type,sep = "."),"_Annotated.csv",sep = ""))
species2 <- read.csv(paste(paste(spe2,data_type,sep = "."),"_Annotated.csv",sep = ""))

# 确保GeneName列是字符型，以便后续匹配
species1$GeneName <- as.character(species1$GeneName)
species2$GeneName <- as.character(species2$GeneName)

species1 <- species1 %>% filter(!is.na(GeneName) & GeneName != "-")
species2 <- species2 %>% filter(!is.na(GeneName) & GeneName != "-")

# 合并两个物种的数据框，按GeneName进行匹配
merged_data <- merge(species1, species2, by = "GeneName", suffixes = c("_species1", "_species2"))


# 计算log2 fold change: log2(expression_species1 / expression_species1)
merged_data$log2foldchange <- ifelse(
  merged_data$Expression_species1 == 0 & merged_data$Expression_species2 == 0,
  "both are zero",
  ifelse(
    merged_data$Expression_species1 == 0,
    "species1 is zero",
    ifelse(
      merged_data$Expression_species2 == 0,
      "species2 is zero",
      log2(merged_data$Expression_species1 / merged_data$Expression_species2)
    )
  )
)

# 选择需要的列
result <- merged_data %>%
  select(GeneName, log2foldchange)

# 保存结果到新的CSV文件
write.csv(result, "log2foldchange_comparison.csv", row.names = FALSE)

# 输出结果
head(result)
