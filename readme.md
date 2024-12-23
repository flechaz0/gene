GENE.R >>>>>>> 用于结合注释文件将通用基因名与表达量结合起来，生成对应文件

Compare.R >>>>>>> 用于两两比较表达量并计算log2foldchange值


先用GENE文件生成了对应的表达量文件才可以用Compare文件


每个文件使用时只需要修改前面几行，工作路径、输入物种名（就是文件名前面的缩写）、数据类型（就是gene或transcript）



默认使用的文件名为  (物种缩写).(gene/transcript)_count_matrix   &  (物种缩写)_mixlength.fasta.emapper.annotations
例如：Cid.transcript_count_matrix.csv，rty.gene_count_matrix.csv
