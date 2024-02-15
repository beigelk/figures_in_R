gsea_genes_all = read_tsv("MSigDB_overlap_table.tsv") %>% mutate(`Gene Set Name` = fct_reorder(`Gene Set Name`, `k/K`))

ggplot(gsea_genes_all, aes(x = `k/K`, y = `Gene Set Name`, color = -log10(`FDR q-value`), size = `# Genes in Overlap (k)`)) +
  geom_point(stat = 'identity') + 
  xlab("Gene ratio (# Genes in Overlap / # Genes in Gene Set") + ylab("Pathway") + ggtitle("") + 
  theme_bw() +
  scale_color_gradient(low = "blue", high = "red")
