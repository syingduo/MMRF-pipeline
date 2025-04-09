# set up dirctory and load library
setwd("/diskmnt/Projects/Users/s.yingduo/06MMRF/analysis/new")
library(ggplot2)
library(cowplot)
library(stringr)

## read in data
p5 <- read.table("qc_5p.txt", header = T)
bcr <- read.table("qc_bcr.txt", header = T)
tcr <- read.table("qc_tcr.txt", header = T)

## number of samples in 3 assay
sample_id <- character()
assay <- c("5P", "BCR", "TCR")
sample_number <- c(nrow(p5), nrow(bcr), nrow(tcr))
tmp <- data.frame(assay, sample_number)

theme_bar <- function(..., bg = "white") {
    require(grid)
    theme_classic(...) +
        theme(
            rect = element_rect(fill = bg),
            plot.margin = unit(rep(0.5, 4), "lines"),
            panel.background = element_rect(fill = "transparent", color = "black"),
            panel.border = element_rect(fill = "transparent", color = "transparent"),
            panel.grid = element_blank(), # 去网格线
            axis.title.x = element_blank(), # 去x轴标签,
            axis.title.y = element_blank(),
            # axis.title.y = element_text(face = "bold", size = 8), # y轴标签加粗及字体大小
            axis.text = element_text(face = "bold", size = 10), # 坐标轴刻度标签加粗
            # axis.ticks = element_line(color='black'),#坐标轴刻度线
            # axis.ticks.margin = unit(0.8,"lines"),
            legend.title = element_blank(), # 去除图例标题
            # legend.justification=c(1,0),#图例在画布的位置(绘图区域外)
            legend.position = c(0.39, 0.76), # 图例在绘图区域的位置
            # legend.position='top',#图例放在顶部
            legend.direction = "horizontal", # 设置图例水平放置
            # legend.spacing.x = unit(2, 'cm'),
            legend.text = element_text(face = "bold", size = 11, margin = margin(r = 20)),
            legend.background = element_rect(linetype = "solid", colour = "black"),
            # legend.margin=margin(0,0,-7,0)#图例与绘图区域边缘的距离
            # legend.box.margin =margin(-10,0,0,0)
            plot.title = element_text(size = 14, hjust = 0.5)
        )
}

## 1. sample number
pdf("number of samples.pdf")
ggplot(tmp, mapping = aes(x = assay, y = sample_number)) +
    geom_bar(
        stat = "identity",
        fill = "#00AFBB",
        width = 0.4
    ) +
    geom_text(aes(label = sample_number), size = 5, vjust = -0.5) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 150), breaks = seq(0, 150, 10)) +
    labs(title = "Sample number under 3 assays") +
    theme_bar()
dev.off()

## 2. 5p
theme_bar <- function(..., bg = "white") {
    require(grid)
    theme_classic(...) +
        theme(
            rect = element_rect(fill = bg),
            plot.margin = unit(rep(0.5, 4), "lines"),
            panel.background = element_rect(fill = "transparent", color = "black"),
            panel.border = element_rect(fill = "transparent", color = "transparent"),
            panel.grid = element_blank(), # 去网格线
            axis.title.x = element_blank(), # 去x轴标签,
            axis.title.y = element_blank(),
            # axis.title.y = element_text(face = "bold", size = 8), # y轴标签加粗及字体大小
            axis.text.y = element_text(face = "bold", size = 10), # 坐标轴刻度标签加粗
            axis.ticks.x = element_blank(), # 坐标轴刻度线
            # axis.ticks.margin = unit(0.8,"lines"),
            axis.text.x = element_text(size = 7.5, face = "bold", angle = 65, hjust = 1, vjust = 1),
            legend.title = element_blank(), # 去除图例标题
            # legend.justification=c(1,0),#图例在画布的位置(绘图区域外)
            legend.position = c(0.39, 0.76), # 图例在绘图区域的位置
            # legend.position='top',#图例放在顶部
            legend.direction = "horizontal", # 设置图例水平放置
            # legend.spacing.x = unit(2, 'cm'),
            legend.text = element_text(face = "bold", size = 11, margin = margin(r = 20)),
            legend.background = element_rect(linetype = "solid", colour = "black"),
            # legend.margin=margin(0,0,-7,0)#图例与绘图区域边缘的距离
            # legend.box.margin =margin(-10,0,0,0)
            plot.title = element_text(size = 11, face = "bold", hjust = 0.5, vjust = -6.5)
        )
}

p1 <- ggplot(p5, mapping = aes(x = reorder(sample_id, -Estimated.Number.of.Cells), y = Estimated.Number.of.Cells)) +
    geom_bar(
        stat = "identity",
        fill = "#00AFBB",
        width = 0.6
    ) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 20 * 1000), breaks = seq(0, 20 * 1000, 1000)) +
    labs(title = "Number of cells") +
    annotate("text",
        x = 120, y = 18000, label = paste0("Mean: ", round(mean(p5$Estimated.Number.of.Cells), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    annotate("text",
        x = 121, y = 17000, label =
            paste0("SD: ", round(sd(p5$Estimated.Number.of.Cells), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    theme_bar() +
    theme(axis.text.x = element_blank())

p2 <- ggplot(p5, mapping = aes(x = reorder(sample_id, -Estimated.Number.of.Cells), y = Mean.Reads.per.Cell)) +
    geom_bar(
        stat = "identity",
        fill = "#FFB300",
        width = 0.6
    ) +
    scale_y_continuous(
        expand = c(0, 0),
        limits = c(0, 100 * 7500),
        breaks = seq(0, 100 * 7500, 75000),
        labels = c("0", "75k", "150k", "225k", "300k", "375k", "450k", "525k", "600k", "675k", "750k")
    ) +
    labs(title = "Mean reads per cell") +
    annotate("text",
        x = 120, y = 675 * 1000, label = paste0("Mean: ", round(mean(p5$Mean.Reads.per.Cell), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    annotate("text",
        x = 120.7, y = 635 * 1000, label =
            paste0("SD: ", round(sd(p5$Mean.Reads.per.Cell), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    theme_bar() +
    theme(axis.text.x = element_blank())

p3 <- ggplot(p5, mapping = aes(x = reorder(sample_id, -Estimated.Number.of.Cells), y = Median.Genes.per.Cell)) +
    geom_bar(
        stat = "identity",
        fill = "#FA2017",
        width = 0.6
    ) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 10 * 300), breaks = seq(0, 10 * 300, 300)) +
    labs(title = "Median genes per cell") +
    annotate("text",
        x = 120, y = 2700, label = paste0("Mean: ", round(mean(p5$Median.Genes.per.Cell), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    annotate("text",
        x = 120.7, y = 2500, label =
            paste0("SD: ", round(sd(p5$Median.Genes.per.Cell), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    theme_bar()

pdf("QC of 5p.pdf", width = 17, height = 17)
plot_grid(p1, p2, p3, ncol = 1, nrow = 3, align = "v")
dev.off()

# pdf("QC of 5p.pdf", width = 12, height = 16)
# ggdraw() +
#    draw_plot(p1, x = 0, y = 0.66, width = 1, height = 0.33) +
#    draw_plot(p2, x = 0, y = 0.33, width = 1, height = 0.33) +
#    draw_plot(p3, x = 0, y = 0, width = 1, height = 0.33)
# dev.off()


## 3. bcr
theme_bar <- function(..., bg = "white") {
    require(grid)
    theme_classic(...) +
        theme(
            rect = element_rect(fill = bg),
            plot.margin = unit(rep(0.5, 4), "lines"),
            panel.background = element_rect(fill = "transparent", color = "black"),
            panel.border = element_rect(fill = "transparent", color = "transparent"),
            panel.grid = element_blank(), # 去网格线
            axis.title.x = element_blank(), # 去x轴标签,
            axis.title.y = element_blank(),
            # axis.title.y = element_text(face = "bold", size = 8), # y轴标签加粗及字体大小
            axis.text.y = element_text(face = "bold", size = 10), # 坐标轴刻度标签加粗
            axis.ticks.x = element_blank(), # 坐标轴刻度线
            # axis.ticks.margin = unit(0.8,"lines"),
            axis.text.x = element_text(size = 8, face = "bold", angle = 70, hjust = 1, vjust = 1),
            legend.title = element_blank(), # 去除图例标题
            # legend.justification=c(1,0),#图例在画布的位置(绘图区域外)
            legend.position = c(0.39, 0.76), # 图例在绘图区域的位置
            # legend.position='top',#图例放在顶部
            legend.direction = "horizontal", # 设置图例水平放置
            # legend.spacing.x = unit(2, 'cm'),
            legend.text = element_text(face = "bold", size = 11, margin = margin(r = 20)),
            legend.background = element_rect(linetype = "solid", colour = "black"),
            # legend.margin=margin(0,0,-7,0)#图例与绘图区域边缘的距离
            # legend.box.margin =margin(-10,0,0,0)
            plot.title = element_text(size = 13, face = "bold", hjust = 0.5, vjust = -8)
        )
}

p1 <- ggplot(bcr, mapping = aes(x = reorder(sample_id, -Estimated.Number.of.Cells), y = Estimated.Number.of.Cells)) +
    geom_bar(
        stat = "identity",
        fill = "#00AFBB",
        width = 0.6
    ) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 30 * 1000), breaks = seq(0, 30 * 1000, 3000)) +
    labs(title = "Number of cells") +
    annotate("text",
        x = 120, y = 27000, label = paste0("Mean: ", round(mean(bcr$Estimated.Number.of.Cells), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    annotate("text",
        x = 121.1, y = 25500, label =
            paste0("SD: ", round(sd(bcr$Estimated.Number.of.Cells), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    theme_bar() +
    theme(axis.text.x = element_blank())

p2 <- ggplot(bcr, mapping = aes(x = reorder(sample_id, -Mean.Read.Pairs.per.Cell), y = Mean.Read.Pairs.per.Cell)) +
    geom_bar(
        stat = "identity",
        fill = "#FFB300",
        width = 0.6
    ) +
    scale_y_continuous(
        expand = c(0, 0),
        limits = c(0, 1000 * 3500),
        breaks = seq(0, 1000 * 3500, 350000),
        labels = c("0", "350k", "700k", "1.05M", "1.4M", "1.75M", "2.1M", "2.45M", "2.8M", "3.15M", "3.5M")
    ) +
    labs(title = "Mean read pairs per cell") +
    annotate("text",
        x = 120, y = 3.05 * 1000000, label = paste0("Mean: ", round(mean(bcr$Mean.Read.Pairs.per.Cell), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    annotate("text",
        x = 121.1, y = 2.85 * 1000000, label =
            paste0("SD: ", round(sd(bcr$Mean.Read.Pairs.per.Cell), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    theme_bar() +
    theme(axis.text.x = element_blank())

p3 <- ggplot(bcr, mapping = aes(x = reorder(sample_id, -Number.of.Cells.With.Productive.V.J.Spanning.Pair), y = Number.of.Cells.With.Productive.V.J.Spanning.Pair)) +
    geom_bar(
        stat = "identity",
        fill = "#FA2017",
        width = 0.6
    ) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 20000), breaks = seq(0, 20000, 2000)) +
    labs(title = "Number of Cells With Productive V-J Spanning Pair") +
    annotate("text",
        x = 120, y = 16000, label = paste0("Mean: ", round(mean(bcr$Number.of.Cells.With.Productive.V.J.Spanning.Pair), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    annotate("text",
        x = 121.4, y = 14500, label =
            paste0("SD: ", round(sd(bcr$Number.of.Cells.With.Productive.V.J.Spanning.Pair), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    theme_bar()

pdf("QC of bcr.pdf", width = 18, height = 16)
plot_grid(p1, p2, p3, ncol = 1, nrow = 3, align = "v")
dev.off()


## 4. tcr
theme_bar <- function(..., bg = "white") {
    require(grid)
    theme_classic(...) +
        theme(
            rect = element_rect(fill = bg),
            plot.margin = unit(rep(0.5, 4), "lines"),
            panel.background = element_rect(fill = "transparent", color = "black"),
            panel.border = element_rect(fill = "transparent", color = "transparent"),
            panel.grid = element_blank(), # 去网格线
            axis.title.x = element_blank(), # 去x轴标签,
            axis.title.y = element_blank(),
            # axis.title.y = element_text(face = "bold", size = 8), # y轴标签加粗及字体大小
            axis.text.y = element_text(face = "bold", size = 10), # 坐标轴刻度标签加粗
            axis.ticks.x = element_blank(), # 坐标轴刻度线
            # axis.ticks.margin = unit(0.8,"lines"),
            axis.text.x = element_text(size = 8, face = "bold", angle = 70, hjust = 1, vjust = 1),
            legend.title = element_blank(), # 去除图例标题
            # legend.justification=c(1,0),#图例在画布的位置(绘图区域外)
            legend.position = c(0.39, 0.76), # 图例在绘图区域的位置
            # legend.position='top',#图例放在顶部
            legend.direction = "horizontal", # 设置图例水平放置
            # legend.spacing.x = unit(2, 'cm'),
            legend.text = element_text(face = "bold", size = 11, margin = margin(r = 20)),
            legend.background = element_rect(linetype = "solid", colour = "black"),
            # legend.margin=margin(0,0,-7,0)#图例与绘图区域边缘的距离
            # legend.box.margin =margin(-10,0,0,0)
            plot.title = element_text(size = 13, face = "bold", hjust = 0.5, vjust = -8)
        )
}

p1 <- ggplot(tcr, mapping = aes(x = reorder(sample_id, -Estimated.Number.of.Cells), y = Estimated.Number.of.Cells)) +
    geom_bar(
        stat = "identity",
        fill = "#00AFBB",
        width = 0.6
    ) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 10 * 750), breaks = seq(0, 10 * 750, 750)) +
    labs(title = "Number of cells") +
    annotate("text",
        x = 120, y = 6700, label = paste0("Mean: ", round(mean(tcr$Estimated.Number.of.Cells), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    annotate("text",
        x = 120.6, y = 6400, label =
            paste0("SD: ", round(sd(tcr$Estimated.Number.of.Cells), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    theme_bar() +
    theme(axis.text.x = element_blank())

p2 <- ggplot(tcr, mapping = aes(x = reorder(sample_id, -Mean.Read.Pairs.per.Cell), y = Mean.Read.Pairs.per.Cell)) +
    geom_bar(
        stat = "identity",
        fill = "#FFB300",
        width = 0.6
    ) +
    scale_y_continuous(
        expand = c(0, 0)
        # , limits = c(0, 365 * 10000000), breaks = seq(0, 365 * 10000000, 365 * 1000000)
    ) +
    labs(title = "Mean read pairs per cell") +
    annotate("text",
        x = 120, y = 3.2 * 10000000, label = paste0("Mean: ", round(mean(tcr$Mean.Read.Pairs.per.Cell), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    annotate("text",
        x = 121.6, y = 3.05 * 10000000, label =
            paste0("SD: ", round(sd(tcr$Mean.Read.Pairs.per.Cell), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    theme_bar() +
    theme(axis.text.x = element_blank())

p3 <- ggplot(tcr, mapping = aes(x = reorder(sample_id, -Number.of.Cells.With.Productive.V.J.Spanning.Pair), y = Number.of.Cells.With.Productive.V.J.Spanning.Pair)) +
    geom_bar(
        stat = "identity",
        fill = "#FA2017",
        width = 0.6
    ) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 4500), breaks = seq(0, 4500, 450)) +
    labs(title = "Number of Cells With Productive V-J Spanning Pair") +
    annotate("text",
        x = 120, y = 3700, label = paste0("Mean: ", round(mean(tcr$Number.of.Cells.With.Productive.V.J.Spanning.Pair), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    annotate("text",
        x = 121.1, y = 3400, label =
            paste0("SD: ", round(sd(tcr$Number.of.Cells.With.Productive.V.J.Spanning.Pair), 2)),
        color = "purple", size = 5, fontface = "bold"
    ) +
    theme_bar()

pdf("QC of tcr.pdf", width = 18, height = 16)
plot_grid(p1, p2, p3, ncol = 1, nrow = 3, align = "v")
dev.off()


## 5. cell number in 5p, bcr and tcr
theme_bar <- function(..., bg = "white") {
    require(grid)
    theme_classic(...) +
        theme(
            rect = element_rect(fill = bg),
            plot.margin = unit(rep(0.5, 4), "lines"),
            panel.background = element_rect(fill = "transparent", color = "black"),
            panel.border = element_rect(fill = "transparent", color = "transparent"),
            panel.grid = element_blank(), # 去网格线
            axis.title.x = element_blank(), # 去x轴标签,
            axis.title.y = element_blank(),
            # axis.title.y = element_text(face = "bold", size = 8), # y轴标签加粗及字体大小
            axis.text.y = element_text(face = "bold", size = 14), # 坐标轴刻度标签加粗
            axis.text.x = element_text(size = 14, face = "bold", angle = 70, hjust = 1, vjust = 1),
            # axis.ticks = element_line(color='black'),#坐标轴刻度线
            # axis.ticks.margin = unit(0.8,"lines"),
            legend.title = element_blank(), # 去除图例标题
            # legend.justification=c(1,0),#图例在画布的位置(绘图区域外)
            legend.position = c(0.76, 0.86), # 图例在绘图区域的位置
            # legend.position='top',#图例放在顶部
            legend.direction = "horizontal", # 设置图例水平放置
            # legend.spacing.x = unit(2, 'cm'),
            legend.text = element_text(face = "bold", size = 18, margin = margin(r = 20)),
            legend.background = element_rect(linetype = "solid", colour = "black"),
            # legend.margin=margin(0,0,-7,0)#图例与绘图区域边缘的距离
            # legend.box.margin =margin(-10,0,0,0)
            plot.title = element_text(size = 18, hjust = 0.5, face = "bold")
        )
}

dat <- read.table("cell_number.txt", sep = "\t", header = T)
pdf("cell numbers in 3 assays.pdf", width = 45, height = 10)
sample_level <- dat[dat$assay == "5P", ][, 3][order(dat[dat$assay == "5P", ][, 2], decreasing = T)]
ggplot(data = dat, mapping = aes(x = factor(sample_name, levels = sample_level), y = Estimated.Number.of.Cells, fill = factor(assay, levels = c("5P", "TCR", "BCR")))) +
    geom_bar(stat = "identity", width = 0.7, position = position_dodge(0.7)) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 30 * 1000), breaks = seq(0, 30 * 1000, 3000)) +
    scale_fill_manual(values = c("turquoise2", "olivedrab1", "thistle1")) +
    labs(title = "Cell numbers in 3 assays") +
    theme_bar()
dev.off()
