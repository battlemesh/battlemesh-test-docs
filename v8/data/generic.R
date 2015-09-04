# Copyright (c) 2015 by Matthieu Boutier <boutier@univ-paris-diderot.fr>
#                       University of Paris Diderot

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

exit_usage <- function() {
    print("usage: --args <file [file]*>")
    print("usage: --args <directory [directory]>")
    print("    ... and a lot of other options (see the code).")
    q()
}

rotate <- function(x) { c(x[-1], x[1]) }

get_data_ping <- function(csvFile) {
    csvData <- (read.table(csvFile, header=TRUE, sep="",
                           colClasses=c("numeric", "numeric", "numeric", "numeric"))
               )[c("timestamp", "rtt", "ttl", "seq")]
    names(csvData) <- c("time", "rtt", "ttl", "seq")
    t0 <- csvData[1,"time"]
    csvData["time"] <- csvData[,"time"] - t0
    csvData["ttl"] <- 65 - csvData[,"ttl"]

    maxtime <- max(csvData$time, na.rm = TRUE)

    dat1 <- list(data = csvData[c("time", "rtt")],
        t0 = t0,
        type = c("Time", "RTT"),
        unit = c("s", "ms"),
        limitmin = c(0, 0),
        limitmax = c(maxtime, max(csvData$rtt, na.rm = TRUE)),
        summary = summary(csvData$rtt))

    dat2 <- list(data = csvData[c("time", "ttl")],
        t0 = t0,
        type = c("Time", "Hop number: 65-TTL"),
        unit = c("s", "hops"),
        limitmin = c(0, 0),
        limitmax = c(maxtime, max(csvData$ttl, na.rm = TRUE)),
        summary = summary(csvData$ttl))

    # extract packet duplication
    tmp <- aggregate(csvData["time"], FUN=max, by=list(seq=csvData$seq))["time"]
    tmp["dup"] <- aggregate(rep(1, nrow(csvData)), FUN=sum,
        by=list(seq=csvData$seq))$x - 1

    dat3 <- list(data = tmp,
        t0 = t0,
        type = c("Time", "Duplicates"),
        unit = c("s", "count"),
        limitmin = c(0, 0),
        limitmax = c(maxtime, max(tmp$dup, na.rm = TRUE)),
        summary = summary(tmp$dup))
    list(dat1, dat2, dat3)
}

get_data_iperf <- function(csvFile) {
    csvData <- (read.table(csvFile, sep=",", flush=TRUE,
                           colClasses=c("character", "character", "numeric",
                                        "character", "numeric", "numeric",
                                        "character", "numeric", "numeric"))
               )[c(1,7,9)]
    # ignore the last two lines: these are summaries: client and server side.
    csvData <- csvData[1:(nrow(csvData) - 2),]
    t0 <- as.numeric(format(strptime(csvData$V1[1], format="%Y%m%d%H%M%S"), "%s"))
    csvData$V1 <- NULL
    names(csvData) <- c("time", "bitrate")
    csvData$time <- as.numeric(sub("-.*", "", csvData$time))

    dat1 <- list(data = csvData,
        t0 = t0,
        type = c("Time", "Throughput"),
        unit = c("s", "bit/s"),
        limitmin = c(0, 0),
        limitmax = c(max(csvData$time, na.rm = TRUE),
            max(csvData$bitrate, na.rm = TRUE)),
            summary = summary(csvData$bitrate))
    list(dat1)
}

compute_data <- function(csvFile) {
    extension <- sub(".*[.]", "", csvFile)
    if(extension == "csv") {
        get_data_ping(csvFile)
    } else if (extension == "iperf"){
        get_data_iperf(csvFile)
    }
}

get_colors <- function(number) {
#plot(seq(1,100), rep(c(1:10,9:2),10)[1:100], pch=as.character(rep(0:9,10)), col=hsv(seq(0,.99,by=.01),1,1), cex=3)
    hue <- c(0, 9, 16, 29, 26, 36, 44, 50, 54, 58, 64, 72, 77, 81, 85, 91)
    val <- c(1, 1, .8, .7,  1, .4,  1,  1,  1,  1,  1, .7,  1,  1,  1,  1)
    sat <- c(1, 1, .7,  1,  1,  1,  1,  1,  1,  1, .5,  1,  1, .6,  1,  1)
    col <- hsv(hue / 100, sat, val)

    pref <- col[c(1, 2, 3, 4, 7, 8, 10, 12, 14)]

    if (number == 1) {
        ret <- c("#000000", "#000000")
    } else if (number <= length(pref)) {
        tmp <- floor(seq(1:number) * length(pref) / number)
        tmp <- tmp - tmp[1] + 1
        ret <- pref[tmp]
    } else if (number <= length(col)) {
        tmp <- floor(seq(1:number) * length(col) / number)
        tmp <- tmp - tmp[1] + 1
        ret <- col[tmp]
    } else {
        ret <- c("#000000", col)
    }
#   plot(rep(1, 16), pch=20, col = ret, cex = 8)
    ret
}

# Draw axis and sub-graduations by hand.
draw_axis <- function(i, color = "black") {
    axis_labels = axis(i, col = color)
    len = length(axis_labels)
    maxVal = axis_labels[len] * 2
    by_step = axis_labels[len] - axis_labels[len - 1]
        axis(i, at = seq(from = 0, to = maxVal, by = by_step),
             tcl = -.75, col = color)
    first_digit = as.numeric(substr(as.character(by_step), 1, 1))
    if (first_digit == 1 || first_digit %% 2 == 0) {
        div = 2
    } else if (first_digit %% 5 == 0) {
        div = 5
    }
    axis(i, at = seq(from = 0, to = maxVal, by = by_step/div),
         tcl = -.5 , col = color, labels = FALSE)
    first_digit = as.numeric(substr(as.character(by_step/div), 1, 1))
    if (first_digit == 1 || first_digit %% 2 == 0) {
        div = div * 2
    } else if (first_digit %% 5 == 0) {
        div = div * 5
    }
    axis(i, at = seq(from = 0, to = maxVal, by = by_step/div),
         tcl = -.25 , col = color, labels = FALSE)
}

draw_legend <- function(lnames, col, lty, pch) {
    par(xpd = NA)
    legend(flag_legend, legend = lnames,
           col=col,
           ncol=1, cex = 1,
           lwd = 1, lty = lty, pch=pch,
           inset = flag_legend_dec, bg = "white", x.intersp = 1)
    par(xpd = FALSE)
}

draw_axis_and_legend <- function(plotdat, title = NULL, legend = FALSE) {
    draw_axis(2)
    if (flag_grid) grid(nx=NULL, ny=NA)
    mtext(plotdat$y_label, 2, line = 2, las = 0)
    draw_axis(1)
    if (flag_grid) grid(nx=NULL, ny=NA)
    mtext(plotdat$x_label, 1, line = 2, las = 0)
    if (!flag_no_title && !is.null(title))
        mtext(title, side = 3, line = 0, cex = 1, las = 0)
    if (legend)
        draw_legend(plotdat$legend_names, plotdat$legend_col,
                    plotdat$legend_lty, plotdat$legend_pch)
}

open_device <- function(filename, filenum = 0, type = flag_output_type) {
    filedat <- list(filename = filename, filenum = filenum + 1, type = type,
                    graph_per_page = 0, num_graph = 0, force_separated = FALSE)
    filename <- sub(paste(".", type, "$", sep=""), "", filename)
    if (filenum != 0)
        filename <- paste(filename, "-", filenum, sep="")
    filename <- paste(filename, type, sep=".")
    print(paste("drawing:", filename))
    f_pixels <- function() {
        do.call(type, list(file = filename, width = flag_width,
                height = flag_height, units = "in", res = 300))
    }
    f_other <- function() {
        do.call(type, list(file = filename, width = flag_width,
                height = flag_height))
    }
    if(Sys.info()[["sysname"]] == "Darwin") {
        f_quartz <- function() {
            quartz(file = filename, width = flag_width,
                   height = flag_height, type = type, dpi=300)
        }
        # On MacOS, the best is to use quartz.
        tryCatch(f_quartz(), error = function(e) { f_other() })
    } else {
        # Works on Linux:
        tryCatch(f_pixels(), error = function(e) {f_other()})
    }
    filedat
}

reopen_device <- function(filedat) {
    dev.off()
    open_device(filedat$filename, filedat$filenum, filedat$type)
}

normalize <- function(data, min_t0, tmax, max_throughput) {
    if (max_throughput > 1000000000) {
        unit <- "Gbit/s"
        factor <- 1000000000
    } else if (max_throughput > 1000000) {
        unit <- "Mbit/s"
        factor <- 1000000
    } else if (max_throughput > 1000) {
        unit <- "Kbit/s"
        factor <- 1000
    } else {
        unit <- "bit/s"
        factor <- 1
    }
    i <- 1
    while(i <= length(data)) {
        data[[i]]$data$time <- data[[i]]$data$time + (data[[i]]$t0 - min_t0)
        data[[i]]$tmax <- tmax
        if (data[[i]]$unit[2] == "bit/s") {
            data[[i]]$data$bitrate = data[[i]]$data$bitrate / factor
            data[[i]]$limitmin[2] = data[[i]]$limitmin[2] / factor
            data[[i]]$limitmax[2] = data[[i]]$limitmax[2] / factor
            data[[i]]$unit[2] = unit
        }
        i <- i + 1
    }
    data
}

rescale <- function(dat) {
    for (i in 1:length(dat$type)) {
        if (dat$type[i] == "Time" && (flag_mintime > 0 || flag_maxtime < Inf)) {
            dat$limitmin[i] = flag_mintime
            dat$limitmax[i] = flag_maxtime
            dat$data <- dat$data[flag_mintime <= dat$data$time &
                                 dat$data$time <= flag_maxtime,]
        } else if (dat$type[i] == "RTT" && flag_maxrtt < Inf) {
            dat$limitmax[i] = flag_maxrtt
        } else if (dat$type[i] == "Duplicates") {
            # not implemented
        } else if (dat$type[i] == "Hop number: 65-TTL") {
            # not implemented
        } else if (dat$type[i] == "Throughput") {
            # not implemented
        }
    }
    dat
}

draw_ecdf <- function(data1, plotdat, stack_graph) {
    dat <- data1$data
    name <- names(dat)[2]
    point_type <- data1$plotattr$point
    line_type <- data1$plotattr$line
    color <- data1$plotattr$color
    if(stack_graph)
        par(new = TRUE)
    tmpDat <- sort(dat[,name])
    n <- length(tmpDat)
    xmin = data1$limitmin[2]
    xmax = data1$limitmax[2]
    if (xmax == 0) { xmax = 1 }
    plot(tmpDat,
         (1:n) / n,
         xlim = c(0, xmax), ylim = c(0, 1),
         xlab = "", ylab = "",
         pch = point_type, col = color, cex = .5, lwd = 2,
         bty = "o", type = "s",
         axes = FALSE, lty = line_type)
    plotdat$legend_col   <- c(plotdat$legend_col, color)
    plotdat$legend_lty   <- c(plotdat$legend_lty, line_type)
    plotdat$legend_pch   <- c(plotdat$legend_pch, point_type)
    plotdat$y_label = expression(hat(F)[n](x))
    plotdat$x_label = paste(sep="", data1$type[2], " (", data1$unit[2], ")")
    if(!stack_graph) {
        draw_axis_and_legend(plotdat)
    }
    plotdat
}

draw_normal <- function(data1, plotdat, stack_graph) {
    dat <- data1$data
    name <- names(dat)[2]
    point_type <- data1$plotattr$point
    line_type <- data1$plotattr$line
    color <- data1$plotattr$color
    if(stack_graph) {
        par(new = TRUE)
    }
    tmpDat <- dat[,name]
    n <- length(tmpDat)
    xmin = data1$limitmin[1]
    xmax = data1$limitmax[1]
    if (xmax == 0) { xmax = 1 }
    xmin = data1$limitmin[1]
    ymax = data1$limitmax[2]
    if (ymax == 0) { ymax = 1 }
    plot(dat$time,
         tmpDat,
         xlim = c(xmin, xmax), ylim = c(0, ymax),
         xlab = "", ylab = "",
         pch = point_type, col = color, cex = .5,
         bty = "o", type = "s",
         axes = FALSE, lty = line_type)
    plotdat$legend_col   <- c(plotdat$legend_col, color)
    plotdat$legend_lty   <- c(plotdat$legend_lty, line_type)
    plotdat$legend_pch   <- c(plotdat$legend_pch, point_type)
    plotdat$y_label = paste(sep="", data1$type[2], " (", data1$unit[2], ")")
    plotdat$x_label = paste(sep="", data1$type[1], " (", data1$unit[1], ")")
    if(!stack_graph) {
        draw_axis_and_legend(plotdat)
    }
    plotdat
}

reset_plotdat <- function() {
    list(legend_names = c(), legend_col = c(), legend_pch = c(), legend_lty = c(),
        x_label = "", y_label = "", filename = flag_filename, num_graph = 0)
}

new_page <- function(filedat, force_separated=FALSE) {
    force_separated <- force_separated || filedat$force_separated;
    if (filedat$num_graph > 0) {
        if (filedat$type != "pdf") {
            filedat <- reopen_device(filedat)
        }
    }

    if (force_separated || flag_separate_output) {
        par(mfrow = c(1, 1), mar = c(3,4,1,1) + 0.1, bg = "white")
        filedat$graph_per_page <- 1
    } else {
        par(mfrow = c(2, 2), mar = c(3,4,1,1) + 0.1, bg = "white")
        filedat$graph_per_page <- 4
    }
    plot(0, type="n", xlab="", ylab="", main="", axes = FALSE)
    par(new = TRUE)

    filedat$num_graph <- 0
    filedat$force_separated <- force_separated
    filedat
    # reset_plotdat()
}

new_graph <- function(filedat) {
    if (filedat$num_graph > 0 &&
        (filedat$num_graph %% filedat$graph_per_page) == 0) {
        filedat <- new_page(filedat)
    }
    filedat$num_graph <- filedat$num_graph + 1
    filedat
}

draw_graph <- function(csvFiles, filename="generic") {
    data <- list()
    min_t0 <- Inf
    tmax <- 0
    max_throughput <- 0
    curve_num <- 0
    for (f in csvFiles) {
        print(paste("Computing data:", f))
        data <- c(data, compute_data(f))
    }

    for (i in 1:length(data)) {
        dat = data[[i]]
        min_t0 = min(min_t0, dat$t0)
        tmax = max(tmax, max(dat$data$time))
        if (!is.na(dat$unit[2]) && dat$unit[2] == "bit/s") {
            max_throughput <- max(max_throughput, dat$data$bitrate)
        }
        curve_num <- curve_num + (length(dat$type) - 1)
        data[[i]] = rescale(dat)
    }

    # normalize data
    data <- normalize(data, min_t0, tmax, max_throughput)

    if (flag_summary_only)
        return(data)

    # choose the palette, and line and point types.
    if (length(flag_palette) == 0) {
        palette <- get_colors(curve_num)
    } else {
        palette <- flag_palette
    }
    point_types <- 0:24
    line_types <- 1:6
    for (i in 1:length(data)) {
        data[[i]]$plotattr$color <- palette[1]
        palette <- rotate(palette)
        data[[i]]$plotattr$point <- point_types[1]
        point_types <- rotate(point_types)
        data[[i]]$plotattr$line <- line_types[1]
        line_types <- rotate(line_types)
    }

    # set output
    filedat <- open_device(filename)

    # Draw ECDF curves
    filedat <- new_page(filedat)
    plotdat <- reset_plotdat()

    # Draw single plots
    for (i in 1:length(data)) {
        filedat <- new_graph(filedat)
        plotdat <- draw_ecdf(data[[i]], plotdat, FALSE)
    }

    plotdat <- reset_plotdat()
    # Draw all together
    filedat <- new_graph(filedat)
    plot(0, type="n", xlab="", ylab="", main="", axes = FALSE) # create empty graph.
    for (i in 1:length(data)) {
        plotdat <- draw_ecdf(data[[i]], plotdat, TRUE)
    }
    box(bty="l")
    draw_axis(2)
    if (flag_grid) {
        grid(nx=NULL, ny=NA)
    }
    mtext(expression(hat(F)[n](x)), 2, line = 2, las = 0)
    mtext("All together (no scale)", 1, line = 1, las = 0)

    # Draw normal curves
    filedat <- new_page(filedat)
    plotdat <- reset_plotdat()

    # Draw single plots
    for (i in 1:length(data)) {
        filedat <- new_graph(filedat)
        plotdat <- draw_normal(data[[i]], plotdat, FALSE)
    }

    # Draw all together
    plotdat <- reset_plotdat()
    filedat <- new_graph(filedat)
    plot(0, type="n", xlab="", ylab="", main="", axes = FALSE) # create empty graph.
    for (i in 1:length(data)) {
        plotdat <- draw_normal(data[[i]], plotdat, TRUE)
    }
    box(bty="l")
    draw_axis(1)
    if (flag_grid) {
        grid(nx=NULL, ny=NA)
    }
    mtext("All together (no scale)", 2, line = 1, las = 0)
    mtext(paste(sep="", data[[1]]$type[1], " (", data[[1]]$unit[1], ")"),
          1, line = 2, las = 0)

#    draw_legend(legend_names, legend_col, legend_lty, legend_pch)
#    mtext(document_name, side = 3, line = 2, cex = 2.2, las = 0)

    rc <- dev.off()
    data
}

normalize_summary <- function(data) {
    types <- sapply(data, function(d){d$type[2]})
    max <- sapply(data, function(d){max(d$limitmax[2],na.rm = TRUE)})
    limitmax <- aggregate(max, FUN = max, by = list(type = types))
    min <- sapply(data, function(d){min(d$limitmin[2],na.rm = TRUE)})
    limitmin <- aggregate(min, FUN = min, by = list(type = types))
    for (i in 1:length(data)) {
        data[[i]]$limitmax[2] <- limitmax$x[limitmax$type == data[[i]]$type[2]]
        data[[i]]$limitmin[2] <- limitmin$x[limitmin$type == data[[i]]$type[2]]
    }
    data
}

`[.dataclass` <- function(x,i) {
    class(x) <- "list"
    structure(x[i], class="dataclass")
}

`>.dataclass` <- function(e1, e2) {
    e1[[1]]$type[2] > e2[[1]]$type[2] ||
    e1[[1]]$summary["3rd Qu."] > e2[[1]]$summary["3rd Qu."]
}

`==.dataclass` <- function(e1, e2) {
    e1[[1]]$type[2] == e2[[1]]$type[2] &&
    e1[[1]]$summary["3rd Qu."] == e2[[1]]$summary["3rd Qu."]
}

draw_summary <- function(data, protonames, all_in_one = TRUE, mode="ecdf") {
    print(paste("Draw", mode, "summary"))
    class(data) <- "dataclass"
    data <- sort(data)
    type <- data[[1]]$type[2]
    unit <- data[[1]]$unit[2]

    data <- normalize_summary(data)

    filedat <- open_device(paste(names(data[[1]]$data)[2], "-", mode, "-summary", sep=""))
    filedat <- new_page(filedat, force_separated = TRUE)
    plotdat <- reset_plotdat()
    for (dat in data) {
        if (type != dat$type[2]) {
            if (all_in_one)
                draw_axis_and_legend(plotdat, title = type, legend = TRUE)
            dev.off()
            type <- dat$type[2]
            unit <- dat$unit[2]
            filedat <- open_device(paste(names(dat$data)[2], "-", mode, "-summary", sep=""))
            filedat <- new_page(filedat, force_separated = TRUE)
            plotdat <- reset_plotdat()
        }
        plotdat$legend_names <- c(plotdat$legend_names, dat$name)
        if (mode == "ecdf") {
            plotdat <- draw_ecdf(dat, plotdat, all_in_one)
        } else if (mode == "normal") {
            plotdat <- draw_normal(dat, plotdat, all_in_one)
        }
        if (!all_in_one)
            mtext(dat$name, side = 3, line = 0, cex = 1, las = 0)
    }
    if (all_in_one)
        draw_axis_and_legend(plotdat, title = type, legend = TRUE)
    dev.off()
}

# program begins
argv <- commandArgs(TRUE)
argc <- length(argv)
if(argc <= 0)
    exit_usage()

# parse options
flag_mintime <- 0
flag_maxtime <- Inf
flag_maxrtt <- Inf
flag_lang <- "en"
flag_width <- 12.8
flag_height <- 8
flag_filename <- "generic"
flag_output_type <- "pdf"
flag_separate_output <- FALSE
flag_grid <- FALSE
flag_palette <- NULL
flag_summary_palette <- NULL
flag_legend <- "bottomright"
flag_legend_dec <- c(0,0)
flag_no_title <- FALSE
flag_summary_only <- FALSE
recurse <- TRUE

i <- 1
while(i <= argc) {
    if(argv[i] == "--mintime") {
        flag_mintime <- as.numeric(argv[i+1])
    } else if(argv[i] == "--maxtime") {
        flag_maxtime <- as.numeric(argv[i+1])
    } else if(argv[i] == "--maxrtt") {
        flag_maxrtt <- as.numeric(argv[i+1])
    } else if(argv[i] == "--lang") {
        flag_lang <- argv[i+1]
    } else if(argv[i] == "--width") {
        flag_width <- as.numeric(argv[i+1])
    } else if(argv[i] == "--height") {
        flag_height <- as.numeric(argv[i+1])
    } else if(argv[i] == "--out") {
        flag_filename <- paste(getwd(), sep="/", argv[i+1])
    } else if(argv[i] == "--out-type") {
        flag_output_type <- argv[i+1]
    } else if(argv[i] == "--palette") {
        # --palette "#FF000 #00FF00 ..."
        flag_palette <- strsplit(argv[i+1], " ")[[1]]
    } else if(argv[i] == "--summary-palette") {
        flag_summary_palette <- strsplit(argv[i+1], " ")[[1]]
    } else if(argv[i] == "--legend") {
        flag_legend <- argv[i+1]
    } else if(argv[i] == "--legend-in-v") {
        flag_legend_dec[2] <- as.numeric(argv[i+1])
    } else if(argv[i] == "--legend-in-h") {
        flag_legend_dec[1] <- as.numeric(argv[i+1])
    } else { # 1 argument cases
        if(argv[i] == "--no-recurse") {
            recurse <- FALSE
        } else if(argv[i] == "--no-title") {
            flag_no_title <- TRUE
        } else if(argv[i] == "--grid") {
            flag_grid <- TRUE
        } else if(argv[i] == "--separate-output") {
            flag_separate_output <- TRUE
        } else if(argv[i] == "--summary-only") {
            flag_summary_only <- TRUE
        } else {
            break   # quit loop
        }
        i <- i + 1  # skip 1 argument
        next
    }
    i <- i + 2      # skip 2 arguments
}
if (i <= argc) {
    argv <- argv[i:argc]
} else {
    argv <- NULL
}
argc <- argc - i + 1

enter <- function(pwd) {
    data <- NULL
    print(paste("entering", pwd))
    setwd(pwd)
    csvFiles <- list.files(".", pattern="^(ping[.]csv|iperf)$", recursive=FALSE)
    if(length(csvFiles) > 0) {
        tryCatch({
            data <- draw_graph(csvFiles, basename(pwd))
        }, error = function(w) {
            print(paste(w))
        })
    } else {
        alldata <- list()
        subdir <- basename(list.dirs(".", recursive=FALSE))
        if (length(flag_summary_palette) == 0) {
            spalette <- get_colors(length(subdir))
        } else {
            spalette <- flag_summary_palette
        }
        point_types <- 0:24
        line_types <- 1:6
        for(d in subdir) {
            data <- enter(paste(pwd, d, sep="/"))
            if (is.null(data)) next
            setwd(pwd)
            for (i in 1:length(data)) {
                data[[i]]$name <- d
                data[[i]]$plotattr$color <- spalette[1]
                data[[i]]$plotattr$point <- point_types[1]
                data[[i]]$plotattr$line <- line_types[1]
            }
            spalette <- rotate(spalette)
            point_types <- rotate(point_types)
            line_types <- rotate(line_types)
            alldata <- c(alldata, data)
        }
        if(length(alldata) > 0) {
            draw_summary(alldata, subdir, all_in_one = T, mode="ecdf")
            draw_summary(alldata, subdir, all_in_one = T, mode="normal")
            data <- NULL
        }
    }
    data
}

if(!file.info(argv[1])$isdir) {
    invisible(draw_graph(argv, flag_filename))
} else {
    pwd <- getwd()
    # only one dir
    invisible(enter(normalizePath(argv[1])))
    setwd(pwd)
}
if (length(argv) > 1) {
    print(paste("Ignoring other arguments:", toString(argv)))
}
print("finished")

